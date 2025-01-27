//
//  TMBoarderButton.swift
//  TheMovie
//
//  Created by 김도형 on 1/24/25.
//

import UIKit

import SnapKit

final class TMBoarderButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        configureUI(title: title)
        
        configureUpdateHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(title: String) {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .clear
        configuration.background.strokeColor = .tm(.semantic(.border(.brand)))
        configuration.background.strokeWidth = 2
        configuration.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        configuration.cornerStyle = .capsule
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(ofSize: 16, weight: .bold)
        titleContainer.foregroundColor = .tm(.semantic(.text(.brand)))
        configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = configuration
    }
    
    private func configureUpdateHandler() {
        configurationUpdateHandler = { [weak self] button in
            guard let `self` else { return }
            switch button.state {
            case .disabled:
                updateState(
                    strokeColor: .tm(.semantic(.border(.tertiary))),
                    textColor: .tm(.semantic(.text(.tertiary)))
                )
            default:
                updateState(
                    strokeColor: .tm(.semantic(.border(.brand))),
                    textColor: .tm(.semantic(.text(.brand)))
                )
            }
        }
    }
    
    private func updateState(strokeColor: UIColor, textColor: UIColor) {
        configuration?.background.strokeColor = strokeColor
        configuration?.attributedTitle?.setAttributes(AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: textColor
        ]))
    }
}

@available(iOS 17.0, *)
#Preview {
    TMBoarderButton(title: "시작")
}
