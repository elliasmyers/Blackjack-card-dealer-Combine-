import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Create a Blackjack card dealer") {
    let dealtHand = PassthroughSubject<Hand, HandError>()
    
    final class DealHandSubscriber: Subscriber {
       
        
        typealias Input = Hand
        typealias Failure = HandError
        
        func receive(subscription: Subscription) {
            subscription.request(.max(1))
        }
        
        func receive(_ input: Hand) -> Subscribers.Demand {
            print("Received Value (subscriber)", input.points, input.cardString)
            
            return .none
        }
        
        func receive(completion: Subscribers.Completion<HandError>) {
            switch completion {
            case let .finished:
                print("Received Completion  (subscriber)", completion)
            case let .failure(error):
                print("Received error  (subscriber)", error)
            }
        }
        
    }
    
    
    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining = 52
        var hand = Hand()
        
        for _ in 0 ..< cardCount {
            let randomIndex = Int.random(in: 0 ..< cardsRemaining)
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
    
        
        // Add subscription to dealtHand here
        
        let subscriber = DealHandSubscriber()
        
        dealtHand.subscribe(subscriber)
        
//        let subscription = dealtHand
//            .sink { completion in
//
//                switch completion {
//                case let .finished:
//                    print("Received Completion", completion)
//                case let .failure(error):
//                    print("Received error", error)
//                }
//
////                if case let .failure(error) = complition {
////                    print(error)
////                }
////
////                print("Received Completion", complition)
//            } receiveValue: { value in
//                print("Received Value", value.points, value.cardString)
//            }
        
        
        
        
        // Add code to update dealtHand here
        if (hand.points > 21) {
            dealtHand.send(completion: .failure(HandError.busted))
        } else {
            dealtHand.send(hand)
            dealtHand.send(completion: .finished)
        }
        
        
        
    }
    deal(2)
}

