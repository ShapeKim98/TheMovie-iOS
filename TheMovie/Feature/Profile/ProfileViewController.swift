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

    private let mode: Mode
    
    private let viewModel = ProfileViewModel()
    
    weak var delegate: (any ProfileViewControllerDelegate)?
    
    init(mode: Mode) {
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
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
        
        configureGestureRecognizer()
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
            make.top.equalTo(nicknameTextField.stateLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = mode.title
        if mode == .edit {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                primaryAction: UIAction(handler: backButtonTouchUpInside)
            )
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "저장",
                primaryAction: UIAction(handler: saveButtonTouchUpInside)
            )
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
            UIAction(handler: profileButtonTouchUpInside),
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
        completeButton.isEnabled = viewModel.nickname != nil
        completeButton.addAction(
            UIAction(handler: completeButtonTouchUpInside),
            for: .touchUpInside
        )
        view.addSubview(completeButton)
    }
    
    func configureGestureRecognizer() {
        view.gestureRecognizers = [
            UITapGestureRecognizer(
                target: self,
                action: #selector(tapGestureRecognizer)
            )
        ]
    }
}

// MARK: Data Bindings
private extension ProfileViewController {
    func dataBinding() {
        Task { [weak self] in
            guard let self else { return }
            for await output in viewModel.output {
                switch output {
                case let .profileImageId(profileImageId):
                    bindedProfileImageId(profileImageId)
                case let .isValidNickname(isValidNickname):
                    bindedIsValidNickname(isValidNickname)
                case let .nicknameState(nicknameState):
                    bindedNicknameState(nicknameState)
                }
            }
        }
    }
    
    func bindedProfileImageId(_ profileImageId: Int?) {
        guard let profileImageId else { return }
        profileButton.setProfile(id: profileImageId)
        profileButton.id = profileImageId
    }
    
    func bindedIsValidNickname(_ isValidNickname: Bool) {
        completeButton.isEnabled = isValidNickname
        navigationItem.rightBarButtonItem?.isEnabled = isValidNickname
    }
    
    func bindedNicknameState(_ nicknameState: NicknameTextField.State) {
        nicknameTextField.updateState(nicknameState)
    }
}

// MARK: Functions
private extension ProfileViewController {
    func profileButtonTouchUpInside(_ action: UIAction) {
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
    
    func completeButtonTouchUpInside(_ action: UIAction) {
        viewModel.input(.completeButtonTouchUpInside(text: nicknameTextField.textField.text))
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
        guard
            let completeButtonTouchUpInside = delegate?.completeButtonTouchUpInside
        else { return }
        completeButtonTouchUpInside()
    }
    
    func backButtonTouchUpInside(_ action: UIAction) {
        dismiss(animated: true)
    }
    
    func saveButtonTouchUpInside(_ action: UIAction) {
        viewModel.input(.saveButtonTouchUpInside(text: nicknameTextField.textField.text))
        
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
        dismiss(animated: true) { [weak self] in
            guard let `self` else { return }
            guard let dismiss = delegate?.dismiss else { return }
            dismiss()
        }
    }
    
    @objc
    func tapGestureRecognizer(_ action: UITapGestureRecognizer) {
        nicknameTextField.textField.resignFirstResponder()
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

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: ProfileViewController(mode: .setting))
}
