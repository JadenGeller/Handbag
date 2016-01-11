//
//  BagGenerator.swift
//  Handbag
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct BagGenerator<Element: Hashable>: GeneratorType {
    private var backing: [Element : Int]
    private var elementIndex: DictionaryIndex<Element, Int>
    private var duplicateIndex: Int
    
    internal init(_ backing: [Element : Int]) {
        self.backing = backing
        self.elementIndex = backing.startIndex
        self.duplicateIndex = 0
    }

    public mutating func next() -> Element? {
        guard elementIndex < backing.endIndex else { return nil }
        while duplicateIndex >= backing[elementIndex].1 {
            elementIndex = elementIndex.successor()
            duplicateIndex = 0
            guard elementIndex < backing.endIndex else { return nil }
        }
        duplicateIndex += 1
        return backing[elementIndex].0
    }
}