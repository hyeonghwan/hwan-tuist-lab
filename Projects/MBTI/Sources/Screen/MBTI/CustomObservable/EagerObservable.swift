//
//  Observable.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


final class EagerObservable<Element>: BaseObservable<Element> {
    
    var source: Event<Element> {
        didSet {
            switch self.source {
            case let .next(element):
                self.on(element)
                
            case .completed:
                self.onCompleted()
                
            case let .error(error):
                self.onError(error)
            }
        }
    }
    
    var value: Element {
        if case let .next(origin) = self.source {
            return origin
        } else {
            fatalError()
        }
    }
    
    init(source: Event<Element>) {
        self.source = source
    }
    
    override func subscribe(_ observer: AnyObserver<Element>) -> Disposables {
        self.observers.append(observer)
        
        if case let .next(element) = source {
            self.on(element)
        }
        
        return DefaultDisposables(
            id: observer.id,
            disposables: self
        )
    }
}

extension EagerObservable where Element == Void {
    static var void: EagerObservable<Void> {
        EagerObservable<Void>(source: .next(()))
    }
}
