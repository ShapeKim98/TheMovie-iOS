//
//  DetailViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/28/25.
//

import UIKit

import SnapKit

protocol DetailViewControllerDelegate: AnyObject {
    func favoriteButtonTouchUpInside(movieId: Int)
}

final class DetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var backdropCollectionView: UICollectionView = {
        configureBackdropCollectionView()
    }()
    private let backdropPageControl = UIPageControl()
    private let movieInfoLabel = UILabel()
    private let movieInfoLabels = [MovieInfoLabel]()
    private let hstack = UIStackView()
    private lazy var synopsisView: SynopsisView = {
        SynopsisView(overview: viewModel.model.detail.movie.overview)
    }()
    private let castLabel = UILabel()
    private lazy var castCollectionView: UICollectionView = {
        configureCastCollectionView()
    }()
    private let posterLabel = UILabel()
    private lazy var posterCollectionView: UICollectionView = {
        configurePosterCollectionView()
    }()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let favoriteButton = TMFavoriteButton()
    
    private let viewModel: DetailViewModel
    private var backdropImages: [String] {
        let images = viewModel.model.detail.images?.backdrops.map(\.filePath)
        return Array(images?.prefix(5) ?? [])
    }
    
    weak var delegate: (any DetailViewControllerDelegate)?
    
    init(_ movie: Movie) {
        self.viewModel = DetailViewModel(movie: movie)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBinding()
        
        configureUI()
        
        configureLayout()
        
        viewModel.input(.viewDidLoad)
    }
}

// MARK: Configure View
private extension DetailViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureNavigation()
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backdropCollectionView)
        
        configureBackdropPageControll()
        
        configureHStack()
        
        configureMovieInfoLabel()
        
        configureSynopsisView()
        
        configureCastLabel()
        
        contentView.addSubview(castCollectionView)
        
        configurePosterLabel()
        
        contentView.addSubview(posterCollectionView)
        
        configureActivityIndicatorView()
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.7)
        }
        
        backdropPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backdropCollectionView.snp.bottom).inset(12)
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
            make.top.equalTo(castLabel.snp.bottom)
            make.height.equalTo(120 + 16 + 24)
        }
        
        posterLabel.snp.makeConstraints { make in
            make.top.equalTo(castCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        posterCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(posterLabel.snp.bottom)
            make.height.equalTo(180 + 24)
            make.bottom.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureBackdropCollectionView() -> UICollectionView {
        let width = view.frame.width
        
        let layout = configureFlowLayout(spacing: 0)
        layout.itemSize = CGSize(width: width, height: width * 0.7)
        layout.sectionInset = .zero
        
        let collectionView = configureCollectionView(
            BackdropCollectionViewCell.self,
            identifier: .backdropCollectionCell,
            layout: layout
        )
        collectionView.isPagingEnabled = true
        collectionView.tag = 0
        
        collectionView.backgroundView = TMImagePlaceholder(iconSize: 40)
        
        return collectionView
    }
    
    func configureCastCollectionView() -> UICollectionView {
        let layout = configureFlowLayout(spacing: 16)
        layout.itemSize = CGSize(width: 160, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        let collectionView = configureCollectionView(
            CastCollectionViewCell.self,
            identifier: .castCollectionCell,
            layout: layout
        )
        collectionView.tag = 1
        
        collectionView.backgroundView = configurePlaceholderLabel(
            "캐스트 정보가 없어요."
        )
        
        return collectionView
    }
    
    func configurePosterCollectionView() -> UICollectionView {
        let layout = configureFlowLayout(spacing: 12)
        layout.itemSize = CGSize(width: 100, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        let collectionView = configureCollectionView(
            PosterCollectionViewCell.self,
            identifier: .posterCollectionCell,
            layout: layout
        )
        collectionView.tag = 2
        
        collectionView.backgroundView = configurePlaceholderLabel(
            "포스터 이미지가 존재하지 않아요."
        )
        
        return collectionView
    }
    
    func configureNavigation() {
        navigationItem.title = viewModel.model.detail.movie.title
        let movieId = "\(viewModel.model.detail.movie.id)"
        let isSelected = viewModel.model.movieBox?[movieId] != nil
        favoriteButton.isSelected = isSelected
        favoriteButton.addAction(
            UIAction(handler: favoriteButtonTouchUpInside),
            for: .touchUpInside
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    func configureBackdropCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
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
        backdropPageControl.overrideUserInterfaceStyle = .dark
        backdropPageControl.backgroundStyle = .prominent
        contentView.addSubview(backdropPageControl)
    }
    
    func configureMovieInfoLabel() {
        let movie = viewModel.model.detail.movie
        let releaseDate = movie.releaseDate
        let voteAverage = String(format: "%.1f", movie.voteAverage ?? 0)
        var genres = movie.genreIds?.map(\.title).prefix(2) ?? []
        let count = movie.genreIds?.count ?? 0
        if count > 2 {
            genres.append("+\(count - 2)")
        }
        let releaseLabel = MovieInfoLabel(image: "calendar", text: releaseDate ?? "")
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
        contentView.addSubview(hstack)
    }
    
    func configureCastLabel() {
        castLabel.text = "Cast"
        castLabel.textColor = .tm(.semantic(.text(.primary)))
        castLabel.font = .tm(.headline)
        contentView.addSubview(castLabel)
    }
    
    func configureSynopsisView() {
        synopsisView.delegate = self
        contentView.addSubview(synopsisView)
    }
    
    func configureCastCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .castCollectionCell,
            for: indexPath
        ) as? CastCollectionViewCell
        guard
            let cell,
            let cast = viewModel.model.detail.credits?.cast[indexPath.item]
        else { return UICollectionViewCell() }
        cell.forItemAt(cast)
        return cell
    }
    
    func configurePosterLabel() {
        posterLabel.text = "Poster"
        posterLabel.textColor = .tm(.semantic(.text(.primary)))
        posterLabel.font = .tm(.headline)
        contentView.addSubview(posterLabel)
    }
    
    func configurePosterCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .posterCollectionCell,
            for: indexPath
        ) as? PosterCollectionViewCell
        guard
            let cell,
            let path = viewModel.model.detail.images?.posters[indexPath.item]
        else { return UICollectionViewCell() }
        cell.forItemAt(path.filePath)
        return cell
    }
    
    func configureActivityIndicatorView() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .tm(.semantic(.icon(.brand)))
        view.addSubview(activityIndicatorView)
    }
    
    func configureFlowLayout(spacing: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        return layout
    }
    
    func configureCollectionView(
        _ cellClass: AnyClass?,
        identifier: String,
        layout: UICollectionViewLayout
    ) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }
    
    func configurePlaceholderLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .tm(.body)
        label.textColor = .tm(.semantic(.text(.tertiary)))
        label.textAlignment = .center
        return label
    }
}

