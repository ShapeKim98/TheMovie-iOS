//
//  SearchTableViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import Kingfisher
import SnapKit

protocol SearchTableViewCellDelegate: AnyObject {
    func favoritButtonTouchUpInside(_ movieId: Int)
}

final class SearchTableViewCell: UITableViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private var genreLabels = [GenreLabel]()
    private let hstack = UIStackView()
    private let favoriteButton = TMFavoriteButton()
    
    weak var delegate: (any SearchTableViewCellDelegate)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for genre in genreLabels {
            hstack.removeArrangedSubview(genre)
            genre.removeFromSuperview()
        }
        genreLabels.removeAll()
    }
    
    func forRowAt(_ movie: Movie, isSelected: Bool) {
        if let path = movie.posterPath {
            let url = URL(string: .imageBaseURL + "/w300" + path)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(
                with: url,
                options: [.transition(.fade(0.3))]
            )
        }
        
        titleLabel.text = movie.title
        let date = movie.releaseDate.date(format: .yyyy_MM_dd)
        dateLabel.text = date?.toString(format: .yyyy_o_MM_o_dd)
        favoriteButton.isSelected = isSelected
        favoriteButton.tag = movie.id
        
        let genres = movie.genreIds.prefix(2)
        
        for genre in genres {
            let label = GenreLabel(genre: genre.title)
            genreLabels.append(label)
            hstack.addArrangedSubview(label)
        }
        
        if movie.genreIds.count > 2 {
            let count = movie.genreIds.count - 2
            let label = GenreLabel(genre: "+\(count)")
            genreLabels.append(label)
            hstack.addArrangedSubview(label)
        }
    }
    
    func cancelImageDownload() {
        posterImageView.kf.cancelDownloadTask()
    }
}

// MARK: Configure Views
private extension SearchTableViewCell {
    func configureUI() {
        backgroundColor = .clear
        
        configurePosterImageView()
        
        configureTitleLabel()
        
        configureDateLabel()
        
        configureFavoriteButton()
        
        configureHStack()
    }
    
    func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(100)
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(hstack)
        }
        
        hstack.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.bottom.equalTo(posterImageView)
            make.trailing.lessThanOrEqualTo(favoriteButton.snp.leading).inset(8)
        }
    }
    
    func configurePosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        contentView.addSubview(posterImageView)
    }
    
    func configureTitleLabel() {
        titleLabel.font = .tm(.headline)
        titleLabel.textColor = .tm(.semantic(.text(.primary)))
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
    }
    
    func configureDateLabel() {
        dateLabel.font = .tm(.caption)
        dateLabel.textColor = .tm(.semantic(.text(.tertiary)))
        contentView.addSubview(dateLabel)
    }
    
    func configureHStack() {
        hstack.axis = .horizontal
        hstack.distribution = .fillProportionally
        hstack.spacing = 4
        contentView.addSubview(hstack)
    }
    
    func configureFavoriteButton() {
        favoriteButton.addAction(
            UIAction(handler: favoritButtonTouchUpInside),
            for: .touchUpInside
        )
        contentView.addSubview(favoriteButton)
    }
}

// MARK: Functions
private extension SearchTableViewCell {
    func favoritButtonTouchUpInside(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        button.isSelected.toggle()
        delegate?.favoritButtonTouchUpInside(button.tag)
    }
}

private extension SearchTableViewCell {
    final class GenreLabel: UIView {
        let label = UILabel()
        
        init(genre: String) {
            super.init(frame: .zero)
            backgroundColor = .tm(.semantic(.background(.secondary)), alpha: 0.6)
            layer.cornerRadius = 4
            label.text = genre
            label.font = .tm(.caption)
            label.textColor = .tm(.semantic(.text(.primary)))
            addSubview(label)
            
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(4)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension String {
    static let searchTableCell = "SearchTableViewCell"
}
