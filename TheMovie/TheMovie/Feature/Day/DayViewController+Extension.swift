//
//  DayViewController+Extension.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

extension DayViewController {
    final class ProfileView: UIView {
        private let button = UIButton()
        private let movieBoxLabel = UIView()
        private lazy var profileImageView = TMProfileImageView(
            .profile(id: profileImageId ?? 0),
            size: 40
        )
        
        @UserDefaults(forKey: .userDefaults(.nickname))
        private var nickname: String?
        @UserDefaults(forKey: .userDefaults(.profileDate))
        private var profileDate: String?
        @UserDefaults(forKey: .userDefaults(.profileImageId))
        private var profileImageId: Int?
        @UserDefaults(forKey: .userDefaults(.movieBox))
        private var movieBox: Set<Int>?
        
        init() {
            super.init(frame: .zero)
            
            configureUI()
            
            configureLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func addButtonAction(_ action: @escaping (UIAction) -> Void) {
            button.addAction(UIAction(handler: action), for: .touchUpInside)
        }
        
        private func configureUI() {
            backgroundColor = .tm(.semantic(.background(.secondary))).withAlphaComponent(0.3)
            layer.cornerRadius = 16
            
            configureProfileImageView()
            
            configureButton()
            
            configureMovieBoxLabel()
        }
        
        private func configureLayout() {
            profileImageView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(12)
            }
            
            button.snp.makeConstraints { make in
                make.leading.equalTo(profileImageView.snp.trailing).offset(12)
                make.centerY.equalTo(profileImageView)
            }
            
            movieBoxLabel.snp.makeConstraints { make in
                make.top.equalTo(profileImageView.snp.bottom).offset(12)
                make.bottom.horizontalEdges.equalToSuperview().inset(12)
            }
        }
        
        private func configureProfileImageView() {
            profileImageView.isSelected(true)
            addSubview(profileImageView)
        }
        
        private func configureButton() {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = .make(nickname ?? "닉네임", [
                .foregroundColor: UIColor.tm(.semantic(.text(.primary))),
                .font: UIFont.tm(.title)
            ])
            configuration.attributedSubtitle = .make(profileDate ?? "" + " 가입", [
                .foregroundColor: UIColor.tm(.semantic(.text(.secondary))),
                .font: UIFont.tm(.caption),
            ])
            configuration.titleAlignment = .leading
            configuration.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
            button.configuration = configuration
            addSubview(button)
            let image = UIImageView(image: UIImage(systemName: "chevron.right"))
            button.addSubview(image)
            image.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(self).inset(12)
            }
            image.tintColor = .tm(.semantic(.icon(.tertiary)))
        }
        
