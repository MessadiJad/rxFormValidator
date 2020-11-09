
import Foundation
import UIKit
import RxSwift
import RxCocoa

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

// Unfortunately the extra type annotations are required, otherwise the compiler gives an incomprehensible error.
extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

extension Reactive where Base : UIButton {
    public var valid : Binder<Bool> {
        return Binder(self.base) { button, valid in
            button.isEnabled = valid
            button.setTitleColor(valid ? UIColor(rgb: 0x11998e) : UIColor.gray, for: .normal)
        }
    }
}

extension ObservableType {
    
    /**
     Makes the observable Subscribe to concurrent background thread and Observe on main thread
     */
    public func subscribeConcurrentBackgroundToMainThreads() -> Observable<Element> {
        return self.subscribeOn(RXScheduler.concurrentBackground)
            .observeOn(RXScheduler.main)
    }
    
    /**
     Makes the observable Subscribe to concurrent background thread with delay and Observe on main thread
     */
    public func delaySubscribeConcurrentBackgroundToMainThreads(_ time: RxTimeInterval = .seconds(2)) -> Observable<Element> {
        return self.delaySubscription(time, scheduler: RXScheduler.concurrentBackground)
            .observeOn(RXScheduler.main)
    }
}

public struct RXScheduler {
    static let main = MainScheduler.instance
    static let concurrentMain = ConcurrentMainScheduler.instance
    
    static let serialBackground = SerialDispatchQueueScheduler.init(qos: .background)
    static let concurrentBackground = ConcurrentDispatchQueueScheduler.init(qos: .background)
    
    static let serialUtility = SerialDispatchQueueScheduler.init(qos: .utility)
    static let concurrentUtility = ConcurrentDispatchQueueScheduler.init(qos: .utility)
    
    static let serialUser = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    static let concurrentUser = ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)
    
    static let serialInteractive = SerialDispatchQueueScheduler.init(qos: .userInteractive)
    static let concurrentInteractive = ConcurrentDispatchQueueScheduler.init(qos: .userInteractive)
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    func append(_ subElement: Element.Element) {
        var newValue = value
        newValue.append(subElement)
        accept(newValue)
    }
    
    func append(contentsOf: [Element.Element]) {
        var newValue = value
        newValue.append(contentsOf: contentsOf)
        accept(newValue)
    }
    
    public func remove(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
    
    public func removeAll() {
        var newValue = value
        newValue.removeAll()
        accept(newValue)
    }
    
}
