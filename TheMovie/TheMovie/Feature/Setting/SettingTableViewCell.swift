//
//  SettingTableViewCell.swift
//  TheMovie
//
//  Created by 김도형 on 1/29/25.
//

import UIKit

import SnapKit

final class SettingTableViewCell: UITableViewCell {
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        label.font = .systemFont(ofSize: 16)
        label.textColor = .tm(.semantic(.text(.primary)))
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forRowAt(_ title: String) {
        label.text = title
    }
}

extension String {
    static let settingTableCell = "SettingTableViewCell"
}
