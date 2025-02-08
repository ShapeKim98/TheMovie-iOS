//
//  ProfileViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/7/25.
//

import Foundation

final class ProfileViewModel: ViewModel {
    enum Input {
        case completeButtonTouchUpInside(text: String?)
        case textFieldShouldChangeCharactersIn(text: String?, range: NSRange, string: String)
        case saveButtonTouchUpInside(text: String?)
    }
    
    enum Output {
        case profileImageId(_ value: Int?)
        case isValidNickname(_ value: Bool)
        case nicknameState(_ value: NicknameTextField.State)
    }
    
    struct Model {
        var profileImageId: Int? {
            didSet {
                guard oldValue != profileImageId else { return }
                continuation?.yield(.profileImageId(profileImageId))
            }
        }
        var isValidNickname = false {
            didSet {
                guard oldValue != isValidNickname else { return }
                continuation?.yield(.isValidNickname(isValidNickname))
            }
        }
        var nicknameState: NicknameTextField.State = .글자수_조건에_맞지_않는_경우 {
            didSet {
                guard oldValue != nicknameState else { return }
                continuation?.yield(.nicknameState(nicknameState))
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    
    private(set) var model = Model()
    
    init() {
        model.profileImageId = profileImageId
        if let nickname {
            updateTextFieldState(nickname)
        }
    }
    
    deinit {
        model.continuation?.finish()
    }
    
    @UserDefault(forKey: .userDefaults(.nickname))
    private(set) var nickname: String?
    @UserDefault(forKey: .userDefaults(.profileCompleted))
    private var isProfileCompleted: Bool?
    @UserDefault(forKey: .userDefaults(.profileDate))
    private var profileDate: String?
    @UserDefault(
        forKey: .userDefaults(.profileImageId),
        defaultValue: (0...11).randomElement() ?? 0
    )
    private var profileImageId: Int?
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
    }
    
    func input(_ action: Input) {
        switch action {
        case let .completeButtonTouchUpInside(text):
            guard let text else { return }
            nickname = text
            profileImageId = model.profileImageId
            isProfileCompleted = true
            profileDate = Date.now.toString(format: .yy_o_MM_o_dd)
        case let .textFieldShouldChangeCharactersIn(text, range, string):
            guard let text else { return }
            let newText = text.prefix(range.location) + string
            updateTextFieldState(String(newText))
        case let .saveButtonTouchUpInside(text):
            guard let text else { return }
            nickname = text
            profileImageId = model.profileImageId
            isProfileCompleted = true
        }
    }
}

extension ProfileViewModel: ProfileImageViewModelDelegate {
    func collectionViewDidSelectItemAt(selectedId: Int) {
        model.profileImageId = selectedId
    }
}

private extension ProfileViewModel {
    func updateTextFieldState(_ text: String) {
        guard (2 <= text.count && text.count < 10) else {
            model.nicknameState = .글자수_조건에_맞지_않는_경우
            model.isValidNickname = false
            return
        }
        guard !text.contains(/[@#$%]/) else {
            model.nicknameState = .특수문자_조건에_맞지_않는_경우
            model.isValidNickname = false
            return
        }
        guard !text.contains(/\d/) else {
            model.nicknameState = .숫자_조건에_맞지_않는_경우
            model.isValidNickname = false
            return
        }
        model.isValidNickname = true
        model.nicknameState = .조건에_맞는_경우
    }
}
