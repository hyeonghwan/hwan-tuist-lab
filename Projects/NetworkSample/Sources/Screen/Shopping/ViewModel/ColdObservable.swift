//
//  ColdObservable.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


final class ColdObservable<Element>: BaseObservable<Element> {
    
    lazy var source: (_ element: Element) -> Void = { [weak self] element in
        self?.on(element)
    }
}

extension ColdObservable where Element == Void {
    static var void: ColdObservable<Void> {
        ColdObservable<Void>()
    }
}
