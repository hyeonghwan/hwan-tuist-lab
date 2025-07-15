
import UIKit
import Combine

extension UISegmentedControl {
    var selectionPublisher: AnyPublisher<Int, Never> {
        controlPublisher(for: .valueChanged)
            .compactMap { $0 as? UISegmentedControl }
            .map { $0.selectedSegmentIndex }
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    var editingChanged: AnyPublisher<String?, Never> {
        controlPublisher(for: .editingChanged)
            .compactMap { $0 as? UITextField }
            .map { $0.text }
            .eraseToAnyPublisher()
    }
}

extension UIControl {
    typealias _EventPublisher = UIControl.EventPublisher
    typealias Event = UIControl.Event
    
    func controlPublisher(for event: Event) -> _EventPublisher {
        return EventPublisher(control: self, event: event)
      }
    
    struct EventPublisher: Publisher {
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
