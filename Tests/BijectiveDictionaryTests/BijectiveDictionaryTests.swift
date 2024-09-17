//  =============================================================
//  File: BijectiveDictionaryTests.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

#if swift(>=6.0)
import Foundation
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
func fromStandardDictionary(standardDict: [String: Int]) throws {
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
        #expect(dict[right: rightValue] == leftValue)
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
  
    let leftValues = dict.leftValues
    let assertions = ["A", "B", "C"]
    for assertion in assertions {
        #expect(leftValues.contains(assertion))
    }
}

@Test func rightValues() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    #expect(Set(dict.rightValues) == [1, 2, 3])
  
    let rightValues = dict.rightValues
    let assertions = [1, 2, 3]
    for assertion in assertions {
        #expect(rightValues.contains(assertion))
    }
}

@Test("leftValues and rightValues should have the same order")
func leftRightValues() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    let leftRightZip = zip(dict.leftValues, dict.rightValues)
    for (leftV, rightV) in leftRightZip {
        #expect(dict[left: leftV] == rightV)
        #expect(dict[right: rightV] == leftV)
    }
}

@Test("Encodable behavior should be equivalent to `Dictionary`")
func encodableConformance() throws {
    let dict = ["A": 1, "B": 2, "C": 3]
    let bijectiveDict = BijectiveDictionary(dict)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    
    let dictData = try encoder.encode(dict)
    let dictJSONString = String(decoding: dictData, as: UTF8.self)
    
    let bijectiveDictData = try encoder.encode(bijectiveDict)
    let bijectiveDictJSONString = String(decoding: bijectiveDictData, as: UTF8.self)

    #expect(dictData == bijectiveDictData)
    #expect(dictJSONString == bijectiveDictJSONString)
}

@Test("Decodable behavior should be equivalent to `Dictionary`")
func decodableConformance() throws {
    let jsonData = Data(#"{ "A": 1, "B": 2, "C": 3 }"#.utf8)
    
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(BijectiveDictionary<String, Int>.self, from: jsonData)
    
    let control = BijectiveDictionary(["A": 1, "B": 2, "C": 3])
    #expect(decoded == control)
}

@Test
func testAThousand() {
    var bijectiveDict = BijectiveDictionary<Int, String>(minimumCapacity: 1000)
    for index in 0..<1000 {
        bijectiveDict[left: index] = String(index)
        #expect(bijectiveDict[left: index] == String(index))
        #expect(bijectiveDict[right: String(index)] == index)
    }
    #expect(bijectiveDict.count == 1000)
    for leftV in bijectiveDict.leftValues {
        print("leftV: \(leftV)")
    }
    for rightV in bijectiveDict.rightValues {
        print("rightV: \(rightV)")
    }
    
    // assert that leftValues and rightValues have the same order
    let leftRightZip = zip(bijectiveDict.leftValues, bijectiveDict.rightValues)
    for (leftV, rightV) in leftRightZip {
        #expect(bijectiveDict[left: leftV] == rightV)
        #expect(bijectiveDict[right: rightV] == leftV)
    }
}

@Test
func findPairByLeft() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    #expect(dict.findPairByLeft("A")?.left == "A")
    #expect(dict.findPairByLeft("A")?.right == 1)
    #expect(dict.findPairByLeft("D") == nil)
}

@Test
func findPairByRight() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    #expect(dict.findPairByRight(1)?.left == "A")
    #expect(dict.findPairByRight(1)?.right == 1)
    #expect(dict.findPairByRight(4) == nil)
}

@Test
func conflict() {
    let dict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
    #expect(dict.conflict(with: ("D", 4)) == nil)
    #expect(dict.conflict(with: ("A", 0)) == .left)
    #expect(dict.conflict(with: ("E", 1)) == .right)
    #expect(dict.conflict(with: ("A", 1)) == .pair)
    #expect(dict.conflict(with: ("A", 3)) == .both(otherLeft: "C", otherRight: 1))
}

@Test func buildWithNoConflicts() {
    let pairs = [("A", 1), ("B", 2), ("C", 3), ("D", 4)]
    let actual = BijectiveDictionary.build(from: pairs)
    let expected = BijectiveDictionaryBuildResults.success(["A": 1, "B": 2, "C": 3, "D": 4])
    #expect(actual == expected)
}

@Test(arguments: [
    ([("A", 1), ("B", 2), ("C", 3), ("A", 4)], BijectiveDictionaryBuildResults.conflicts(
        ["A": 1, "B": 2, "C": 3],
        conflicts: [("A", 4)]
    )),
    ([("A", 1), ("A", 2), ("C", 3), ("D", 3)], BijectiveDictionaryBuildResults.conflicts(
        ["A": 1, "C": 3],
        conflicts: [("A", 2), ("D", 3)]
    ))
])
func buildWithConflicts(pairs: [(String, Int)], expected: BijectiveDictionaryBuildResults<String, Int>) {
    let pairs = pairs
    let actual = BijectiveDictionary.build(from: pairs)
    #expect(actual == expected)
}
#endif
