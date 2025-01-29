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
    
    @UserDefault(forKey: .userDefaults(.movieBox))
    private var movieBox: [String: Int]?
    @UserDefault(forKey: .userDefaults(.recentQueries))
    private var recentQueries: [String]?
    
    private let searchClient = SearchClient.shared
    
    private var domain: Search? {
        didSet { didSetDomain() }
    }
    private var isPaging: Bool = false
    private var firstQuery: String
    
    weak var delegate: (any SearchViewControllerDelegate)?
    
    init(query: String = "") {
        searchController.searchBar.text = query
        self.firstQuery = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !firstQuery.isEmpty {
            fetchSearch(query: firstQuery)
            firstQuery = ""
        }
        
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
        searchController.searchBar.searchTextField.delegate = self
        searchController.delegate = self
        searchController.searchBar.searchTextField.keyboardAppearance = .dark
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .tm(.semantic(.text(.primary)))
        searchController.hidesNavigationBarDuringPresentation = false
        let textField = searchController.searchBar.searchTextField
        let backgroundColor = UIColor.tm(.semantic(.background(.secondary)), alpha: 0.2)
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
        view.addSubview(searchTableView)
    }
    
    func configureActivityIndicatorView() {
        activityIndicatorView.stopAnimating()
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
    func didSetDomain() {
        searchTableView.reloadData()
        
        let isLoading = domain == nil
        let isEmpty = domain?.results.isEmpty ?? true
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
}

// MARK: Functions
private extension SearchViewController {
    func fetchSearch(query: String) {
        guard !query.isEmpty else { return }
        
        updateRecentQueries(query: query)
        let request = SearchRequest(query: query, page: 1)
        searchClient.fetchSearch(request) { [weak self] result in
            guard let `self` else { return }
            switch result {
            case .success(let success):
                domain = success
            case .failure(let failure):
                handleFailure(failure)
            }
        }
    }
    
    func paginationSearch() {
        guard
            let domain,
            domain.totalPages > domain.page,
            !isPaging,
            let text = searchController.searchBar.text
        else { return }
        let request = SearchRequest(query: text, page: domain.page + 1)
        searchClient.fetchSearch(request) { [weak self] result in
            guard let `self` else { return }
            switch result {
            case .success(let success):
                self.domain?.page = success.page
                self.domain?.totalPages = success.totalPages
                self.domain?.totalResults = success.totalResults
                self.domain?.results += success.results
            case .failure(let failure):
                handleFailure(failure)
            }
        }
    }
    
    func updateRecentQueries(query: String) {
        defer { delegate?.updateRecentQueries() }
        
        guard let recentQueries else {
            self.recentQueries = [query]
            print(#function, 1)
            return
        }
        guard let index = recentQueries.firstIndex(of: query) else {
            self.recentQueries?.insert(query, at: 0)
            print(#function, 2)
            return
        }
        self.recentQueries?.remove(at: index)
        self.recentQueries?.insert(query, at: 0)
        print(#function, 3)
    }
}

extension SearchViewController: UITextFieldDelegate, UISearchControllerDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        domain = nil
        fetchSearch(query: text)
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
        domain?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: .searchTableCell,
            for: indexPath
        )
        guard
            let cell = cell as? SearchTableViewCell,
            let movie = domain?.results[indexPath.row]
        else { return UITableViewCell() }
        let isSelected = movieBox?.contains(where: { $0.key == String(movie.id) }) ?? false
        cell.delegate = self
        cell.forRowAt(movie, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = domain?.results[indexPath.row] else {
            return
        }
        let vieController = DetailViewController(movie)
        vieController.delegate = self
        push(vieController)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard domain?.results.count == indexPath.row + 2 else { return }
        paginationSearch()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard
                domain?.results.count == indexPath.row + 2
            else { continue }
            paginationSearch()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? SearchTableViewCell)?.cancelImageDownload()
    }
}

extension SearchViewController: SearchTableViewCellDelegate {
    func favoritButtonTouchUpInside(_ movieId: Int) {
        let movieIdString = String(movieId)
        if movieBox?.contains(where: { $0.key == movieIdString }) ?? false {
            movieBox?.removeValue(forKey: movieIdString)
        } else {
            movieBox?.updateValue(movieId, forKey: movieIdString)
        }
        delegate?.favoriteButtonTouchUpInsideFromSearch(movieId)
    }
}

extension SearchViewController: DetailViewControllerDelegate {
    func favoriteButtonTouchUpInside(movieId: Int) {
        delegate?.favoriteButtonTouchUpInsideFromSearch(movieId)
        
        let index = domain?.results.firstIndex(where: { $0.id == movieId })
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
