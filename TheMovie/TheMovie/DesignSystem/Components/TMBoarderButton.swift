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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(title: String) {
        tintColor = .brand
        setTitle(title, for: .normal)
        setTitleColor(.tm(.brand), for: .normal)
        guard let titleLabel else { return }
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
        }
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        backgroundColor = .clear
        layer.cornerRadius = (titleLabel.frame.height + 20) / 2
        layer.borderColor = .tm(.brand)
        layer.borderWidth = 2
    }
}

@available(iOS 17.0, *)
#Preview {
    TMBoarderButton(title: "시작")
}
