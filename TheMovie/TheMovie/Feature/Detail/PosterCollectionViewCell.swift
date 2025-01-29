//
//  PosterCollectionViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import Kingfisher
import SnapKit

final class PosterCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.width).multipliedBy(1.8)
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forItemAt(_ path: String) {
        let url = URL(string: .imageBaseURL + "/w342" + path)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
    }
}

extension String {
    static let posterCollectionCell = "PosterCollectionViewCell"
}
