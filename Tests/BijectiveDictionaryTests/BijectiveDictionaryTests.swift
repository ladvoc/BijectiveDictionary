//  =============================================================
//  File: BijectiveDictionaryTests.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

#if swift(>=6.0)
import Testing
@testable import BijectiveDictionary

@Test func createEmpty() {
    let fromLiteral: BijectiveDictionary<Int, Character> = [:]
    #expect(fromLiteral.isEmpty)
    #expect(fromLiteral.count == 0)
    
    let fromInit = BijectiveDictionary<Int, Character>()
    #expect(fromInit.isEmpty)
    #expect(fromInit.count == 0)
}

@Test func createWithCapacity() {
    let dict = BijectiveDictionary<String, Int>(minimumCapacity: 10)
    #expect(dict.capacity >= 10)
}

@Test func fromUniqueLeftRightPairs() {
    let uniquePairs = [
        (left: "A", right: 1),
        (left: "B", right: 2),
        (left: "C", right: 3)
    ]
    #expect(BijectiveDictionary(uniqueLeftRightPairs: uniquePairs).count == 3)
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func fromStandardDictionary(standardDict: Dictionary<String, Int>) throws {
    let dict = try #require(BijectiveDictionary(standardDict))
    #expect(dict.count == standardDict.count)
}

@Test func fromStandardDictionaryInvalid() {
    let nonUniqueRightValues = ["A": 1, "B": 2, "C": 1]
    #expect(BijectiveDictionary(nonUniqueRightValues) == nil)
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func toStandardDictionary(dict: BijectiveDictionary<String, Int>) {
    let standardDict = Dictionary(dict)
    #expect(standardDict.count == dict.count)
}

@Test func subscriptGetByLeft() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    #expect(dict[left: "A"] == 1)
    #expect(dict[left: "B"] == 2)
    #expect(dict[left: "C"] == 3)
    #expect(dict[left: "D"] == nil)
}

@Test func subscriptGetByRight() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    #expect(dict[right: 1] == "A")
    #expect(dict[right: 2] == "B")
    #expect(dict[right: 3] == "C")
    #expect(dict[right: 4] == nil)
}

@Test func subscriptSetByLeft() {
    var dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    dict[left: "A"] = 4
    #expect(dict[left: "A"] == 4, "Value should persist after set operation")
    #expect(dict[right: 4] == "A", "Reverse mapping should hold")
    #expect(dict[right: 1] == nil, "Previous mapping should no longer hold")
    
    dict[left: "A"] = 5
    #expect(dict[left: "A"] == 5)
    
    dict[left: "A"] = nil
    #expect(dict[left: "A"] == nil)
    
    dict[left: "D"] = nil
    #expect(dict[left: "D"] == nil)
}

@Test func subscriptSetByRight() {
    var dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    dict[right: 3] = "D"
    #expect(dict[right: 3] == "D", "Value should persist after set operation")
    #expect(dict[left: "D"] == 3, "Reverse mapping should hold")
    #expect(dict[left: "C"] == nil, "Previous mapping should no longer hold")
    
    dict[right: 3] = "E"
    #expect(dict[right: 3] == "E")
    
    dict[right: 3] = nil
    #expect(dict[right: 3] == nil)
    
    dict[right: 4] = nil
    #expect(dict[right: 4] == nil)
}

@Test func subscriptGettersWithDefault() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    #expect(dict[left: "D", default: 4] == 4, "Should return default")
    #expect(dict[left: "A", default: -1] == 1, "Should not return default")
    
    #expect(dict[right: 4, default: "D"] == "D", "Should return default")
    #expect(dict[right: 1, default: "Z"] == "A", "Should not return default")
}

@Test func subscriptSettersWithDefault() {
    var dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    dict[left: "D", default: 4] += 1
    #expect(dict[left: "D"] == 5, "Should use default value")
    
    dict[left: "A", default: 4] += 1
    #expect(dict[left: "A"] == 2, "Should not use default value")
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func hashable(dict: BijectiveDictionary<String, Int>) {
    let copy = dict
    #expect(dict.hashValue == copy.hashValue)
    #expect(dict == copy)
    
    let otherDict: BijectiveDictionary = ["X": 2, "Y": 3, "Z": 4]
    #expect(dict.hashValue != otherDict.hashValue)
    #expect(dict != otherDict)
}

@Test func equalWithStandardDictionary() {
    let standardDict = ["A": 1, "B": 2, "C": 3]
    #expect(BijectiveDictionary(standardDict)! == standardDict)
    #expect(standardDict == BijectiveDictionary(standardDict)!)
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func removeAll(dict: BijectiveDictionary<String, Int>) {
    var dict = dict
    dict.removeAll()
    #expect(dict.isEmpty)
}

@Test func removeByRight() {
    var dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    #expect(dict.remove(byRight: 3) == "C")
    #expect(dict[left: "C"] == nil)
    #expect(dict[right: 3] == nil)
    
    #expect(dict.remove(byRight: 4) == nil)
}

@Test func removeByLeft() {
    var dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    
    #expect(dict.remove(byLeft: "C") == 3)
    #expect(dict[left: "C"] == nil)
    #expect(dict[right: 3] == nil)
    
    #expect(dict.remove(byLeft: "D") == nil)
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func sequence(dict: BijectiveDictionary<String, Int>) {
    
    for (leftValue, rightValue) in dict {
        #expect(dict[left: leftValue] == rightValue)
    }
}

@Test(arguments: [[:], ["A": 1, "B": 2, "C": 3]])
func collection(dict: BijectiveDictionary<String, Int>) {
    
    #expect(dict.startIndex <= dict.endIndex)
    
    for index in dict.indices {
        let (leftValue, rightValue) = dict[index]
        #expect(dict[left: leftValue] == rightValue)
    }
}

@Test func leftValues() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    #expect(Set(dict.leftValues) == ["A", "B", "C"])
}

@Test func rightValues() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    #expect(Set(dict.rightValues) == [1, 2, 3])
}
#endif
