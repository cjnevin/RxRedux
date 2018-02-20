import Foundation
import XCTest

public class Spy<T> {
    public typealias SpyType = T
    private var spiedValue: T? = nil
    
    public init() { }
    
    public init(_ value: T) {
        spiedValue = value
    }
    
    public func set(_ value: T) {
        spiedValue = value
    }
    
    public func get() -> T? {
        return spiedValue
    }
}

extension Spy where Spy.SpyType: Equatable {
    public func expect(_ value: T, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(value, spiedValue, file: file, line: line)
    }
}

extension Spy where Spy.SpyType: Numeric, Spy.SpyType: Equatable {
    private var current: SpyType {
        return get() ?? 0
    }
    
    public func increment() {
        set(current + 1)
    }
    
    public func decrement() {
        set(current - 1)
    }
}
