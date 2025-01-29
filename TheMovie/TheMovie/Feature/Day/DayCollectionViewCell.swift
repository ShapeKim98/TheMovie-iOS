//
//  DayCollectionViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import Kingfisher
import SnapKit

protocol DayCollectionViewCellDelegate: AnyObject {
    func favoriteButtonTouchUpInside(_ movieId: Int)
}

final class DayCollectionViewCell: UICollectionViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favoriteButton = TMFavoriteButton()
    
    weak var delegate: (any DayCollectionViewCellDelegate)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        let height = posterImageView.frame.height + titleLabel.frame.height + overviewLabel.frame.height + 16
        snp.updateConstraints { make in
            make.height.equalTo(height)
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.isSelected = false
        delegate = nil
    }
    
    func forItemAt(_ movie: Movie, isSelected: Bool) {
        let url = URL(string: .imageBaseURL + "/w500" + (movie.posterPath ?? ""))
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.3)),
            ]
        )
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        favoriteButton.isSelected = isSelected
        favoriteButton.tag = movie.id
    }
    
    func updateFavoriteButton() {
        favoriteButton.isSelected.toggle()
    }
}

// MARK: Configure Views
private extension DayCollectionViewCell {
    func configureUI() {
        backgroundColor = .clear
        
        configurePosterImageView()
        
        configureTitleLabel()
        
        configureFavoriteButton()
        
        configureOverviewLabel()
    }
    
    func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(24)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func configurePosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        contentView.addSubview(posterImageView)
    }
    
    func configureTitleLabel() {
        titleLabel.font = .tm(.headline)
        titleLabel.textColor = .tm(.semantic(.text(.primary)))
        contentView.addSubview(titleLabel)
    }
    
    func configureFavoriteButton() {
        favoriteButton.addAction(
            UIAction(handler: favoritButtonTouchUpInside),
            for: .touchUpInside
        )
        contentView.addSubview(favoriteButton)
    }
    
    func configureOverviewLabel() {
        overviewLabel.font = .tm(.body)
        overviewLabel.textColor = .tm(.semantic(.text(.primary)))
        overviewLabel.numberOfLines = 2
        contentView.addSubview(overviewLabel)
    }
}

// MARK: Functions
private extension DayCollectionViewCell {
    func favoritButtonTouchUpInside(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        favoriteButton.isSelected.toggle()
        delegate?.favoriteButtonTouchUpInside(button.tag)
    }
}

extension String {
    static let dayCollectionCell = "DayCollectionViewCell"
}
