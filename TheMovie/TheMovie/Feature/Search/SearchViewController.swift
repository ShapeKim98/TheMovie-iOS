//
//  SearchViewController.swift
//  TheMovie
//
//  Created by 김도형 on 1/27/25.
//

import UIKit

import SnapKit

final class SearchViewController: UIViewController {
    private let searchTableView = UITableView()
    
    @UserDefaults(
        forKey: .userDefaults(.movieBox),
        defaultValue: [String: Int]()
    )
    private var movieBox: [String: Int]?
    
    private var domain: Search? = .mock
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
    }
}

// MARK: Configure Views
private extension SearchViewController {
    func configureUI() {
        view.backgroundColor = .tm(.semantic(.background(.primary)))
        
        configureNavigation()
        
        configureSearchController()
        
        configureTableView()
    }
    
    func configureLayout() {
        searchTableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "영화 검색"
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "영화를 검색해보세요."
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .tm(.semantic(.text(.primary)))
        let backgroundColor = UIColor.tm(.semantic(.background(.secondary))).withAlphaComponent(0.2)
        searchController.searchBar.searchTextField.backgroundColor = backgroundColor
        searchController.searchBar.searchTextField.leftView?.tintColor = .tm(.semantic(.icon(.tertiary)))
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func configureTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
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
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}

extension SearchViewController: UITableViewDelegate,
                                UITableViewDataSource {
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
}

extension SearchViewController: SearchTableViewCellDelegate {
    func favoritButtonTouchUpInside(_ movieId: Int) {
        let movieIdString = String(movieId)
        if movieBox?.contains(where: { $0.key == movieIdString }) ?? false {
            movieBox?.removeValue(forKey: movieIdString)
        } else {
            movieBox?.updateValue(movieId, forKey: movieIdString)
        }
        print(movieBox)
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: SearchViewController())
}
