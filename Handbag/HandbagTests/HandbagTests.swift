//
//  HandbagTests.swift
//  HandbagTests
//
//  Created by Jaden Geller on 1/11/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Handbag

class HandbagTests: XCTestCase {
    
    func testDictionaryLiteral() {
        let bag: Bag = ["hi" : 2, "bye" : 3, "ha" : 0]
        XCTAssertEqual(2, bag["hi"])
        XCTAssertEqual(3, bag["bye"])
        XCTAssertEqual(0, bag["ha"])
        XCTAssertEqual(0, bag["hehe"])
    }
    
    func testArrayLiteral() {
        let bag: Bag = ["hi", "hi", "bye", "bye", "bye"]
        XCTAssertEqual(2, bag["hi"])
        XCTAssertEqual(3, bag["bye"])
        XCTAssertEqual(0, bag["hehe"])
    }
    
    func testCollection() {
        let bag: Bag = ["hi" : 2, "bye" : 8, "ha" : 0, "hehe" : 4]
        let array = Array(bag)
        XCTAssertEqual(14, array.count)
        XCTAssertEqual(2, array.filter{ $0 == "hi" }.count)
        XCTAssertEqual(8, array.filter{ $0 == "bye" }.count)
        XCTAssertEqual(4, array.filter{ $0 == "hehe" }.count)
    }
    
    func testSet() {
        let a: Bag = ["hi" : 2, "bye" : 8, "ha" : 0, "hehe" : 4]
        let b: Bag = ["hi" : 7, "bye" : 2, "bleh" : 6]
        
        XCTAssertEqual(["hi" : 9, "bye" : 10, "hehe" : 4, "bleh" : 6], a + b)
        XCTAssertEqual(["bye" : 6, "hehe" : 4], a - b)
        XCTAssertEqual(["hi" : 5, "bleh" : 6], b - a)
        XCTAssertEqual(["hi" : 2, "bye" : 2], a.intersect(b))
    }
    
    func testSubsetSuperset() {
        let a: Bag = ["hi" : 2, "bye" : 8, "ha" : 0, "hehe" : 4]
        let aa: Bag = a + ["hi"]
        
        XCTAssertFalse(a.isStrictSubsetOf(a))
        XCTAssertTrue(a.isStrictSubsetOf(aa))
        XCTAssertFalse(aa.isStrictSubsetOf(a))
    
        XCTAssertTrue(a.isSubsetOf(a))
        XCTAssertTrue(a.isSubsetOf(aa))
        XCTAssertFalse(aa.isSubsetOf(a))

        XCTAssertFalse(a.isStrictSupersetOf(a))
        XCTAssertFalse(a.isStrictSupersetOf(a))
        XCTAssertTrue(aa.isStrictSupersetOf(a))
        
        XCTAssertTrue(a.isSupersetOf(a))
        XCTAssertFalse(a.isSupersetOf(aa))
        XCTAssertTrue(aa.isSupersetOf(a))
    }
    
    func testDisjoint() {
        XCTAssertFalse((["hi", "hi", "bye"] as Bag).isDisjointWith(["hi", "bye", "bye"] as Bag))
        XCTAssertFalse((["hi", "hi", "bye"] as Bag).isDisjointWith(["hi", "hi", "bye"] as Bag))
        XCTAssertFalse((["hi", "hi", "bye"] as Bag).isDisjointWith(["hi", "hi", "hi", "bye"] as Bag))
        XCTAssertTrue((["hi", "hi", "bye"] as Bag).isDisjointWith(["hey", "hello", "hello"] as Bag))
    }
}
