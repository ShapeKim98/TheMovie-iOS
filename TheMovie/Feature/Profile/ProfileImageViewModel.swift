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
    
    deinit { model.continuation?.finish() }
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
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
