//
//  Debouncer.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

final class Debouncer {
    private var task: Task<(), Never>?
    private let delay: UInt64

    init(delay: Double) {
        self.delay = UInt64(delay * 1_000_000_000)
    }

    func run(action: @escaping () async -> Void) {
        task?.cancel()
        let delay = self.delay
        task = Task {
            do {
                try await Task.sleep(nanoseconds: delay)
                await action()
            } catch {
                print("디바운스 취소")
            }
        }
    }
}
