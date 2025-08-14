//
//  ColdObservable.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


final class LazyObservable<Element>: BaseObservable<Element> {
    lazy var source: (_ element: Event<Element>) -> Void = { [weak self] event in
        switch event {
        case let .next(element):
            self?.on(element)
        case .completed:
            self?.onCompleted()
        case let .error(error):
            self?.onError(error)
        }
    }
}

extension LazyObservable where Element == Void {
    static var void: LazyObservable<Void> {
        LazyObservable<Void>()
    }
}
