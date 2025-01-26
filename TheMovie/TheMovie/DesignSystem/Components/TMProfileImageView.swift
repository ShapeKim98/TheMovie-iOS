//
//  TMProfileImageView.swift
//  TheMovie
//
//  Created by 김도형 on 1/26/25.
//

import UIKit

import SnapKit

final class TMProfileImageView: UIView {
    private let imageView = UIImageView()
    
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
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = .tm(.brand)
            imageView.alpha = 1
        } else {
            imageView.layer.borderColor = .tm(.graySecondary)
            imageView.layer.borderWidth = 1
            imageView.alpha = 0.5
        }
    }
    
    func setProfileImage(_ profileImage: TMImage) {
        imageView.image = profileImage.uiImage
    }
    
    private func configureUI(_ profileImage: TMImage, size: CGFloat) {
        backgroundColor = .clear
        
        imageView.image = profileImage.uiImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = size / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = .tm(.graySecondary)
        imageView.layer.borderWidth = 1
        imageView.alpha = 0.5
        addSubview(imageView)
    }
    
    private func configureLayout(size: CGFloat) {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(size)
        }
    }
}
