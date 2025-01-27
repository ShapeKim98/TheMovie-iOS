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

@available(iOS 17.0, *)
#Preview {
    DayViewController()
}
