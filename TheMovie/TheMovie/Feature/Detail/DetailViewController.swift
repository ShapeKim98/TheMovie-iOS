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
    private let movieInfoLabel = UILabel()
    private let movieInfoLabels = [MovieInfoLabel]()
    private let hstack = UIStackView()
    private lazy var synopsisView: SynopsisView = {
        SynopsisView(overview: domain?.movie.overview ?? "")
    }()
    private let castLabel = UILabel()
    private lazy var castCollectionView: UICollectionView = {
        configureCastCollectionView()
    }()
    
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
        
        configureHStack()
        
        configureMovieInfoLabel()
        
        configureSynopsisView()
        
        configureCastLabel()
        
        view.addSubview(castCollectionView)
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
        
        hstack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backdropCollectionView.snp.bottom).offset(16)
        }
        
        synopsisView.snp.makeConstraints { make in
            make.top.equalTo(hstack.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        castCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(castLabel.snp.bottom).offset(8)
            make.height.equalTo(120 + 16 + 24)
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
    
    func configureCastCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 60)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            CastCollectionViewCell.self,
            forCellWithReuseIdentifier: .castCollectionCell
        )
        collectionView.tag = 1
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
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
    
    func configureMovieInfoLabel() {
        guard let movie = domain?.movie else { return }
        let releaseDate = movie.releaseDate
        let voteAverage = String(format: "%.1f", movie.voteAverage)
        var genres = movie.genreIds.map(\.title).prefix(2)
        if movie.genreIds.count > 2 {
            genres.append("+\(movie.genreIds.count - 2)")
        }
        let releaseLabel = MovieInfoLabel(image: "calendar", text: releaseDate)
        let voteLabel = MovieInfoLabel(image: "star.fill", text: voteAverage)
        let genresLabel = MovieInfoLabel(
            image: "film",
            text: genres.joined(separator: ", "),
            isSeparator: false
        )
        
        hstack.addArrangedSubview(releaseLabel)
        hstack.addArrangedSubview(voteLabel)
        hstack.addArrangedSubview(genresLabel)
    }
    
    func configureHStack() {
        hstack.axis = .horizontal
        hstack.spacing = 8
        hstack.distribution = .fillProportionally
        view.addSubview(hstack)
    }
    
    func configureCastLabel() {
        castLabel.text = "Cast"
        castLabel.textColor = .tm(.semantic(.text(.primary)))
        castLabel.font = .tm(.headline)
        view.addSubview(castLabel)
    }
    
    func configureSynopsisView() {
        synopsisView.delegate = self
        view.addSubview(synopsisView)
    }
    
    func configureCastCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .castCollectionCell,
            for: indexPath
        ) as? CastCollectionViewCell
        guard
            let cell,
            let cast = domain?.credits?.cast[indexPath.item]
        else { return UICollectionViewCell() }
        cell.forItemAt(cast)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0: return backdropImages.count
        case 1: return domain?.credits?.cast.count ?? 0
        case 2: return 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            return configureBackdropCell(collectionView, indexPath: indexPath)
        case 1:
            return configureCastCell(collectionView, indexPath: indexPath)
        case 2:
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.tag == 0 else { return }
        let index = round(scrollView.contentOffset.x / view.frame.width)
        backdropPageControl.currentPage = Int(index)
    }
}

extension DetailViewController: SynopsisViewDelegate {
    func moreButtonTouchUpInside() {
        UIView.springAnimate { [weak self] in
            guard let `self` else { return }
            view.layoutIfNeeded()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    DetailViewController()
}
