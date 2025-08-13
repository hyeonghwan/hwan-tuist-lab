//
//  Observable.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


final class HotObservable<Element>: BaseObservable<Element> {
    
    var source: Element {
        didSet {
            self.on(self.source)
        }
    }
    
    init(source: Element) {
        self.source = source
    }
    
    override func subscribe(_ observer: AnyObserver<Element>) -> Disposables {
        self.observers.append(observer)
        self.on(self.source)
        return DefaultDisposables(
            id: observer.id,
            disposables: self
        )
    }
}

extension HotObservable where Element == Void {
    static var void: HotObservable<Void> {
        HotObservable<Void>(source: ())
    }
}
