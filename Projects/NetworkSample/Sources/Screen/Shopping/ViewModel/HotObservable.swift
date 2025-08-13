//
//  Observable.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


final class HotObservable<Element>: BaseObservable<Element>,
                                 Disposables {
    var source: Element {
        didSet { self.on() }
    }
    
    var isDisposed: Bool = false

    private var observers = [AnyObserver<Element>]()
    
    init(source: Element) {
        self.source = source
    }
    
    func on() {
        for observer in observers {
            observer.receive(.next(self.source))
        }
    }
    
    override func subscribe(_ observer: AnyObserver<Element>) -> Disposables {
        self.observers.append(observer)
        self.on()
        return self
    }
    
    func subscribeOn(
        onNext: @escaping (Element) -> Void,
        onError: @escaping (Error) -> Void = { _ in },
        completed: @escaping () -> Void = { }
    ) -> Disposables
    {
        let observer = AnyObserver<Element>.init(handler: { [weak self] event in
            switch event {
            case .completed:
                completed()
                
                guard let disposed = self?.isDisposed else { return }
                if !disposed { self?.dispose() }
                
            case let .error(error):
                onError(error)
                
                guard let disposed = self?.isDisposed else { return }
                if !disposed { self?.dispose() }
                
            case let .next(element):
                onNext(element)
            }
        })
        return subscribe(observer)
    }
    
    func disposed(in bag: Bag) {
        bag.subscriptions.insert(
            DefaultDisposables(
                id: self.id,
                disposables: self
            )
        )
    }
    
    func dispose() {
        self.observers.removeAll()
        self.isDisposed = true
    }
}

extension HotObservable where Element == Void {
    static var void: HotObservable<Void> {
        HotObservable<Void>(source: ())
    }
}
