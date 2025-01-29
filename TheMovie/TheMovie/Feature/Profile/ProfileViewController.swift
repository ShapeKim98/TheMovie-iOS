//
//  ProfileViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/25/25.
//

import UIKit

import SnapKit

protocol ProfileViewControllerDelegate: AnyObject {
    func dismiss()
}

final class ProfileViewController: UIViewController {
    private lazy var profileButton = TMProfileButton(
        profileImageId ?? 0,
        size: 100
    )
    private let nicknameTextField = NicknameTextField()
    private let completeButton = TMBoarderButton(title: "완료")
    
    @UserDefault(
        forKey: .userDefaults(.profileImageId),
        defaultValue: (0...11).randomElement() ?? 0
    )
    private var profileImageId: Int?
    @UserDefault(forKey: .userDefaults(.nickname))
    private var nickname: String?
    @UserDefault(forKey: .userDefaults(.profileCompleted))
    private var isProfileCompleted: Bool?
    @UserDefault(forKey: .userDefaults(.profileDate))
    private var profileDate: String?
    
    private var isValidNickname = false {
        didSet { didSetIsValidNickname() }
    }
    private let mode: Mode
    
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
    
    func configureProfileButton() {
        profileButton.isSelected = true
        profileButton.addAction(
            UIAction(handler: profileButtonTouchUpInside),
            for: .touchUpInside
        )
        view.addSubview(profileButton)
    }
    
    func configureNicknameTextField() {
        nicknameTextField.textField.text = nickname
        nicknameTextField.textField.delegate = self
        if let nickname {
            updateTextFieldState(nickname)
        }
        view.addSubview(nicknameTextField)
    }
    
    func configureCompleteButton() {
        completeButton.isHidden = mode == .edit
        completeButton.isEnabled = nickname != nil
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
    func didSetIsValidNickname() {
        completeButton.isEnabled = isValidNickname
        navigationItem.rightBarButtonItem?.isEnabled = isValidNickname
    }
}

// MARK: Functions
private extension ProfileViewController {
    func profileButtonTouchUpInside(_ action: UIAction) {
        guard let profileImageId else { return }
        let viewController = ProfileImageViewController(
            selectedId: profileImageId,
            title: mode.profileImage
        )
        viewController.delegate = self
        push(viewController)
    }
    
    func completeButtonTouchUpInside(_ action: UIAction) {
        guard let text = nicknameTextField.textField.text else {
            return
        }
        nickname = text
        profileImageId = profileButton.id
        isProfileCompleted = true
        profileDate = Date.now.toString(format: .yy_o_MM_o_dd)
        
        switchRoot(ViewController())
    }
    
    func updateTextFieldState(_ text: String) {
        isValidNickname = false
        guard (2 <= text.count && text.count < 10) else {
            nicknameTextField.updateState(.글자수_조건에_맞지_않는_경우)
            return
        }
        guard !text.contains(/[@#$%]/) else {
            nicknameTextField.updateState(.특수문자_조건에_맞지_않는_경우)
            return
        }
        guard !text.contains(/\d/) else {
            nicknameTextField.updateState(.숫자_조건에_맞지_않는_경우)
            return
        }
        isValidNickname = true
        nicknameTextField.updateState(.조건에_맞는_경우)
    }
    
    func backButtonTouchUpInside(_ action: UIAction) {
        dismiss(animated: true)
    }
    
    func saveButtonTouchUpInside(_ action: UIAction) {
        guard let text = nicknameTextField.textField.text else {
            return
        }
        nickname = text
        profileImageId = profileButton.id
        isProfileCompleted = true
        dismiss(animated: true) { [weak self] in
            guard let `self` else { return }
            delegate?.dismiss()
        }
    }
    
    @objc
    func tapGestureRecognizer(_ action: UITapGestureRecognizer) {
        nicknameTextField.textField.resignFirstResponder()
    }
}

extension ProfileViewController: ProfileImageViewControllerDelegate {
    func didSetSelectedId(selectedId: Int) {
        profileButton.setProfile(id: selectedId)
        profileButton.id = selectedId
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newText = text.prefix(range.location) + string
        
        updateTextFieldState(String(newText))
        return true
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
    ProfileViewController(mode: .setting)
}
