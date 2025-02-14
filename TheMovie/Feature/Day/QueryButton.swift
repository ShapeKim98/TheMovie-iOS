//
//  QueryButton.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

protocol QueryButtonDelegate: AnyObject {
    func textButtonTouchUpInside(text: String)
    func removeButtonTouchUpInside(text: String)
}

final class QueryButton: UIView {
    private let textButton = UIButton()
    private let removeButton = UIButton()
    
    let text: String
    
    weak var delegate: (any QueryButtonDelegate)?
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = frame.height / 2
    }
    
    private func configureUI() {
        backgroundColor = .tm(.semantic(.background(.tertiary)))
        
        configureTextButton()
        
        configureRemoveButton()
    }
    
    private func configureLayout() {
        textButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(12)
        }
        
        removeButton.snp.makeConstraints { make in
            make.centerY.equalTo(textButton)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(textButton.snp.trailing).offset(8)
            make.size.equalTo(12)
        }
    }
    
    private func configureTextButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = .make(text, [
            .foregroundColor: UIColor.tm(.semantic(.text(.quaternary))),
            .font: UIFont.tm(.body)
        ])
        configuration.contentInsets = .zero
        configuration.titleAlignment = .center
        textButton.configuration = configuration
        textButton.addAction(
            UIAction { [weak self] _ in
                self?.textButtonAddAction()
            },
            for: .touchUpInside
        )
        addSubview(textButton)
    }
    
    private func configureRemoveButton() {
        var configuration = UIButton.Configuration.plain()
        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 10,
            weight: .bold
        )
        configuration.image = UIImage(
            systemName: "xmark",
            withConfiguration: symbolConfiguration
        )
        configuration.contentInsets = .zero
        removeButton.tintColor = .tm(.semantic(.icon(.quaternary)))
        removeButton.configuration = configuration
        removeButton.addAction(
            UIAction { [weak self] _ in
                self?.removeButtonAddAction()
            },
            for: .touchUpInside
        )
        addSubview(removeButton)
    }
    
    private func textButtonAddAction() {
        delegate?.textButtonTouchUpInside(text: text)
    }
    
    private func removeButtonAddAction() {
        UINotificationFeedbackGenerator()
            .notificationOccurred(.error)
        delegate?.removeButtonTouchUpInside(text: text)
    }
}

@available(iOS 17.0, *)
#Preview {
    DayViewController()
}
