//
//  TMProfileImageView.swift
//  TheMovie
//
//  Created by 김도형 on 1/26/25.
//

import UIKit

import SnapKit

final class TMProfileImageView: UIImageView {
    init(_ profileImage: TMImage, size: CGFloat) {
        super.init(frame: .zero)
        
        configureUI(profileImage, size: size)
        
        configureLayout(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSelected(_ isSelected: Bool) {
        if isSelected {
            layer.borderWidth = 3
            layer.borderColor = .tm(.brand)
            alpha = 1
        } else {
            layer.borderColor = .tm(.graySecondary)
            layer.borderWidth = 1
            alpha = 0.5
        }
    }
    
    func setProfileImage(_ profileImage: TMImage) {
        image = profileImage.uiImage
    }
    
    private func configureUI(_ profileImage: TMImage, size: CGFloat) {
        backgroundColor = .clear
        
        image = profileImage.uiImage
        contentMode = .scaleAspectFill
        layer.cornerRadius = size / 2
        clipsToBounds = true
        layer.borderColor = .tm(.graySecondary)
        layer.borderWidth = 1
        alpha = 0.5
    }
    
    private func configureLayout(size: CGFloat) {
        snp.makeConstraints { make in
            make.size.equalTo(size)
        }
    }
}
