//
//  SettingViewModel.swift
//  TheMovie
//
//  Created by 김도형 on 2/11/25.
//

import Foundation

final class SettingViewModel: ViewModel {
    enum Input {
        case tableViewDidSelectRowAt
        case withdrawButtonTouchUpInside
        case cancelButtonTouchUpInside
    }
    
    enum Output {
        case isPresentWithdrawAlert(_ value: Bool)
    }
    
    struct Model {
        var isPresentWithdrawAlert: Bool = false {
            didSet {
                guard oldValue != isPresentWithdrawAlert else { return }
                if isPresentWithdrawAlert {
                    continuation?.yield(.isPresentWithdrawAlert(isPresentWithdrawAlert))
                    return
                }
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    
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
        case .tableViewDidSelectRowAt:
            model.isPresentWithdrawAlert = true
        case .withdrawButtonTouchUpInside:
            for key in UserDefaultsKey.allCases {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        case .cancelButtonTouchUpInside:
            model.isPresentWithdrawAlert = false
        }
    }
}
