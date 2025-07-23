//
//  Chat.swift
//  SeSAC7Step1Remind
//
//  Created by Jack on 7/18/25.
//

import Foundation
//채팅 화면에서 사용할 데이터 구조체
struct Chat: Hashable {
    let id = UUID()
    let user: User
    let date: String
    let message: String
    
    func isEqualDateAndUser(_ other: Chat) -> Bool {
        let currentDate = self.date.toDate("yyyy-MM-dd-HH-mm") ?? Date.now
        let otherDate = other.date.toDate("yyyy-MM-dd-HH-mm") ?? Date.now
        return user == other.user && currentDate == otherDate
    }
    
}