        private func configureMovieBoxLabel() {
            let label = UILabel()
            label.text = "\(movieBox?.count ?? 0)개의 무비박스 보관중"
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .tm(.semantic(.text(.primary)))
            label.textAlignment = .center
            movieBoxLabel.addSubview(label)
            label.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
            movieBoxLabel.backgroundColor = .tm(.semantic(.background(.brand)))
            movieBoxLabel.layer.cornerRadius = 8
            addSubview(movieBoxLabel)
        }
    }
    
    final class RecentQueryView: UIView {
        private let titleLabel = UILabel()
        private let removeButton = UIButton()
        private let emptyLabel = UILabel()
        private let contentView = UIStackView()
        private let scrollView = UIScrollView()
        private var queryButtons = [QueryButton]()
        
        @UserDefaults(
            forKey: .userDefaults(.recentQueries),
            defaultValue: ["스파이더", "해리포터", "소방관", "해리포터", "소방관", "해리포터", "소방관", "해리포터", "소방관", "해리포터", "소방관", "해리포터", "소방관"]
        )
        private var recentQueries: [String]?
        
        init() {
            super.init(frame: .zero)
            
            configureUI()
            
            configureLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutIfNeeded() {
            super.layoutIfNeeded()
            
            for button in queryButtons {
                button.layoutIfNeeded()
            }
        }
        
        private func configureUI() {
            configureTitleLabel()
            
            configureRemoveButton()
            
            configureEmptyLabel()
            
            configureScrollView()
            
            configureContentView()
            
            configureQueryButtons()
        }
        
        private func configureLayout() {
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
            }
            
            removeButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalTo(titleLabel)
            }
            
            emptyLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.horizontalEdges.equalToSuperview()
            }
            
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom)
                make.bottom.horizontalEdges.equalToSuperview()
                make.height.equalTo(contentView).offset(24)
            }
            
            contentView.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview().inset(12)
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
            for button in queryButtons {
                button.snp.makeConstraints { make in
                    make.verticalEdges.equalToSuperview()
                }
            }
        }
        
        private func configureTitleLabel() {
            titleLabel.text = "최근 검색어"
            titleLabel.textColor = .tm(.semantic(.text(.primary)))
            titleLabel.font = .tm(.title)
            addSubview(titleLabel)
        }
        
        private func configureRemoveButton() {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = .make("전체 삭제", [
                .foregroundColor: UIColor.tm(.semantic(.text(.brand))),
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ])
            removeButton.configuration = configuration
            removeButton.isHidden = (recentQueries?.isEmpty ?? true)
            addSubview(removeButton)
        }
        
        private func configureEmptyLabel() {
            emptyLabel.text = "최근 검색어 내역이 없습니다."
            emptyLabel.textColor = .tm(.semantic(.text(.tertiary)))
            emptyLabel.font = .tm(.caption)
            emptyLabel.textAlignment = .center
            emptyLabel.isHidden = !(recentQueries?.isEmpty ?? true)
            addSubview(emptyLabel)
        }
        
        private func configureScrollView() {
            scrollView.isHidden = (recentQueries?.isEmpty ?? true)
            addSubview(scrollView)
        }
        
        private func configureContentView() {
            contentView.axis = .horizontal
            contentView.distribution = .fill
            contentView.spacing = 8
            scrollView.addSubview(contentView)
        }
        
        private func configureQueryButtons() {
            guard let recentQueries else { return }
            for query in recentQueries {
                let button = QueryButton(text: query)
                queryButtons.append(button)
                contentView.addArrangedSubview(button)
            }
        }
    }
    
    final class QueryButton: UIView {
        private let textButton = UIButton()
        private let removeButton = UIButton()
        
        init(text: String) {
            super.init(frame: .zero)
            
            configureUI(text: text)
            
            configureLayout()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutIfNeeded() {
            super.layoutIfNeeded()
            layer.cornerRadius = frame.height / 2
        }
        
        private func configureUI(text: String) {
            backgroundColor = .tm(.semantic(.background(.quaternary)))
            
            configureTextButton(text: text)
            
            configureRemoveButton()
        }
        
        private func configureLayout() {
            textButton.snp.makeConstraints { make in
                make.leading.verticalEdges.equalToSuperview().inset(6)
            }
            
            removeButton.snp.makeConstraints { make in
                make.centerY.equalTo(textButton)
                make.trailing.equalToSuperview().inset(6)
                make.leading.equalTo(textButton.snp.trailing).offset(8)
                make.size.equalTo(12)
            }
        }
        
        private func configureTextButton(text: String) {
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = .make(text, [
                .foregroundColor: UIColor.tm(.semantic(.text(.quaternary))),
                .font: UIFont.tm(.body)
            ])
            configuration.contentInsets = .zero
            configuration.titleAlignment = .center
            textButton.configuration = configuration
            addSubview(textButton)
        }
        
        private func configureRemoveButton() {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(systemName: "xmark")
            configuration.contentInsets = .zero
            removeButton.tintColor = .tm(.semantic(.icon(.quaternary)))
            removeButton.configuration = configuration
            removeButton.imageView?.snp.makeConstraints { make in
                make.size.equalTo(12)
            }
            addSubview(removeButton)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    DayViewController()
}
