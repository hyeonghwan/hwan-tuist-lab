//
//  Publisher+.swift
//  NetworkSample
//
//  Created by hwan on 7/27/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Combine

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>,
                                  on object: T) -> AnyCancellable
    {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
    
    func sinkWeak<T: AnyObject>(on object: T,
                                receiveValue: @escaping ((T, Self.Output) -> Void)) -> AnyCancellable
    {
        sink { [weak object] output in
            guard let object else { return }
            receiveValue(object, output)
        }
    }
    
    func sinkWeakStore<T: AnyObject>(on object: T,
                                     in subscriptions: inout Set<AnyCancellable>,
                                     receiveValue: @escaping ((T, Self.Output) -> Void))
    {
        sink { [weak object] output in
            guard let object else { return }
            receiveValue(object, output)
        }
        .store(in: &subscriptions)
    }
    
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}
