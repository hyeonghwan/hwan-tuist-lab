//
//  String+extension.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//

import Foundation


extension String {
    var isNotEmpty: Bool { !isEmpty }
    var space: Self { " " }
    var empty: Self { "" }
    func removeSpace() -> Self {
        self.replacingOccurrences(of: space, with: empty)
    }
}
