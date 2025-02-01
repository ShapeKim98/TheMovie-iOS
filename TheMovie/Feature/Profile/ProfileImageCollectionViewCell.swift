//
//  ProfileImageCollectionViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 1/26/25.
//

import UIKit

import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {
    private var profileImageView: TMProfileImageView
    
    override init(frame: CGRect) {
        profileImageView = TMProfileImageView(.profile(id: 0), size: frame.width)
        profileImageView.isSelected(false)
        
        super.init(frame: frame)
        
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        configurationUpdateHandler = { [weak self] _, state in
            guard let `self` else { return }
            
            UIView.animate(withDuration: 0.3) {
                self.profileImageView.isSelected(state.isSelected)
                self.profileImageView.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forItemAt(_ id: Int) {
        profileImageView.setProfileImage(.profile(id: id))
    }
}

extension String {
    static let profileImageCollectionCell = "ProfileImageCollectionViewCell"
}
