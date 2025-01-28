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
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    @UserDefaults(
        forKey: .userDefaults(.movieBox),
        defaultValue: [String: Int]()
    )
    private var movieBox: [String: Int]?
    
    private let dayClient = DayClient.shared
    
    private var domain: Day? {
        didSet { didSetDomain() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        fetchDay()
    }
}

// MARK: Configure Views
private extension DayViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureNavigation()
        
        configureActivityIndicatorView()
        
        configureProfileView()
        
        configureRecentQueryView()
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
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(dayCollectionView)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "오늘의 영화"
        let image = UIImage(systemName: "magnifyingglass")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            primaryAction: UIAction(handler: searchButtonTouchUpInside)
        )
        setTMBackButton()
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
    
    func configureActivityIndicatorView() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .tm(.semantic(.icon(.brand)))
        view.addSubview(activityIndicatorView)
    }
    
    func configureRecentQueryView() {
        recentQueryView.delegate = self
        view.addSubview(recentQueryView)
    }
}

// MARK: Data Bindings
private extension DayViewController {
    func didSetDomain() {
        dayCollectionView.reloadData()
        
        let isLoading = domain == nil
        UIView.fadeAnimate { [weak self] in
            guard let `self` else { return }
            activityIndicatorView.alpha = isLoading ? 1 : 0
            dayCollectionView.alpha = isLoading ? 0 : 1
        } completion: { [weak self] _ in
            guard let `self` else { return }
            if isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
        }
    }
}

// MARK: Functions
private extension DayViewController {
    func fetchDay() {
        dayClient.fetchDay(DayRequest(page: 1)) { [weak self] result in
            guard let `self` else { return }
            switch result {
            case .success(let success):
                domain = success
            case .failure(let failure):
                handleFailure(failure)
            }
        }
    }
    
    func searchButtonTouchUpInside(_ action: UIAction) {
        let viewController = SearchViewController()
        viewController.delegate = self
        push(viewController)
    }
    
    func profileViewButtonTouchUpInside(_ action: UIAction) {
        
    }
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
        let isSelected = movieBox?.contains(where: { $0.key == String(movie.id) }) ?? false
        cell.forItemAt(movie, isSelected: isSelected)
        cell.delegate = self
        return cell
    }
}

extension DayViewController: RecentQueryViewDelegate {
    func textButtonTouchUpInside(text: String) {
        let viewController = SearchViewController(query: text)
        viewController.delegate = self
        push(viewController)
    }
}

extension DayViewController: SearchViewControllerDelegate {
    func updateRecentQueries() {
        print(#function)
        recentQueryView.updateQueryButton()
        recentQueryView.layoutIfNeeded()
    }
}

extension DayViewController: DayCollectionViewCellDelegate {
    func favoritButtonTouchUpInside(_ movieId: Int) {
        let movieIdString = String(movieId)
        if movieBox?.contains(where: { $0.key == movieIdString }) ?? false {
            movieBox?.removeValue(forKey: movieIdString)
        } else {
            movieBox?.updateValue(movieId, forKey: movieIdString)
        }
        profileView.updateMovieBoxLabel()
        print(movieBox)
    }
}

@available(iOS 17.0, *)
#Preview {
    DayViewController()
}
