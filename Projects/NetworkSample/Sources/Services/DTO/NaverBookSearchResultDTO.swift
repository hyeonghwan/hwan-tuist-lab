//
//  NaverBookSearchResult.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct NaverAPIResponse<SuccessData: Decodable>: Decodable {
    let data: SuccessData
    
    private enum CodingKeys: String, CodingKey {
        case errorCode
    }
    
    init(data: SuccessData) {
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.errorCode) {
            let errorData = try NaverSearchAPIError(from: decoder)
            throw errorData.errorCode
        } else {
            self.data = try SuccessData(from: decoder)
        }
    }
}


struct NaverSearchResultDTO<Item: Decodable>: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

final class BookDTO: Decodable {
    let title: String
    let link: String
    let image: String
    let author: String
    let discount: String
    let publisher: String
    let pubdate: String
    let isbn: String
    let description: String
}

final class ShoppingItemDTO: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productId: String
    let productType: String
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    
    init(title: String, link: String, image: String, lprice: String, hprice: String, mallName: String, productId: String, productType: String, brand: String, maker: String, category1: String, category2: String, category3: String, category4: String) {
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.hprice = hprice
        self.mallName = mallName
        self.productId = productId
        self.productType = productType
        self.brand = brand
        self.maker = maker
        self.category1 = category1
        self.category2 = category2
        self.category3 = category3
        self.category4 = category4
    }
    
    static var dummy: Self {
        .init(
            title: "스타리아 2층캠핑카",
            link: "",
            image: "",
            lprice: "19000000",
            hprice: "",
            mallName: "월드캠핑카",
            productId: "",
            productType: "",
            brand: "",
            maker: "",
            category1: "",
            category2: "",
            category3: "",
            category4: "")
    }
    
    static var dummyList: [ShoppingItemDTO] {
        (0...99).map { _ in .dummy }
    }
}
