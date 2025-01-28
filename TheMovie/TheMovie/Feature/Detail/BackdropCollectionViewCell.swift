//
//  BackdropCollectionViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import Kingfisher
import SnapKit

final class BackdropCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(0.7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forItemAt(_ path: String) {
        let url = URL(string: .imageBaseURL + "/w1280" + path)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
    }
}

extension String {
    static let backdropCollectionCell = "BackdropCollectionViewCell"
}