// MARK: Data Bindins
private extension DetailViewController {
    func dataBinding() {
        Task { [weak self] in
            guard let self else { return }
            for await output in viewModel.output {
                switch output {
                case let .detail(detail):
                    bindDetail(detail)
                case let .failure(failure):
                    bindFailure(failure)
                case .movieBox:
                    bindMovieBox()
                case let .currentPage(currentPage):
                    bindCurrentPage(currentPage)
                }
            }
        }
    }
    
    func bindDetail(_ detail: Detail) {
        let isLoading = detail.images == nil || detail.credits == nil
        guard !isLoading else { return }
        
        backdropCollectionView.reloadData()
        castCollectionView.reloadData()
        posterCollectionView.reloadData()
        backdropPageControl.numberOfPages = backdropImages.count
        
        let backdropIsEmpty = backdropImages.isEmpty
        let castIsEmpty = detail.credits?.cast.isEmpty ?? true
        let posterIsEmpty = detail.images?.posters.isEmpty ?? true
        
        UIView.fadeAnimate { [weak self] in
            guard let `self` else { return }
            activityIndicatorView.alpha = 0
            backdropCollectionView.backgroundView?.alpha = backdropIsEmpty ? 1 : 0
            castCollectionView.backgroundView?.alpha = castIsEmpty ? 1 : 0
            posterCollectionView.backgroundView?.alpha = posterIsEmpty ? 1 : 0
        } completion: { [weak self] _ in
            guard let `self` else { return }
            activityIndicatorView.stopAnimating()
        }
    }
    
    func bindFailure(_ failure: Error?) {
        guard let failure else { return }
        handleFailure(failure)
    }
    
    func bindMovieBox() {
        favoriteButton.isSelected.toggle()

        if favoriteButton.isSelected {
            UINotificationFeedbackGenerator()
                .notificationOccurred(.success)
        } else {
            UINotificationFeedbackGenerator()
                .notificationOccurred(.warning)
        }
        let movieId = viewModel.model.detail.movie.id
        delegate?.favoriteButtonTouchUpInside(movieId: movieId)
    }
    
    func bindCurrentPage(_ currentPage: Int) {
        backdropPageControl.currentPage = currentPage
    }
}

// MARK: Functions
private extension DetailViewController {
    func favoriteButtonTouchUpInside(_ action: UIAction) {
        viewModel.input(.favoriteButtonTouchUpInside)
    }
}

extension DetailViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let detail = viewModel.model.detail
        switch collectionView.tag {
        case 0: return backdropImages.count
        case 1: return detail.credits?.cast.count ?? 0
        case 2: return detail.images?.posters.count ?? 0
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
            return configurePosterCell(collectionView, indexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.tag == 0 else { return }
        viewModel.input(.scrollViewDidScroll(
            offsetX: scrollView.contentOffset.x,
            width: view.frame.width
        ))
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

fileprivate extension String {
    static let castCollectionCell = "CastCollectionCell"
    
    static let backdropCollectionCell = "BackdropCollectionViewCell"
    
    static let posterCollectionCell = "PosterCollectionViewCell"
}

@available(iOS 17.0, *)
#Preview {
    DetailViewController(.mock)
}
