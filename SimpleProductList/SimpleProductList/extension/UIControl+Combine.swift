//
//  UIControl+Combine.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/23.
//

import UIKit
import Combine

class InteractorSubscription<S: Subscriber, C: UIControl>: Subscription where S.Input == C {
    private let subscriber: S?
    private weak var control: C?
    private let event: UIControl.Event
    
    init(
        subscriber: S,
        control: C,
        event: UIControl.Event
    ) {
        self.subscriber = subscriber
        self.control = control
        self.event = event
        self.control?.addTarget(self, action: #selector(handleEvent(_:)), for: event)
        }
    
    @objc private func handleEvent(_ sender: UIControl) {
        _ = self.subscriber?.receive(sender as! C)
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        self.control?.removeTarget(self, action: #selector(handleEvent(_:)), for: self.event)
        self.control = nil
    }
}

struct InterationPublusher<C: UIControl>: Publisher {
    typealias Output = C
    typealias Failure = Never
    
    private weak var control: C?
    private let event: UIControl.Event
    
    init(control: C, event: UIControl.Event) {
        self.control = control
        self.event = event
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, C == S.Input {
        guard let control = control else {
            subscriber.receive(completion: .finished)
            return
        }
        
        let subscription = InteractorSubscription(
            subscriber: subscriber,
            control: control,
            event: event
        )
        
        subscriber.receive(subscription: subscription)
    }
}

protocol UIConrolPublishable: UIControl { }

extension UIConrolPublishable {
    func publisher(for event: UIControl.Event) -> InterationPublusher<Self> {
        return InterationPublusher(control: self, event: event)
    }
}

extension UIControl: UIConrolPublishable { }
