//
//  Bag.swift
//  Handbag
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Bag<Element: Hashable> {
    private var backing: [Element : Int]
    
    public init() {
        backing = [:]
    }
}

extension Bag {
    public subscript(element: Element) -> Int {
        get {
            return backing[element] ?? 0
        }
        set {
            precondition(newValue >= 0, "Bag cannot contain a negative count of a given element.")
            backing[element] = (newValue == 0) ? nil : newValue
        }
    }
    
    public init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
        self.init()
        insertContentsOf(sequence)
    }
}

extension Bag {
    public mutating func insert(element: Element, count: Int = 1) {
        precondition(count >= 0, "Number of elements inserted must be non-negative.")
        self[element] += count
    }
    
    public mutating func remove(element: Element, count: Int = 1) {
        precondition(count >= 0, "Number of elements removed must be non-negative.")
        self[element] = max(0, self[element] - count)
    }
    
    public mutating func insertContentsOf<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
        sequence.forEach{ insert($0) }
    }
    
    public mutating func removeContentsOf<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
        sequence.forEach{ remove($0) }
    }
}

extension Set {
    public init(_ bag: Bag<Element>) {
        self.init(bag.backing.keys)
    }
}

extension Bag: DictionaryLiteralConvertible {
    public init(dictionaryLiteral elements: (Element, Int)...) {
        self.init()
        for (element, count) in elements {
            insert(element, count: count)
        }
    }
}

extension Bag: ArrayLiteralConvertible {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension Bag: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return backing.description
    }
    
    public var debugDescription: String {
        return backing.debugDescription
    }
}

extension Bag: Equatable, Hashable {
    public var hashValue: Int {
        return backing.map{ $0.hashValue ^ $1.hashValue }.reduce(0, combine: ^)
    }
}

public func ==<Element: Hashable>(lhs: Bag<Element>, rhs: Bag<Element>) -> Bool {
    return lhs.backing == rhs.backing
}

extension Bag: SequenceType {
    public func generate() -> BagGenerator<Element> {
        return BagGenerator(backing)
    }
}

// Note that the collection only contains elements with positive count.
extension Bag: Indexable {
    public var startIndex: BagIndex<Element> {
        return BagIndex(offset: 0)
    }
    
    public var endIndex: BagIndex<Element> {
        return BagIndex(offset: count)
    }
    
    public subscript(index: BagIndex<Element>) -> Element {
        let generator = AnySequence(self).dropFirst(index.offset).generate()
        return generator.next()!
    }
}

extension Bag: CollectionType {
    public var isEmpty: Bool {
        return backing.isEmpty
    }
    
    public var count: Int {
        return backing.values.lazy.filter{ $0 > 0 }.reduce(0, combine: +)
    }
    
    public func contains(element: Element) -> Bool {
        return self[element] > 0
    }
    
    /// Removes `element` and returns the count prior to removal.
    /// If count is `nil`, removes all copies of `element`.
    public mutating func remove(element: Element, count: Int? = nil) -> Int {
        let oldCount = self[element]
        self[element] -= count ?? self[element]
        return oldCount
    }
    
    public mutating func removeAll(keepCapacity: Bool = false) {
        backing.removeAll(keepCapacity: keepCapacity)
    }
    
    public var uniqueElements: LazyMapCollection<Dictionary<Element, Int>, Element> {
        return backing.keys
    }
    
    public var elementCounts: Dictionary<Element, Int> {
        return backing
    }
}

extension Bag {
    public mutating func unionInPlace(bag: Bag) {
        for (element, count) in bag.elementCounts {
            insert(element, count: count)
        }
    }
    
    public func union(bag: Bag) -> Bag {
        var copy = self
        copy.unionInPlace(bag)
        return copy
    }
    
    public mutating func subtractInPlace(bag: Bag) {
        for (element, count) in bag.elementCounts {
            remove(element, count: count)
        }
    }
    
    public func subtract(bag: Bag) -> Bag {
        var copy = self
        copy.subtractInPlace(bag)
        return copy
    }
    
    public mutating func intersectInPlace(bag: Bag) {
        self = intersect(bag)
    }
    
    public func intersect(bag: Bag) -> Bag {
        var result = Bag()
        for (element, count) in bag.elementCounts {
            result[element] = min(count, self[element])
        }
        return result
    }
}

extension Bag {
    public func isSubsetOf(bag: Bag) -> Bool {
        return subtract(bag).isEmpty
    }
    
    public func isStrictSubsetOf(bag: Bag) -> Bool {
        return isSubsetOf(bag) && self != bag
    }
    
    public func isSupersetOf(bag: Bag) -> Bool {
        return bag.isSubsetOf(self)
    }
    
    public func isStrictSupersetOf(bag: Bag) -> Bool {
        return bag.isStrictSubsetOf(self)
    }
    
    public func isDisjointWith(bag: Bag) -> Bool {
        return intersect(bag).isEmpty
    }
}

public func +<Element>(lhs: Bag<Element>, rhs: Bag<Element>) -> Bag<Element> {
    return lhs.union(rhs)
}

public func -<Element>(lhs: Bag<Element>, rhs: Bag<Element>) -> Bag<Element> {
    return lhs.subtract(rhs)
}

