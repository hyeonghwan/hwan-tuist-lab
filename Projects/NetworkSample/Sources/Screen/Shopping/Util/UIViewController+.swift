//
//  UIViewController+.swift
//  NetworkSample
//
//  Created by hwan on 7/27/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Combine

#if canImport(CombineInterception)
import CombineInterception

extension UIViewController {
    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        let selector = #selector(UIViewController.viewDidLoad)
        return publisher(for: selector)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

#endif
