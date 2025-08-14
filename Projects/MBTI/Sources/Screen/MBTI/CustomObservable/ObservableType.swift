//
//  ObservableType.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

protocol ObservableType: AnyObject {
    associatedtype Element
    func subscribe(_ observer: AnyObserver<Element>) -> Disposables
}
