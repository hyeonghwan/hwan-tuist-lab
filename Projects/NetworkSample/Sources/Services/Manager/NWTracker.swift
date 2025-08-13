//
//  NetworkTracker.swift
//  NetworkSample
//
//  Created by hwan on 7/29/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Network
import Combine

typealias NetworkState = NWTracker.State

final class NWTracker {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "nwtracker.shopping.com")
    
    enum State {
        case wifi(Bool)
        case cellular(Bool)
        case other(Bool)
        case none
        
        var imageString: String {
            return switch self {
            case .wifi(let bool):
                bool ? "wifi" : "wifi.slash"
            case .cellular(let bool):
                bool ? "antenna.radiowaves.left.and.right" : "antenna.radiowaves.left.and.right.slash"
            case .other(let bool):
                bool ? "antenna.radiowaves.left.and.right" : "antenna.radiowaves.left.and.right.slash"
            case .none:
                "wifi.slash"
            }
        }
    }
    
    var state = CurrentValueSubject<State, Never>(.none)
    var custom_observable_state = NetworkSample.HotObservable<State>(source: .none)
    
    deinit {
        stopMonitoring()
    }
    
    init() {
        monitor.start(queue: queue)
        
        defer {
            setState(path: monitor.currentPath)
            monitor.pathUpdateHandler = { [weak self] path in
                DispatchQueue.main.async {
                    self?.setState(path: path)
                }
            }
        }
    }
    
    private func setState(path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            self.custom_observable_state.source = .wifi(path.status == .satisfied)
        } else if path.usesInterfaceType(.cellular) {
            self.custom_observable_state.source = .cellular(path.status == .satisfied)
        } else if path.usesInterfaceType(.other) {
            self.custom_observable_state.source = .other(path.status == .satisfied)
        }
        self.custom_observable_state.source = .cellular(path.status == .satisfied)
    }
    
    func stopMonitoring() { monitor.cancel() }
}
