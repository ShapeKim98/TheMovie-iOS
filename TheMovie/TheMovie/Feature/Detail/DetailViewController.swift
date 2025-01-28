//
//  DetailViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import SnapKit

final class DetailViewController: UIViewController {
    private lazy var backdropCollectionView: UICollectionView = {
        configureBackdropCollectionView()
    }()
    private let backdropPageControl = UIPageControl()
    
    private var domain: Detail? = .mock
    private var backdropImages: [String] {
        let images = domain?.images?.backdrops.map(\.filePath)
        return Array(images?.prefix(5) ?? [])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
    }
}

// MARK: Configure View
private extension DetailViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        view.addSubview(backdropCollectionView)
        
        configureBackdropPageControll()
    }
    
    func configureLayout() {
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.width).multipliedBy(0.7)
        }
        
        backdropPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backdropCollectionView).inset(12)
        }
    }
    
    func configureBackdropCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width
        
        layout.itemSize = CGSize(width: width, height: width * 0.7)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            BackdropCollectionViewCell.self,
            forCellWithReuseIdentifier: .backdropCollectionCell
        )
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.tag = 0
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }
    
    func configureBackdropCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .backdropCollectionCell,
            for: indexPath
        ) as? BackdropCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        let path = backdropImages[indexPath.item]
        cell.forItemAt(path)
        return cell
    }
    
    func configureBackdropPageControll() {
        backdropPageControl.numberOfPages = backdropImages.count
        backdropPageControl.currentPage = 0
        view.addSubview(backdropPageControl)
    }
}

extension DetailViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: return backdropImages.count
        case 1: return 0
        case 2: return 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            return configureBackdropCell(collectionView, indexPath: indexPath)
        case 1:
            return UICollectionViewCell()
        case 2:
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / view.frame.width)
        backdropPageControl.currentPage = Int(index)
    }
}

@available(iOS 17.0, *)
#Preview {
    DetailViewController()
}
