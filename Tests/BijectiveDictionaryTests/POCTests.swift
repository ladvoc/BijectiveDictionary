//  =============================================================
//  File: POCTests.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Daniel Lyons on 09/16/2024
//  Copyright © 2024 Daniel Lyons. All rights reserved.
//  =============================================================

#if swift(>=6.0)
import Foundation
import Testing
@testable import BijectiveDictionary

@Test func _createEmpty() {
//    let fromLiteral: POCOrderedSetImplementation<Int, Character> = [:]
//    #expect(fromLiteral.isEmpty)
//    #expect(fromLiteral.count == 0)
    
    let fromInit = POCOrderedSetImplementation<Int, Character>()
    #expect(fromInit.isEmpty)
    #expect(fromInit.count == 0)
}

@Test func _createWithCapacity() {
    let dict = POCOrderedSetImplementation<String, Int>(minimumCapacity: 10)
     
    withKnownIssue {
        #expect(dict.capacity >= 10) // OrderedSet doesn't have a built-in capacity property
    }
}

@Test func _fromUniqueLeftRightPairs() {
    let uniquePairs = [
        (left: "A", right: 1),
        (left: "B", right: 2),
        (left: "C", right: 3)
    ]
    let dict = POCOrderedSetImplementation<String, Int>(uniqueLeftRightPairs: uniquePairs)
    #expect(dict.count == 3)
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func _fromStandardDictionary(standardDict: [String: Int]) throws {
    let dict = try #require(POCOrderedSetImplementation(standardDict))
    #expect(dict.count == standardDict.count)
}

@Test func _fromStandardDictionaryInvalid() {
    let nonUniqueRightValues = ["A": 1, "B": 2, "C": 1]
    #expect(POCOrderedSetImplementation(nonUniqueRightValues) == nil)
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func _toStandardDictionary(dict: POCOrderedSetImplementation<String, Int>) {
    let standardDict = Dictionary(dict)
    #expect(standardDict.count == dict.count)
}

@Test func _subscriptGetByLeft() {
    let dict: POCOrderedSetImplementation = ["A": 1, "B": 2, "C": 3]
    
    #expect(dict[left: "A"] == 1)
    #expect(dict[left: "B"] == 2)
    #expect(dict[left: "C"] == 3)
    #expect(dict[left: "D"] == nil)
}

@Test func _subscriptGetByRight() {
    let dict: POCOrderedSetImplementation = ["A": 1, "B": 2, "C": 3]
    
    #expect(dict[right: 1] == "A")
    #expect(dict[right: 2] == "B")
    #expect(dict[right: 3] == "C")
    #expect(dict[right: 4] == nil)
}

@Test func _subscriptSetByLeft() {
    var dict: POCOrderedSetImplementation = ["A": 1, "B": 2, "C": 3]
    
    dict[left: "A"] = 4
    withKnownIssue {
        #expect(dict[left: "A"] == 4, "Value should persist after set operation")
    }
    withKnownIssue {
        #expect(dict[right: 4] == "A", "Reverse mapping should hold")
    }
    withKnownIssue {
        #expect(dict[right: 1] == nil, "Previous mapping should no longer hold")
    }
    
    dict[left: "A"] = 5
    withKnownIssue {
        #expect(dict[right: 1] == nil, "Previous mapping should no longer hold")
    }
    
    dict[left: "A"] = nil
    withKnownIssue {
        #expect(dict[left: "A"] == nil)
    }
    
    dict[left: "D"] = nil
    #expect(dict[left: "D"] == nil)
}

@Test func _subscriptSetByRight() {
    var dict: POCOrderedSetImplementation = ["A": 1, "B": 2, "C": 3]
    
    dict[right: 3] = "D"
    withKnownIssue {
        #expect(dict[right: 3] == "D", "Value should persist after set operation")
    }
    withKnownIssue {
        #expect(dict[left: "D"] == 3, "Reverse mapping should hold")
    }
    withKnownIssue {
        #expect(dict[left: "C"] == nil, "Previous mapping should no longer hold")
    }
    
    dict[right: 3] = "E"
    withKnownIssue {
        #expect(dict[right: 3] == "E")
    }
    
    dict[right: 3] = nil
    withKnownIssue {
        #expect(dict[right: 3] == nil)
    }
    
    dict[right: 4] = nil
    #expect(dict[right: 4] == nil)
}
#endif
