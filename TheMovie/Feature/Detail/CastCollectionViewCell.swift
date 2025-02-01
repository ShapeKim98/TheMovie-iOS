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
    private let labelContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    func forItemAt(_ cast: Credits.Cast) {
        let url = URL(string: .imageBaseURL + "/w185" + (cast.profilePath ?? ""))
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: TMImagePlaceholder(iconSize: 20),
            options: [.transition(.fade(0.3))]
        )
        
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
}

// MARK: Configure Views
private extension CastCollectionViewCell {
    func configureUI() {
        configureProfileImageView()
        
        contentView.addSubview(labelContainer)
        
        configureNameLabel()
        
        configureCharacterLabel()
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.size.equalTo(50)
        }
        
        labelContainer.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(profileImageView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configureProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
    }
    
    func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 13, weight: .bold)
        nameLabel.textColor = .tm(.semantic(.text(.primary)))
        nameLabel.numberOfLines = 2
        labelContainer.addSubview(nameLabel)
    }
    
    func configureCharacterLabel() {
        characterLabel.font = .tm(.caption)
        characterLabel.textColor = .tm(.semantic(.text(.tertiary)))
        labelContainer.addSubview(characterLabel)
    }
}

extension String {
    static let castCollectionCell = "CastCollectionCell"
}
