//
//  TMProfileButton.swift
//  TheMovie
//
//  Created by 김도형 on 1/25/25.
//

import UIKit

import SnapKit

final class TMProfileButton: UIButton {
    private let profileImageView: TMProfileImageView
    private let cameraIconView = UIView()
    
    init(_ profileImage: TMImage, size: CGFloat) {
        profileImageView = TMProfileImageView(profileImage, size: size)
        
        super.init(frame: .zero)
        
        configureUI(profileImage, size: size)
        
        configureLayout(size: size)
        
        configureUpdateHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProfile(_ profileImage: TMImage) {
        profileImageView.setProfileImage(profileImage)
    }
    
    private func configureUI(_ profileImage: TMImage, size: CGFloat) {
        addSubview(profileImageView)
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = nil
        self.configuration = configuration
        
        let image = UIImageView(image: UIImage(systemName: "camera.fill"))
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        cameraIconView.addSubview(image)
        image.snp.makeConstraints { $0.edges.equalToSuperview().inset(4) }
        
        cameraIconView.backgroundColor = .tm(.brand)
        cameraIconView.layer.cornerRadius = 14
        addSubview(cameraIconView)
    }
    
    private func configureLayout(size: CGFloat) {
        snp.makeConstraints { make in
            make.size.equalTo(size)
        }
        
        cameraIconView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self)
            make.size.equalTo(28)
        }
    }
    
    private func configureUpdateHandler() {
        configurationUpdateHandler = { [weak self] button in
            guard let `self` else { return }
            switch button.state {
            case .selected:
                profileImageView.isSelected(true)
                button.configuration?.background.backgroundColor = .clear
            default:
                profileImageView.isSelected(false)
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let button = TMProfileButton(.profile(id: 0), size: 100)
    button.isSelected = true
    return button
}
