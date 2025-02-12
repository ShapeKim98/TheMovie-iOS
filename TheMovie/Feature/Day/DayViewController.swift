//
//  DayViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

final class DayViewController: UIViewController {
    private let profileView = TMProfileView()
    private let recentQueryView = RecentQueryView()
    private lazy var dayCollectionView = {
        return configureDayCollectionView()
    }()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private let viewModel = DayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBinding()
        
        configureUI()
        
        configureLayout()
        
        viewModel.input(.viewDidLoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileView.updateProfile()
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
            make.top.equalTo(recentQueryView.snp.bottom)
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            DayCollectionViewCell.self,
            forCellWithReuseIdentifier: .dayCollectionCell
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.overrideUserInterfaceStyle = .dark
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
    func dataBinding() {
        Task { [weak self] in
            guard let self else { return }
            for await output in viewModel.output {
                switch output {
                case let .day(day):
                    bindedDay(day)
                case let .failure(failure):
                    bindedFailure(failure)
                }
            }
        }
    }
    
    func bindedDay(_ day: Day?) {
        dayCollectionView.reloadData()
        
        let isLoading = day == nil
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
    
    func bindedFailure(_ failure: Error?) {
        guard let failure else { return }
        handleFailure(failure)
    }
}

// MARK: Functions
private extension DayViewController {
    func searchButtonTouchUpInside(_ action: UIAction) {
        let viewController = SearchViewController()
        viewController.delegate = self
        push(viewController)
    }
    
    func profileViewButtonTouchUpInside(_ action: UIAction) {
        let viewController = ProfileViewController(mode: .edit)
        viewController.delegate = self
        let navigation = navigation(viewController)
        present(navigation, animated: true)
    }
    
    func updateMovieBox(_ movieId: Int) {
        profileView.updateMovieBoxLabel()
        
        let index = viewModel.model.day?.results.firstIndex(where: { $0.id == movieId })
        guard let index else { return }
        let indexPath = IndexPath(row: index, section: 0)
        let cell = dayCollectionView.cellForItem(at: indexPath)
        (cell as? DayCollectionViewCell)?.updateFavoriteButton()
    }
}

extension DayViewController: UICollectionViewDataSource,
                             UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.model.day?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .dayCollectionCell,
            for: indexPath
        )
        guard
            let cell = cell as? DayCollectionViewCell,
            let movie = viewModel.model.day?.results[indexPath.item]
        else { return UICollectionViewCell() }
        let isSelected = viewModel.movieBox?[String(movie.id)] != nil
        cell.forItemAt(movie, isSelected: isSelected)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.model.day?.results[indexPath.item] else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath)
        let viewController = DetailViewController(movie)
        viewController.delegate = self
        push(viewController, source: cell)
        collectionView.deselectItem(at: indexPath, animated: true)
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
        recentQueryView.updateQueryButton()
        recentQueryView.layoutIfNeeded()
    }
    
    func favoriteButtonTouchUpInsideFromSearch(_ movieId: Int) {
        updateMovieBox(movieId)
    }
}

extension DayViewController: ProfileViewControllerDelegate {
    func dismiss() {
        profileView.updateProfile()
    }
}

extension DayViewController: DetailViewControllerDelegate {
    func favoriteButtonTouchUpInside(movieId: Int) {
        updateMovieBox(movieId)
    }
}

extension DayViewController: DayCollectionViewCellDelegate {
    func favoriteButtonTouchUpInside(_ movieId: Int) {
        viewModel.input(.cellFavoriteButtonTouchUpInside(movieId))
        profileView.updateMovieBoxLabel()
    }
}

fileprivate extension String {
    static let dayCollectionCell = "DayCollectionViewCell"
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}
