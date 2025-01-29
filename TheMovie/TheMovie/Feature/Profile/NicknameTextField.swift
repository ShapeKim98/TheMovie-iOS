//
//  NicknameTextField.swift
//  TheMovie
//
//  Created by 김도형 on 1/29/25.
//

import UIKit

import SnapKit

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
        textField.keyboardAppearance = .dark
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
