//
//  ProfileViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/7/25.
//

import Foundation

enum MBTIType: String {
    case 주의초점 = "주의초점"
    case 인식기능 = "인식기능"
    case 판단기능 = "판단기능"
    case 생활양식 = "생활양식"
}

final class ProfileViewModel: ViewModel {
    enum Input {
        case completeButtonTouchUpInside(text: String?)
        case textFieldShouldChangeCharactersIn(text: String?, range: NSRange, string: String)
        case saveButtonTouchUpInside(text: String?)
        case collectionViewDidSelectItemAt(element: String)
        case collectionViewDidDeselectItemAt(element: String)
    }
    
    enum Output {
        case profileImageId(_ value: Int?)
        case isValidNickname(_ value: Bool)
        case nicknameState(_ value: NicknameTextField.State)
        case selectedMBTI(_ value: [MBTIType: String])
    }
    
    struct Model {
        var profileImageId: Int? {
            didSet {
                guard oldValue != profileImageId else { return }
                continuation?.yield(.profileImageId(profileImageId))
            }
        }
        var isValidProfile = false {
            didSet {
                guard oldValue != isValidProfile else { return }
                continuation?.yield(.isValidNickname(isValidProfile))
            }
        }
        var nicknameState: NicknameTextField.State = .글자수_조건에_맞지_않는_경우 {
            didSet {
                guard oldValue != nicknameState else { return }
                continuation?.yield(.nicknameState(nicknameState))
            }
        }
        var selectedMBTI: [MBTIType: String] = [:] {
            didSet {
                guard oldValue != selectedMBTI else { return }
                continuation?.yield(.selectedMBTI(selectedMBTI))
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
        if let mbti {
            for (key, value) in mbti {
                guard let type = MBTIType(rawValue: key) else { continue }
                model.selectedMBTI[type] = value
            }
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
    @UserDefault(
        forKey: .userDefaults(.mbti),
        defaultValue: [:]
    )
    private(set) var mbti: [String: String]?
    
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
            saveSelectedMBTI()
        case let .textFieldShouldChangeCharactersIn(text, range, string):
            guard let text else { return }
            let newText = text.prefix(range.location) + string
            updateTextFieldState(String(newText))
        case let .saveButtonTouchUpInside(text):
            guard let text else { return }
            nickname = text
            profileImageId = model.profileImageId
            isProfileCompleted = true
            saveSelectedMBTI()
        case let .collectionViewDidSelectItemAt(element):
            updateSelectedMBTI(element)
            model.isValidProfile = model.selectedMBTI.count == 4
        case let .collectionViewDidDeselectItemAt(element):
            updateSelectedMBTI(element)
            model.isValidProfile = model.selectedMBTI.count == 4
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
        let count = text.filter { !$0.isWhitespace }.count
        guard (2 <= count && count < 10) else {
            model.nicknameState = .글자수_조건에_맞지_않는_경우
            model.isValidProfile = false
            return
        }
        guard !text.contains(/[@#$%]/) else {
            model.nicknameState = .특수문자_조건에_맞지_않는_경우
            model.isValidProfile = false
            return
        }
        guard !text.contains(/\d/) else {
            model.nicknameState = .숫자_조건에_맞지_않는_경우
            model.isValidProfile = false
            return
        }
        model.isValidProfile = true
        model.nicknameState = .조건에_맞는_경우
    }
    
    func updateSelectedMBTI(_ element: String) {
        switch element {
        case "E", "I":
            if model.selectedMBTI[.주의초점] == element {
                model.selectedMBTI[.주의초점] = nil
            } else {
                model.selectedMBTI[.주의초점] = element
            }
        case "N", "S":
            if model.selectedMBTI[.인식기능] == element {
                model.selectedMBTI[.인식기능] = nil
            } else {
                model.selectedMBTI[.인식기능] = element
            }
        case "T", "F":
            if model.selectedMBTI[.판단기능] == element {
                model.selectedMBTI[.판단기능] = nil
            } else {
                model.selectedMBTI[.판단기능] = element
            }
        case "J", "P":
            if model.selectedMBTI[.생활양식] == element {
                model.selectedMBTI[.생활양식] = nil
            } else {
                model.selectedMBTI[.생활양식] = element
            }
        default:
            break
        }
    }
    
    func saveSelectedMBTI() {
        for (key, value) in model.selectedMBTI {
            mbti?[key.rawValue] = value
        }
    }
}
