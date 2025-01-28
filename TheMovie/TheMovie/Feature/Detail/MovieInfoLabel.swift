//
//  MovieInfoLabel.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import SnapKit

final class MovieInfoLabel: UIView {
    private let image = UIImageView()
    private let label = UILabel()
    
    init(image: String, text: String, isSeparator: Bool = true) {
        super.init(frame: .zero)
        
        let font = UIFont.tm(.caption)
        let height = font.lineHeight
        let color = UIColor.tm(.semantic(.text(.tertiary)))
        
        self.image.image = UIImage(systemName: image)
        self.image.tintColor = color
        addSubview(self.image)
        
        self.label.text = text
        self.label.textColor = color
        self.label.font = font
        addSubview(label)
        
        self.image.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.size.equalTo(height)
        }
        
        self.label.snp.makeConstraints { make in
            make.centerY.equalTo(self.image)
            make.leading.equalTo(self.image.snp.trailing).offset(4)
            if !isSeparator {
                make.trailing.equalToSuperview()
            }
        }
        
        if isSeparator {
            let separator = UIView()
            separator.backgroundColor = color
            addSubview(separator)
            
            separator.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(height)
                make.trailing.equalToSuperview()
                make.leading.equalTo(self.label.snp.trailing).offset(8)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
