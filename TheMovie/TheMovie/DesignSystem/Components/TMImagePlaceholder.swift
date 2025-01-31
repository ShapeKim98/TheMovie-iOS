//
//  TMImagePlaceholder.swift
//  TheMovie
//
//  Created by 김도형 on 1/31/25.
//

import UIKit

import Kingfisher
import SnapKit

final class TMImagePlaceholder: UIView, Placeholder {
    private let icon = UIImageView(
        image: UIImage(systemName: "photo")
    )
    
    init(iconSize: CGFloat) {
        super.init(frame: .zero)
        
        configureUI()
        
        configureLayout(iconSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .tm(.semantic(.background(.secondary)), alpha: 0.5)
        
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .tm(.semantic(.icon(.secondary)))
        addSubview(icon)
    }
    
    private func configureLayout(_ iconSize: CGFloat) {
        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(iconSize)
        }
    }
}
