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
        
        configuration.attributedTitle = .make(title, [
            .foregroundColor: UIColor.tm(.semantic(.text(.brand))),
            .font: UIFont.tm(.title)
        ])
        
        self.configuration = configuration
    }
    
    private func configureUpdateHandler() {
        configurationUpdateHandler = { [weak self] button in
            switch button.state {
            case .highlighted:
                UIView.fadeAnimate {
                    button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
            case .disabled:
                self?.updateState(
                    strokeColor: .tm(.semantic(.border(.tertiary))),
                    textColor: .tm(.semantic(.text(.tertiary)))
                )
                UIView.fadeAnimate {
                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            default:
                self?.updateState(
                    strokeColor: .tm(.semantic(.border(.brand))),
                    textColor: .tm(.semantic(.text(.brand)))
                )
                UIView.fadeAnimate {
                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
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
