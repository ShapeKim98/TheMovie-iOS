//
//  DayViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

final class DayViewController: UIViewController {
    private let profileView = ProfileView()
    private let recentQueryView = RecentQueryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
    }
}

// MARK: Configure Views
private extension DayViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureProfileView()
        
        view.addSubview(recentQueryView)
    }
    
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        recentQueryView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(profileView.snp.bottom).offset(16)
        }
        recentQueryView.layoutIfNeeded()
    }
    
    func configureProfileView() {
        profileView.addButtonAction(profileViewButtonTouchUpInside)
        view.addSubview(profileView)
    }
}

// MARK: Functions
private extension DayViewController {
    func profileViewButtonTouchUpInside(_ action: UIAction) {
        
    }
}

@available(iOS 17.0, *)
#Preview {
    DayViewController()
}
