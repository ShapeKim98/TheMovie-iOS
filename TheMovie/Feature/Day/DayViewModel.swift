//
//  DayViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/10/25.
//

import Foundation

final class DayViewModel: ViewModel {
    enum Input {
        case viewDidLoad
        case cellFavoriteButtonTouchUpInside(_ movieId: Int)
    }
    
    enum Output {
        case day(_ value: Day?)
        case failure(_ value: Error?)
    }
    
    struct Model {
        var day: Day? {
            didSet {
                guard oldValue != day else { return }
                continuation?.yield(.day(day))
            }
        }
        var failure: Error? {
            didSet {
                guard failure != nil else { return }
                continuation?.yield(.failure(failure))
            }
        }
        
        var continuation: AsyncStream<Output>.Continuation?
    }
    
    private let dayClient = DayClient.shared
    
    @UserDefault(
        forKey: .userDefaults(.movieBox),
        defaultValue: [String: Int]()
    )
    private(set) var movieBox: [String: Int]?
    
    private(set) var model = Model()
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            guard model.continuation == nil else {
                continuation.finish()
                return
            }
            model.continuation = continuation
        }
    }
    
    func cancel() {
        model.continuation?.finish()
        model.continuation = nil
    }
    
    func input(_ action: Input) {
        switch action {
        case .viewDidLoad:
            fetchDay()
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

private extension DayViewModel {
    func fetchDay() {
        dayClient.fetchDay(DayRequest(page: 1)) { [weak self] result in
            switch result {
            case .success(let success):
                self?.model.day = success
            case .failure(let failure):
                self?.model.failure = failure
            }
        }
    }
}
