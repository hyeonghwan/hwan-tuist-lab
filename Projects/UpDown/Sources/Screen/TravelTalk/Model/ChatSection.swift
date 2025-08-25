//
//  ChatSection.swift
//  UpDown
//
//  Created by hwan on 7/22/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct ChatSection: Hashable {
    let date: Date
    var items: [ChatViewModel]
    
    static func divideSectionUsingDate(_ chatRoom: ChatRoom?) -> [Self] {
        let initialChats: [ChatViewModel] = (chatRoom?.chatList ?? []).map {
            ChatViewModel(chat: $0, isTruncated: nil)
        }
        
        let groupedByDate: [String: [ChatViewModel]] =
        Dictionary(grouping: initialChats) { viewModel in
            String(viewModel.chat.date.prefix(10))
        }.reduce(into: [String: [ChatViewModel]](), { origin, tuple in
            let (key, viewModels) = tuple
            origin[key] = applyDateHidden(models: viewModels)
        })
        
        let sortedKeys = groupedByDate.keys.sorted()
        
        return sortedKeys.map { key in
            let date = key.toDate("yyyy-MM-dd") ?? Date()
            return ChatSection(date: date, items: groupedByDate[key] ?? [])
        }
    }
    
    private static func applyDateHidden(models: [ChatViewModel]) -> [ChatViewModel] {
        if models.count < 2 {
            return models
        }
        
        var viewModels: [ChatViewModel] = models
        var current = 0
        
        while current + 1 < viewModels.count {
            let isSameUserAndDate = viewModels[current].chat.isEqualDateAndUser(viewModels[current + 1].chat)
            
            if isSameUserAndDate {
                viewModels[current].isDateHidden = true
                viewModels[current + 1].isDateHidden = false
                viewModels[current + 1].isProfileHidden = true
            }
            
            current += 1
        }
        
        return viewModels
    }
}

struct ChatViewModel: Hashable, CustomStringConvertible {
    let chat: Chat
    var isDateHidden: Bool = false
    var isProfileHidden: Bool = false
    var isTruncated: CGFloat?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(chat.id)
    }
    
    static func == (lhs: ChatViewModel, rhs: ChatViewModel) -> Bool {
        lhs.chat.id == rhs.chat.id
    }
    
    var description: String {
        "chat: \(chat), isDateHidden: \(isDateHidden), isTruncated: \(String(describing: isTruncated))"
    }
}
