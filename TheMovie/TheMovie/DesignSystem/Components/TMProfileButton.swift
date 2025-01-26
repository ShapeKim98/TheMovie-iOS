//
//  TMProfileButton.swift
//  TheMovie
//
//  Created by 김도형 on 1/25/25.
//

import UIKit

import SnapKit

final class TMProfileButton: UIButton {
    init(_ profileImage: TMImage, size: CGFloat) {
        super.init(frame: .zero)
        configureUI(profileImage, size: size)
        
        configureLayout(size: size)
        
        configureUpdateHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCameraIcon(_ superView: UIView) {
        let background = UIView()
        let image = UIImageView(image: UIImage(systemName: "camera.fill"))
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        background.addSubview(image)
        image.snp.makeConstraints { $0.edges.equalToSuperview().inset(4) }
        
        background.backgroundColor = .tm(.brand)
        background.layer.cornerRadius = 14
        superView.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self)
            make.size.equalTo(28)
        }
    }
    
    private func configureUI(_ profileImage: TMImage, size: CGFloat) {
        setImage(profileImage.uiImage, for: .normal)
        imageView?.contentMode = .scaleAspectFill
        layer.cornerRadius = size / 2
        clipsToBounds = true
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = nil
        self.configuration = configuration
    }
    
    private func configureLayout(size: CGFloat) {
        snp.makeConstraints { make in
            make.size.equalTo(size)
        }
        imageView?.snp.makeConstraints { make in
            make.size.equalTo(size)
        }
    }
    
    private func configureUpdateHandler() {
        configurationUpdateHandler = { button in
            switch button.state {
            case .selected, .disabled:
                button.layer.borderColor = .tm(.brand)
                button.layer.borderWidth = 3
            default:
                button.layer.borderColor = .tm(.graySecondary)
                button.layer.borderWidth = 1
                button.imageView?.alpha = 0.5
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    TMProfileButton(.profile(id: 0), size: 100)
}
