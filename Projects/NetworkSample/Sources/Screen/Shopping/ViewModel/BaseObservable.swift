//
//  BaseObservable.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

class BaseObservable<Element>: ObservableType, Disposables {
    func disposed(in bag: Bag) { }
    
    var id = UUID()
    
    var observers = [AnyObserver<Element>]()
    var isDisposed: Bool = false
    
    func on(_ element: Element) {
        for observer in observers {
            observer.receive(.next(element))
        }
    }
    
    func subscribe(_ observer: AnyObserver<Element>) -> Disposables {
        self.observers.append(observer)
        return DefaultDisposables(
            id: observer.id,
            disposables: self
        )
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

    
    func subscribeAsync(
        onNext: @escaping (Element) async -> Void,
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
                Task { await onNext(element) }
            }
        })
        return subscribe(observer)
    }
    
    func dispose() {
        self.observers.removeAll()
        self.isDisposed = true
    }
    
    func dispose(id: UUID) {
        if let index = self.observers.firstIndex(where: { observer in observer.id == id }) {
            self.observers.remove(at: index)
        }
    }
}
