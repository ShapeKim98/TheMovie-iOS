//
//  SearchViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

protocol SearchViewControllerDelegate: AnyObject {
    func updateRecentQueries()
    func favoriteButtonTouchUpInsideFromSearch(_ movieId: Int)
}

final class SearchViewController: UIViewController {
    private let searchTableView = UITableView()
    private let searchController = UISearchController()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    let viewModel: SearchViewModel
    
    weak var delegate: (any SearchViewControllerDelegate)?
    
    init(query: String = "") {
        searchController.searchBar.text = query
        self.viewModel = SearchViewModel(firstQuery: query)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.input(.viewDidAppear)
        
        searchController.isActive = true
    }
}

// MARK: Configure Views
private extension SearchViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureNavigation()
        
        configureActivityIndicatorView()
        
        configureSearchController()
        
        configureEmptyLabel()
        
        configureTableView()
    }
    
    func configureLayout() {
        searchTableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(searchTableView)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(searchTableView)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "영화 검색"
        setTMBackButton()
    }
    
    func configureSearchController() {
        searchController.searchBar.placeholder = "영화를 검색해보세요."
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .tm(.semantic(.text(.primary)))
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        
        let textField = searchController.searchBar.searchTextField
        let backgroundColor = UIColor.tm(.semantic(.background(.secondary)), alpha: 0.2)
        
        textField.delegate = self
        textField.keyboardAppearance = .dark
        textField.backgroundColor = backgroundColor
        textField.leftView?.tintColor = .tm(.semantic(.icon(.tertiary)))
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func configureTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.prefetchDataSource = self
        searchTableView.backgroundColor = .clear
        searchTableView.register(
            SearchTableViewCell.self,
            forCellReuseIdentifier: .searchTableCell
        )
        searchTableView.keyboardDismissMode = .onDrag
        searchTableView.separatorColor = .tm(.semantic(.border(.tertiary)))
        searchTableView.separatorInset = .zero
        searchTableView.overrideUserInterfaceStyle = .dark
        view.addSubview(searchTableView)
    }
    
    func configureActivityIndicatorView() {
        if viewModel.firstQuery.isEmpty {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .tm(.semantic(.icon(.brand)))
        view.addSubview(activityIndicatorView)
    }
    
    func configureEmptyLabel() {
        emptyLabel.isHidden = true
        emptyLabel.text = "원하는 검색결과를 찾지 못했습니다."
        emptyLabel.textColor = .tm(.semantic(.text(.tertiary)))
        emptyLabel.font = .tm(.caption)
        view.addSubview(emptyLabel)
    }
}

// MARK: Data Bindings
private extension SearchViewController {
    func dataBinding() {
        Task { [weak self] in
            guard let self else { return }
            for await output in viewModel.output {
                switch output {
                case let .searchResults(searchResults):
                    bindSearchResults(searchResults)
                case .recentQueries:
                    bindRecentQueries()
                case let .failure(failure):
                    bindFailure(failure)
                }
            }
        }
    }
    
    func bindSearchResults(_ searchResults: [Movie]?) {
        print(#function)
        searchTableView.reloadData()
        
        let isLoading = searchResults == nil
        let isEmpty = searchResults?.isEmpty ?? true
        
        UIView.fadeAnimate { [weak self] in
            guard let `self` else { return }
            emptyLabel.alpha = isEmpty ? 1 : 0
            activityIndicatorView.alpha = isLoading ? 1 : 0
            searchTableView.alpha = isLoading ? 0 : 1
        } completion: { [weak self] _ in
            guard let `self` else { return }
            if isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            emptyLabel.isHidden = !isEmpty
        }
    }
    
    func bindRecentQueries() {
        print(#function)
        delegate?.updateRecentQueries()
    }
    
    func bindFailure(_ failure: Error?) {
        print(#function)
        guard let failure else { return }
        handleFailure(failure)
    }
}

extension SearchViewController: UITextFieldDelegate, UISearchControllerDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.input(.textFieldShouldReturn(text: textField.text))
        searchController.searchBar.searchTextField.resignFirstResponder()
        return true
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            if searchController.searchBar.text?.isEmpty ?? true {
                searchController.searchBar.searchTextField.becomeFirstResponder()
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate,
                                UITableViewDataSource,
                                UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.model.search?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .searchTableCell,
            for: indexPath
        )
        guard
            let cell = cell as? SearchTableViewCell,
            let movie = viewModel.model.search?.results[indexPath.row]
        else { return UITableViewCell() }
        let isSelected = viewModel.movieBox?.contains(where: { $0.key == String(movie.id) }) ?? false
        cell.delegate = self
        let query = searchController.searchBar.text ?? ""
        cell.forRowAt(movie, isSelected: isSelected, query: query)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel.model.search?.results[indexPath.row] else {
            return
        }
        let vieController = DetailViewController(movie)
        vieController.delegate = self
        push(vieController)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.input(.tableViewWillDisplay(
            text: searchController.searchBar.text,
            row: indexPath.row
        ))
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.input(.tableViewPrefetchRowsAt(
            text: searchController.searchBar.text,
            rows: indexPaths.map(\.row)
        ))
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? SearchTableViewCell)?.cancelImageDownload()
    }
}

extension SearchViewController: SearchTableViewCellDelegate {
    func favoritButtonTouchUpInside(_ movieId: Int) {
        viewModel.input(.cellFavoriteButtonTouchUpInside(movieId: movieId))
        delegate?.favoriteButtonTouchUpInsideFromSearch(movieId)
    }
}

extension SearchViewController: DetailViewControllerDelegate {
    func favoriteButtonTouchUpInside(movieId: Int) {
        delegate?.favoriteButtonTouchUpInsideFromSearch(movieId)
        
        let index = viewModel.model.search?.results.firstIndex(where: { $0.id == movieId })
        guard let index else { return }
        let indexPath = IndexPath(row: index, section: 0)
        let cell = searchTableView.cellForRow(at: indexPath)
        (cell as? SearchTableViewCell)?.updateFavoriteButton()
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: SearchViewController())
}
