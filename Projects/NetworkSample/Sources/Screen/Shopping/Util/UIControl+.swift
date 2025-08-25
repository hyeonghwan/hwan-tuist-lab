//
//  UIControl+.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Combine

extension ShoppingHeaderView {
    var selectedIndexPublisher: AnyPublisher<ShoppingSortType, Never> {
        let buttons = buttonList.values
        return Publishers.MergeMany(
            buttons.map { button in
                button.controlPublisher(for: .touchUpInside)
                    .map(\.tag)
                    .map { ShoppingSortType.matchTag($0) }
            }
        )
        .eraseToAnyPublisher()
    }
}

extension UIRefreshControl {
    var refreshPublisher: AnyPublisher<Void, Never> {
        self.controlPublisher(for: .valueChanged)
            .compactMap { ($0 as? UIRefreshControl) == nil ? nil : () }
            .eraseToAnyPublisher()
    }
}


extension UIControl {
    typealias _ControlPublisher = UIControl.ControlPublisher
    typealias _Event = UIControl.Event
    
    func controlPublisher(for event: Event) -> ControlPublisher {
        return ControlPublisher(control: self, event: event)
      }
    
    struct ControlPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<T>(subscriber: T) where T: Subscriber, Never == T.Failure, UIControl == T.Input {
            let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscrier
            self.event = event
            control.addTarget(self, action: #selector(eventPublished), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventPublished), for: event)
        }
        
        @objc func eventPublished() {
            _ = subscriber?.receive(control)
        }
    }
}

