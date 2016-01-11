//
//  BagIndex.swift
//  Handbag
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct BagIndex<Element: Hashable> {
    internal let offset: Int
    
    internal init(offset: Int) {
        self.offset = offset
    }
}

extension BagIndex: Equatable, Comparable { }
public func ==<Element>(lhs: BagIndex<Element>, rhs: BagIndex<Element>) -> Bool {
    return lhs.offset == rhs.offset
}
public func <<Element>(lhs: BagIndex<Element>, rhs: BagIndex<Element>) -> Bool {
    return lhs.offset < rhs.offset
}

extension BagIndex: BidirectionalIndexType {
    public func successor() -> BagIndex {
        return BagIndex(offset: offset.successor())
    }
    
    public func predecessor() -> BagIndex {
        return BagIndex(offset: offset.predecessor())
    }
}