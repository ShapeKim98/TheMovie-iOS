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
    private var genreLabels = [UIView]()
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
        posterImageView.image = nil
        for genre in genreLabels {
            hstack.removeArrangedSubview(genre)
            genre.removeFromSuperview()
        }
        genreLabels.removeAll()
    }
    
    func forRowAt(_ movie: Movie, isSelected: Bool, query: String) {
        let url = URL(string: .imageBaseURL + "/w300" + (movie.posterPath ?? ""))
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(
            with: url,
            placeholder: TMImagePlaceholder(iconSize: 28),
            options: [.transition(.fade(0.3))]
        )
        
        titleLabel.attributedText = NSAttributedString(string: query)
        highlightAttributedString(
            text: movie.title ?? "",
            keyword: query
        ) { [weak self] text in
            self?.titleLabel.attributedText = text
        }
        
        let date = movie.releaseDate?.date(format: .yyyy_MM_dd)
        dateLabel.text = date?.toString(format: .yyyy_o_MM_o_dd)
        favoriteButton.isSelected = isSelected
        favoriteButton.tag = movie.id
        
        let genres = movie.genreIds?.prefix(2) ?? []
        
        let group = DispatchGroup()
        for genre in genres {
            configureGenreLabel(genre.title, query: query, group: group)
        }
        
        group.notify(queue: .main) { [weak self] in
            let genresCount = movie.genreIds?.count ?? 0
            guard genresCount > 2 else { return }
            
            let count = genresCount - 2
            self?.configureGenreLabel("+\(count)", query: "")
        }
    }
    
    func cancelImageDownload() {
        posterImageView.kf.cancelDownloadTask()
    }
    
    func updateFavoriteButton() {
        favoriteButton.isSelected.toggle()
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
            make.height.equalTo(100).priority(.high)
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
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
            UIAction { [weak self] action in
                self?.favoritButtonTouchUpInside(action)
            },
            for: .touchUpInside
        )
        contentView.addSubview(favoriteButton)
    }
    
    func configureGenreLabel(_ genre: String, query: String, group: DispatchGroup? = nil) {
        let container = UIView()
        container.backgroundColor = .tm(.semantic(.background(.secondary)), alpha: 0.6)
        container.layer.cornerRadius = 4
        let label = UILabel()
        
        label.font = .tm(.caption)
        label.textColor = .tm(.semantic(.text(.primary)))
        container.addSubview(label)
        
        group?.enter()
        highlightAttributedString(text: genre, keyword: query) { [weak self] text in
            label.attributedText = text
            label.snp.makeConstraints { $0.edges.equalToSuperview().inset(4) }
            self?.genreLabels.append(container)
            self?.hstack.addArrangedSubview(container)
            group?.leave()
        }
    }
}

// MARK: Functions
private extension SearchTableViewCell {
    func favoritButtonTouchUpInside(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        button.isSelected.toggle()
        if favoriteButton.isSelected {
            UINotificationFeedbackGenerator()
                .notificationOccurred(.success)
        } else {
            UINotificationFeedbackGenerator()
                .notificationOccurred(.warning)
        }
        delegate?.favoritButtonTouchUpInside(button.tag)
    }
    
    private func highlightAttributedString(
        text: String,
        keyword: String,
        completion: @escaping (NSAttributedString) -> Void
    ) {
        highlightWords(text: text, keyword: keyword) { [weak self] attributedString in
            guard let attributedString else {
                self?.highlightCharacters(text: text, keyword: keyword) { attributedString in
                    completion(attributedString)
                }
                return
            }
            DispatchQueue.main.async {
                completion(attributedString)
            }
        }
    }
    
    func highlightWords(
        text: String,
        keyword: String,
        completion: @escaping (NSAttributedString?) -> Void
    ) {
        DispatchQueue.global().async {
            let lowercasedText = NSMutableAttributedString(
                string: text.lowercased()
            )
            
            var matchCount = 0
            let mutableAttributedString = NSMutableAttributedString(
                string: text
            )
            
            let keywords = keyword.lowercased().split(separator: " ").map { String($0) }
            for keyword in keywords {
                let range = lowercasedText.mutableString.range(
                    of: keyword
                )
                mutableAttributedString.addAttributes(
                    [.foregroundColor: UIColor.tm(.semantic(.text(.brand)))],
                    range: range
                )
                if range.length > 0 {
                    matchCount += 1
                }
            }
            guard matchCount != keywords.count else {
                completion(mutableAttributedString)
                return
            }
            completion(nil)
        }
    }
    
    func highlightCharacters(
        text: String,
        keyword: String,
        completion: @escaping(NSAttributedString) -> Void
    ) {
        DispatchQueue.global().async {
            let lowercasedText = NSMutableAttributedString(
                string: text.lowercased()
            )
            
            var matchCount = 0
            
            let mutableAttributedString = NSMutableAttributedString(
                string: text
            )
            
            let characters = keyword.map { String($0).lowercased() }
            for character in characters {
                let range = lowercasedText.mutableString.range(
                    of: character
                )
                mutableAttributedString.addAttributes(
                    [.foregroundColor:UIColor.tm(.semantic(.text(.brand)))],
                    range: range
                )
                if range.length > 0 {
                    matchCount += 1
                }
            }
            guard matchCount != characters.count else {
                DispatchQueue.main.async {
                    completion(mutableAttributedString)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(NSMutableAttributedString(string: text))
            }
        }
    }
}
