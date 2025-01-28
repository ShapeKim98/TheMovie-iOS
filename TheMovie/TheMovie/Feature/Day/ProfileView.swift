//
//  ProfileView.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

final class ProfileView: UIView {
    private let button = UIButton()
    private let movieBoxLabel = UILabel()
    private let movieBoxLabelBackground = UIView()
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
    private var movieBox: [String: Int]?
    
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
    
    func updateMovieBoxLabel() {
        movieBoxLabel.text = "\(movieBox?.count ?? 0)개의 무비박스 보관중"
    }
    
    private func configureUI() {
        backgroundColor = .tm(.semantic(.background(.secondary)), alpha: 0.3)
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
        
        movieBoxLabelBackground.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
        }
        movieBoxLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    private func configureProfileImageView() {
        profileImageView.isSelected(true)
        addSubview(profileImageView)
    }
    
    private func configureButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = .make(nickname ?? "", [
            .foregroundColor: UIColor.tm(.semantic(.text(.primary))),
            .font: UIFont.tm(.title)
        ])
        configuration.attributedSubtitle = .make("\(profileDate ?? "") 가입", [
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
        movieBoxLabel.text = "\(movieBox?.count ?? 0)개의 무비박스 보관중"
        movieBoxLabel.font = .systemFont(ofSize: 14, weight: .bold)
        movieBoxLabel.textColor = .tm(.semantic(.text(.primary)))
        movieBoxLabel.textAlignment = .center
        movieBoxLabelBackground.addSubview(movieBoxLabel)
        movieBoxLabelBackground.backgroundColor = .tm(.semantic(.background(.brand)))
        movieBoxLabelBackground.layer.cornerRadius = 8
        addSubview(movieBoxLabelBackground)
    }
}

@available(iOS 17.0, *)
#Preview {
    DayViewController()
}
