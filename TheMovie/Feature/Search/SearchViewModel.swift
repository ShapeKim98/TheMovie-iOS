//
//  SearchViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/11/25.
//

import Foundation

final class SearchViewModel: ViewModel {
    enum Input {
        case viewDidAppear
        case textFieldShouldReturn(text: String?)
        case tableViewWillDisplay(text: String?, row: Int)
        case tableViewPrefetchRowsAt(text: String?, rows: [Int])
        case cellFavoriteButtonTouchUpInside(movieId: Int)
    }
    
    enum Output {
        case searchResults(_ value: [Movie]?)
        case recentQueries(_ value: [String]?)
        case failure(_ value: Error?)
    }
    
    struct Model {
        var search: Search? {
            didSet {
                guard oldValue != search else { return }
                if search?.results == nil {
                    continuation?.yield(.searchResults(nil))
                    return
                }
                if oldValue?.results != search?.results {
                    continuation?.yield(.searchResults(search?.results))
                    return
                }
            }
        }
        @UserDefault(forKey: .userDefaults(.recentQueries))
        var recentQueries: [String]? {
            didSet {
                guard oldValue != recentQueries else { return }
                continuation?.yield(.recentQueries(recentQueries))
            }
        }
        var failure: Error? {
            didSet {
                guard failure != nil else { return }
                continuation?.yield(.failure(failure))
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    
    private(set) var model = Model()
    
    private let searchClient = SearchClient.shared
    
    @UserDefault(
        forKey: .userDefaults(.movieBox),
        defaultValue: [:]
    )
    private(set) var movieBox: [String: Int]?
    
    private var isPaging = false
    let firstQuery: String
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
    }
    
    init(firstQuery: String) {
        self.firstQuery = firstQuery
    }
    
    deinit { model.continuation?.finish() }
    
    func input(_ action: Input) {
        switch action {
        case .viewDidAppear:
            guard !firstQuery.isEmpty else { return }
            fetchSearch(query: firstQuery)
        case let .textFieldShouldReturn(text):
            guard
                let text,
                !text.isEmpty,
                !text.filter({ !$0.isWhitespace }).isEmpty
            else { return }
            model.search = nil
            fetchSearch(query: text)
        case let .tableViewWillDisplay(text, row):
            guard
                model.search?.results.count == row + 2,
                let text
            else { return }
            paginationSearch(query: text)
        case .tableViewPrefetchRowsAt(let text, let rows):
            guard let text else { return }
            for row in rows {
                guard model.search?.results.count == row + 2 else {
                    continue
                }
                paginationSearch(query: text)
            }
        case let .cellFavoriteButtonTouchUpInside(movieId):
            let movieIdString = String(movieId)
            if movieBox?.contains(where: { $0.key == movieIdString }) ?? false {
                movieBox?.removeValue(forKey: movieIdString)
            } else {
                movieBox?.updateValue(movieId, forKey: movieIdString)
            }
        }
    }
}

private extension SearchViewModel {
    func fetchSearch(query: String) {
        updateRecentQueries(query: query)
        let request = SearchRequest(query: query, page: 1)
        searchClient.fetchSearch(request) { [weak self] result in
            guard let `self` else { return }
            switch result {
            case .success(let success):
                model.search = success
            case .failure(let failure):
                model.failure = failure
            }
        }
    }
    
    func paginationSearch(query: String) {
        guard
            let search = model.search,
            search.totalPages > search.page,
            !isPaging
        else { return }
        let request = SearchRequest(query: query, page: search.page + 1)
        searchClient.fetchSearch(request) { [weak self] result in
            guard let `self` else { return }
            switch result {
            case .success(let success):
                model.search?.page = success.page
                model.search?.totalPages = success.totalPages
                model.search?.totalResults = success.totalResults
                model.search?.results += success.results
            case .failure(let failure):
                model.failure = failure
            }
        }
    }
    
    func updateRecentQueries(query: String) {
        guard let recentQueries = model.recentQueries else {
            model.recentQueries = [query]
            return
        }
        guard let index = recentQueries.firstIndex(of: query) else {
            model.recentQueries?.insert(query, at: 0)
            return
        }
        model.recentQueries?.remove(at: index)
        model.recentQueries?.insert(query, at: 0)
    }
}
