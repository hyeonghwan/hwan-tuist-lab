//
//  String+.swift
//  NetworkSample
//
//  Created by hwan on 7/27/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

extension String {
    func htmlStringToAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            let attr = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            let mutable = NSMutableAttributedString(attributedString: attr)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.lineBreakStrategy = .hangulWordPriority
            
            mutable.addAttributes(
                [
                    .font: UIFont.systemFont(ofSize: 13, weight: .light),
                    .foregroundColor: UIColor.label,
                    .paragraphStyle: paragraphStyle
                ],
                range: NSRange(location: 0, length: mutable.length)
            )
            
            return mutable
            
        } catch {
            print(error)
        }
        return nil
    }
}

extension String {
    // 1. 스레드 안전성을 위한 캐시와 접근 제어 큐
    private static let cache = NSCache<NSString, NSAttributedString>()
    private static let queue = DispatchQueue(label: "html.render.queue", qos: .userInitiated)

    func htmlToAttributedString(font: UIFont = .systemFont(ofSize: 13, weight: .light),
                                color: UIColor = .label,
                                completion: @escaping (NSAttributedString?) -> Void)
    {
        let key = self as NSString
        
        if let cached = String.cache.object(forKey: key) {
            completion(cached)
            return
        }
 
        Self.queue.async {
            guard let data = self.data(using: .utf8) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            var attributedString: NSAttributedString?
            do {
                let parsedString = try NSAttributedString(
                    data: data,
                    options: [
                        .documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf8.rawValue
                    ],
                    documentAttributes: nil
                )
                let mutable = NSMutableAttributedString(attributedString: parsedString)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byTruncatingTail
                paragraphStyle.lineBreakStrategy = .hangulWordPriority

                let fullRange = NSRange(location: 0, length: mutable.length)
                mutable.addAttributes([
                    .font: font,
                    .foregroundColor: color,
                    .paragraphStyle: paragraphStyle
                ], range: fullRange)
                
                attributedString = mutable
            
                if let finalString = attributedString {
                    Self.cache.setObject(finalString, forKey: key)
                }
                
            } catch {
                print("Failed To NSAttributedString: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(attributedString)
            }
        }
    }
}
