//
//  NetworkMonitor.swift
//  TheMovie
//
//  Created by 김도형 on 1/31/25.
//

import Foundation
import Network

final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    
    deinit { monitor.cancel() }
    
    func monitoringStart() {
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    func monitoringHandler(_ handler: @escaping (NWPath) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                handler(path)
            }
        }
    }
}
