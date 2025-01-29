//
//  CastCollectionViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import Kingfisher
import SnapKit

final class CastCollectionViewCell: UICollectionViewCell {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let characterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forItemAt(_ cast: Credits.Cast) {
        if let path = cast.profilePath {
            let url = URL(string: .imageBaseURL + "/w185" + path)
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(
                with: url,
                options: [.transition(.fade(0.3))]
            )
        }
        
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
}

// MARK: Configure Views
private extension CastCollectionViewCell {
    func configureUI() {
        configureProfileImageView()
        
        configureNameLabel()
        
        configureCharacterLabel()
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.size.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
        }
    }
    
    func configureProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
    }
    
    func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        nameLabel.textColor = .tm(.semantic(.text(.primary)))
        contentView.addSubview(nameLabel)
    }
    
    func configureCharacterLabel() {
        characterLabel.font = .tm(.caption)
        characterLabel.textColor = .tm(.semantic(.text(.tertiary)))
        contentView.addSubview(characterLabel)
    }
}

extension String {
    static let castCollectionCell = "CastCollectionCell"
}
