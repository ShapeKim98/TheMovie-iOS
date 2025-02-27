//
//  ProfileViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/25/25.
//

import UIKit

import SnapKit

@objc protocol ProfileViewControllerDelegate: AnyObject {
    @objc optional func dismiss()
    
    @objc optional func completeButtonTouchUpInside()
}

final class ProfileViewController: UIViewController {
    private lazy var profileButton = TMProfileButton(
        viewModel.model.profileImageId ?? 0,
        size: 100
    )
    private let nicknameTextField = NicknameTextField()
    private let completeButton = TMBoarderButton(title: "완료")
    private lazy var mbtiCollectionView = {
        configureMBTICollectionView()
    }()
    private let mbtiLabel = UILabel()
    
    private let mode: Mode
    
    private let mbtiElements = ["E", "I", "S", "N", "T", "F", "J", "P"]
    
    private let viewModel = ProfileViewModel()
    
    weak var delegate: (any ProfileViewControllerDelegate)?
    
    init(mode: Mode) {
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit { print("ProfileViewController deinitialized") }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        dataBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nicknameTextField.textField.becomeFirstResponder()
    }
}

// MARK: Configure Views
private extension ProfileViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureSheet()
        
        configureNavigation()
        
        configureProfileButton()
        
        configureNicknameTextField()
        
        configureCompleteButton()
        
        configureMBTILabel()
    }
    
    func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        mbtiCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(52)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(200 + 24)
            make.height.equalTo(100 + 8)
        }
        
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(mbtiCollectionView).inset(8)
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = mode.title
        if mode == .edit {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                primaryAction: UIAction { [weak self] _ in
                    self?.backButtonTouchUpInside()
                }
            )
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "저장",
                primaryAction: UIAction { [weak self] _ in
                    self?.saveButtonTouchUpInside()
                }
            )
            navigationItem.rightBarButtonItem?.isEnabled = viewModel.model.isValidProfile
        }
        setTMBackButton()
    }
    
    func configureSheet() {
        guard let sheet = sheetPresentationController else { return }
        sheet.presentingViewController.overrideUserInterfaceStyle = .dark
        sheet.prefersGrabberVisible = true
    }
    
    func configureProfileButton() {
        profileButton.isSelected = true
        profileButton.addAction(
            UIAction { [weak self] _ in
                self?.profileButtonTouchUpInside()
            },
            for: .touchUpInside
        )
        view.addSubview(profileButton)
    }
    
    func configureNicknameTextField() {
        nicknameTextField.textField.text = viewModel.nickname
        nicknameTextField.textField.delegate = self
        nicknameTextField.updateState(viewModel.model.nicknameState)
        view.addSubview(nicknameTextField)
    }
    
    func configureCompleteButton() {
        completeButton.isHidden = mode == .edit
        completeButton.isEnabled = viewModel.model.isValidProfile
        completeButton.addAction(
            UIAction { [weak self] _ in
                self?.completeButtonTouchUpInside()
            },
            for: .touchUpInside
        )
        view.addSubview(completeButton)
    }
    
    func configureMBTICollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: 50, height: 50)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            MBTICollectionViewCell.self,
            forCellWithReuseIdentifier: .mbtiCollectionCell
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
        
        return collectionView
    }
    
    func configureMBTILabel() {
        mbtiLabel.text = "MBTI"
        mbtiLabel.textColor = .tm(.semantic(.text(.primary)))
        mbtiLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        view.addSubview(mbtiLabel)
    }
}

// MARK: Data Bindings
private extension ProfileViewController {
    func dataBinding() {
        let outputs = viewModel.output
        
        Task { [weak self] in
            for await output in outputs {
                switch output {
                case let .profileImageId(profileImageId):
                    self?.bindedProfileImageId(profileImageId)
                case let .isValidProfile(isValidProfile):
                    self?.bindedIsValidProfile(isValidProfile)
                case let .nicknameState(nicknameState):
                    self?.bindedNicknameState(nicknameState)
                case let .selectedMBTI(selectedMBTI):
                    self?.bindedSelectedMBTI(selectedMBTI)
                }
            }
        }
    }
    
    func bindedProfileImageId(_ profileImageId: Int?) {
        guard let profileImageId else { return }
        print(#function)
        profileButton.setProfile(id: profileImageId)
        profileButton.id = profileImageId
    }
    
    func bindedIsValidProfile(_ isValidProfile: Bool) {
        print(#function)
        completeButton.isEnabled = isValidProfile
        navigationItem.rightBarButtonItem?.isEnabled = isValidProfile
    }
    
    func bindedNicknameState(_ nicknameState: NicknameTextField.State) {
        print(#function)
        nicknameTextField.updateState(nicknameState)
    }
    
    func bindedSelectedMBTI(_ selectedMBTI: [MBTIType: String]) {
        print(#function)
        let seletectValues = Set(selectedMBTI.values)
        for (index, element) in mbtiElements.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            if seletectValues.contains(element) {
                mbtiCollectionView.selectItem(
                    at: indexPath,
                    animated: true,
                    scrollPosition: []
                )
            } else {
                mbtiCollectionView.deselectItem(
                    at: indexPath,
                    animated: true
                )
            }
        }
    }
}

// MARK: Functions
private extension ProfileViewController {
    func profileButtonTouchUpInside() {
        guard
            let profileImageId = viewModel.model.profileImageId
        else { return }
        let viewModel = ProfileImageViewModel(selectedId: profileImageId)
        viewModel.delegate = self.viewModel
        let viewController = ProfileImageViewController(
            title: mode.profileImage,
            viewModel: viewModel
        )
        push(viewController)
    }
    
    func completeButtonTouchUpInside() {
        viewModel.input(.completeButtonTouchUpInside(text: nicknameTextField.textField.text))
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
        guard
            let completeButtonTouchUpInside = delegate?.completeButtonTouchUpInside
        else { return }
        completeButtonTouchUpInside()
    }
    
    func backButtonTouchUpInside() {
        dismiss(animated: true)
    }
    
    func saveButtonTouchUpInside() {
        viewModel.input(.saveButtonTouchUpInside(text: nicknameTextField.textField.text))
        
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
        dismiss(animated: true) { [weak self] in
            self?.delegate?.dismiss?()
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .mbtiCollectionCell,
            for: indexPath
        ) as? MBTICollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        let element = mbtiElements[indexPath.item]
        cell.forItemAt(element)
        let seletectValues = Set(viewModel.model.selectedMBTI.values)
        if seletectValues.contains(element) {
            collectionView.selectItem(
                at: indexPath,
                animated: true,
                scrollPosition: []
            )
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input(.collectionViewDidSelectItemAt(element: mbtiElements[indexPath.item]))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.input(.collectionViewDidDeselectItemAt(element: mbtiElements[indexPath.item]))
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.input(.textFieldShouldChangeCharactersIn(
            text: textField.text,
            range: range,
            string: string
        ))
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ProfileViewController {
    enum Mode {
        case setting
        case edit
        
        var title: String {
            switch self {
            case .setting: return "프로필 설정"
            case .edit:
                return "프로필 편집"
            }
        }
        
        var profileImage: String {
            switch self {
            case .setting: return "프로필 이미지 설정"
            case .edit:
                return "프로필 이미지 편집"
            }
        }
    }
}

fileprivate extension String {
    static let mbtiCollectionCell = "MBTICollectionViewCell"
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: ProfileViewController(mode: .setting))
}
