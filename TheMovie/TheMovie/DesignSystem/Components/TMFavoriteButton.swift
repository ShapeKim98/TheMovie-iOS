//
//  TMFavoriteButton.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

class TMFavoriteButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        configureUI()
        
        configureLayout()
        
        configureUpdateHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .clear
        configuration.image = UIImage(systemName: "heart")
        self.configuration = configuration
        tintColor = .tm(.semantic(.icon(.brand)))
        imageView?.contentMode = .scaleAspectFit
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        imageView?.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    private func configureUpdateHandler() {
        configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "heart.fill")
                UIView.fadeAnimate {
                    button.layoutIfNeeded()
                }
            case .normal:
                button.configuration?.image = UIImage(systemName: "heart")
                UIView.fadeAnimate {
                    button.layoutIfNeeded()
                }
            default: break
            }
            
        }
    }
}
