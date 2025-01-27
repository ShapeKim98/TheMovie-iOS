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
    private lazy var dayCollectionView = {
        return configureDayCollectionView()
    }()
    
    private var domain: Day? = .mock
    
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
        
        dayCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentQueryView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(364)
        }
    }
    
    func configureProfileView() {
        profileView.addButtonAction(profileViewButtonTouchUpInside)
        view.addSubview(profileView)
    }
    
    func configureDayCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let spacing = CGFloat(16)
        layout.itemSize = CGSize(width: 200, height: 332)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            DayCollectionViewCell.self,
            forCellWithReuseIdentifier: .dayCollectionCell
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        return collectionView
    }
}

// MARK: Functions
private extension DayViewController {
    
}

extension DayViewController: UICollectionViewDataSource,
                             UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        domain?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .dayCollectionCell,
            for: indexPath
        )
        guard
            let cell = cell as? DayCollectionViewCell,
            let movie = domain?.results[indexPath.item]
        else { return UICollectionViewCell() }
        cell.forItemAt(movie)
        return cell
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
