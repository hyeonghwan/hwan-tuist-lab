//
//  ShoppingViewModel.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Combine
import HwanMacros

@Logging
final class ShoppingViewModel {
    
    struct Model {
        var list: [ShoppingItemDTO]
        var priorCount: Int
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Output Subject
    private(set) var shoppingListSubject = CurrentValueSubject<Model, Never>(Model(list: [], priorCount: 0))
}
