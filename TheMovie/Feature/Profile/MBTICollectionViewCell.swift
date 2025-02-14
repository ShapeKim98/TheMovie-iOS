//
//  MBTICollectionViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 2/9/25.
//

import UIKit

import SnapKit

class MBTICollectionViewCell: UICollectionViewCell {
    private let label = UILabel()
    private let container = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
        
        configureUpdateHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forItemAt(_ mbti: String) {
        label.text = mbti
    }
}

// MARK: Configure View
private extension MBTICollectionViewCell {
    func configureUI() {
        configureContainer()
        
        configureLabel()
    }
    
    func configureLayout() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.center.equalTo(container)
        }
    }
    
    func configureContainer() {
        container.backgroundColor = .clear
        container.layer.cornerRadius = 25
        container.layer.borderWidth = 1
        container.layer.borderColor = .tm(.semantic(.border(.tertiary)))
        contentView.addSubview(container)
    }
    
    func configureLabel() {
        label.textColor = .tm(.semantic(.text(.tertiary)))
        label.font = .tm(.title)
        container.addSubview(label)
    }
    
    func configureUpdateHandler() {
        configurationUpdateHandler = { [weak self] cell, state in
            if state.isSelected {
                self?.label.textColor = .tm(.semantic(.text(.primary)))
                self?.container.backgroundColor = .tm(.semantic(.background(.brand)))
                self?.container.layer.borderColor = UIColor.clear.cgColor
            } else {
                self?.label.textColor = .tm(.semantic(.text(.tertiary)))
                self?.container.backgroundColor = .clear
                self?.container.layer.borderColor = .tm(.semantic(.border(.tertiary)))
            }
        }
    }
}

