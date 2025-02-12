//
//  ProfileImageViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/7/25.
//

import Foundation

protocol ProfileImageViewModelDelegate: AnyObject {
    func collectionViewDidSelectItemAt(selectedId: Int)
}

final class ProfileImageViewModel: ViewModel {
    enum Input {
        case collectionViewDidSelectItemAt(item: Int)
    }
    
    enum Output {
        case selectedId(_ oldValue: Int, _ newValue: Int)
    }
    
    struct Model {
        var selectedId: Int {
            didSet {
                guard oldValue != selectedId else { return }
                continuation?.yield(.selectedId(oldValue, selectedId))
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    
    private(set) var model: Model
    
    weak var delegate: (any ProfileImageViewModelDelegate)?
    
    init(selectedId: Int) {
        self.model = Model(selectedId: selectedId)
    }
    
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
        case let .collectionViewDidSelectItemAt(item):
            guard model.selectedId != item else { return }
            model.selectedId = item
            delegate?.collectionViewDidSelectItemAt(selectedId: model.selectedId)
        }
    }
}
