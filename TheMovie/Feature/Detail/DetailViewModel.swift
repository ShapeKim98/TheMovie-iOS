//
//  DetailViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/11/25.
//

import Foundation

final class DetailViewModel: ViewModel {
    enum Input {
        case viewDidLoad
        case favoriteButtonTouchUpInside
        case scrollViewDidScroll(offsetX: CGFloat, width: CGFloat)
    }
    enum Output {
        case detail(_ value: Detail)
        case failure(_ value: Error?)
        case movieBox(_ value: [String: Int]?)
        case currentPage(_ value: Int)
    }
    struct Model {
        var detail: Detail {
            didSet {
                guard oldValue != detail else { return }
                if detail.images != nil && detail.credits != nil {
                    continuation?.yield(.detail(detail))
                }
            }
        }
        var failure: Error? {
            didSet {
                guard failure != nil else { return }
                continuation?.yield(.failure(failure))
            }
        }
        @UserDefault(
            forKey: .userDefaults(.movieBox),
            defaultValue: [:]
        )
        var movieBox: [String: Int]? {
            didSet {
                guard oldValue != movieBox else { return }
                continuation?.yield(.movieBox(movieBox))
            }
        }
        var currentPage: Int = 0 {
            didSet {
                guard oldValue != currentPage else { return }
                continuation?.yield(.currentPage(currentPage))
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    
    private let imagesClient = ImagesClient.shared
    private let creditsClient = CreditsClient.shared
    
    private(set) var model: Model
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
    }
    
    init(movie: Movie) {
        self.model = Model(detail: Detail(movie: movie))
    }
    
    deinit { model.continuation?.finish()  }
    
    func input(_ action: Input) {
        switch action {
        case .viewDidLoad:
            fetchImages()
            fetchCredits()
        case .favoriteButtonTouchUpInside:
            let movieIdString = String(model.detail.movie.id)
            let isContains = model.movieBox?[movieIdString] != nil
            if isContains {
                model.movieBox?.removeValue(forKey: movieIdString)
            } else {
                let movieId = model.detail.movie.id
                model.movieBox?[movieIdString] = movieId
            }
        case let .scrollViewDidScroll(offsetX, width):
            let index = round(offsetX / width)
            model.currentPage = Int(index)
        }
    }
}

private extension DetailViewModel {
    func fetchCredits() {
        let request = CreditsRequest(id: model.detail.movie.id)
        creditsClient.fetchCredits(request) { [weak self] result in
            switch result {
            case .success(let success):
                self?.model.detail.credits = success
            case .failure(let failure):
                self?.model.failure = failure
            }
        }
    }
    
    func fetchImages() {
        imagesClient.fetchImages(model.detail.movie.id) { [weak self] result in
            switch result {
            case .success(let success):
                self?.model.detail.images = success
            case .failure(let failure):
                self?.model.failure = failure
            }
        }
    }
}
