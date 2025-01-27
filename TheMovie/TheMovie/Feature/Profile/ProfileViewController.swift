//
//  ProfileViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/25/25.
//

import UIKit

import SnapKit

final class ProfileViewController: UIViewController {
    private lazy var profileButton = TMProfileButton(
        profileImageId ?? 0,
        size: 100
    )
    private let nicknameTextField = NicknameTextField()
    private let completeButton = TMBoarderButton(title: "완료")
    
    @UserDefaults(
        forKey: .userDefaults(.profileImageId),
        defaultValue: (0...11).randomElement() ?? 0
    )
    private var profileImageId: Int?
    @UserDefaults(forKey: .userDefaults(.nickname))
    private var nickname: String?
    @UserDefaults(forKey: .userDefaults(.profileCompleted))
    private var isProfileCompleted: Bool?
    @UserDefaults(forKey: .userDefaults(.profileDate))
    private var profileDate: String?
    
    private var isValidNickname = false {
        didSet { didSetIsValidNickname() }
    }
    private let mode: Mode
    
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
}

// MARK: Configure Views
private extension ProfileViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureNavigation()
        
        configureProfileButton()
        
        configureNicknameTextField()
        
        configureCompleteButton()
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
        completeButton.isEnabled = nickname != nil
        completeButton.addAction(
            UIAction(handler: completeButtonTouchUpInside),
            for: .touchUpInside
        )
        view.addSubview(completeButton)
    }
}

// MARK: Data Bindings
private extension ProfileViewController {
    func didSetIsValidNickname() {
        completeButton.isEnabled = isValidNickname
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
        
        switchRoot(DayViewController())
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
}

extension ProfileViewController: ProfileImageViewControllerDelegate {
    func didSetSelectedId(selectedId: Int) {
        profileButton.setProfile(id: selectedId)
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
    final class NicknameTextField: UIView {
        enum State {
            case 조건에_맞는_경우
            case 글자수_조건에_맞지_않는_경우
            case 특수문자_조건에_맞지_않는_경우
            case 숫자_조건에_맞지_않는_경우
            
            var text: String {
                switch self {
                case .조건에_맞는_경우:
                    return "사용할 수 있는 닉네임이에요."
                case .글자수_조건에_맞지_않는_경우:
                    return "2글자 이상 10글자 미만으로 설정해주세요."
                case .특수문자_조건에_맞지_않는_경우:
                    return "닉네임에 @, #, $, % 는 포함할 수 없어요."
                case .숫자_조건에_맞지_않는_경우:
                    return "닉네임에 숫자는 포함할 수 없어요"
                }
            }
        }
        
        let textField = UITextField()
        let stateLabel = UILabel()
        
        private let background = UIView()
        
        init() {
            super.init(frame: .zero)
            
            configureUI()
            
            configureLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureUI() {
            textField.font = .tm(.body)
            textField.textColor = .tm(.semantic(.text(.primary)))
            textField.attributedPlaceholder = NSAttributedString(
                string: "닉네임을 입력해주세요.",
                attributes: [.foregroundColor: UIColor.tm(.semantic(.text(.tertiary)))]
            )
            addSubview(textField)
            
            background.backgroundColor = .white
            addSubview(background)
            
            stateLabel.text = State.글자수_조건에_맞지_않는_경우.text
            stateLabel.textColor = .tm(.semantic(.text(.brand)))
            stateLabel.font = .tm(.body)
            addSubview(stateLabel)
        }
        
        private func configureLayout() {
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
            
            background.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            
            stateLabel.snp.makeConstraints { make in
                make.top.equalTo(background.snp.bottom).offset(16)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
        }
        
        func updateState(_ state: State) {
            stateLabel.isHidden = false
            stateLabel.text = state.text
        }
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
