//
//  File.swift
//  BijectiveDictionary
//
//  Created by Daniel Lyons on 2024-09-16.
//

import OrderedCollections

extension POCOrderedSetImplementation {
    @inlinable public init() {
        self._ltr = OrderedSet()
        self._rtl = OrderedSet()
    }
    
    @inlinable public init(minimumCapacity: Int, persistent: Bool = false) {
        self._ltr = OrderedSet(minimumCapacity: minimumCapacity, persistent: persistent)
        self._rtl = OrderedSet(minimumCapacity: minimumCapacity, persistent: persistent)
    }
    
    @inlinable public init<S>(uniqueLeftRightPairs pairs: S) where S: Sequence, S.Element == (Left, Right) {
        defer { _invariantCheck() } // necessary?
        let leftValues = pairs.map(\.0)
        self._ltr = OrderedSet(leftValues)
        let rightValues = pairs.map(\.1)
        self._rtl = OrderedSet(rightValues)
    }
    
    /// Create an ordered `POCOrderedSetImplementation` from an unordered `Dictionary`
    @inlinable public init?(_ dictionary: [Left: Right]) {
        defer { _invariantCheck() } // necessary?
        
        let dictElements: [(Left, Right)] = dictionary.map { ($0.key, $0.value) }
        self._ltr = OrderedSet(dictElements.map(\.0))
        self._rtl = OrderedSet(dictElements.map(\.1))
        
        let leftValues = dictElements.map { $0 }
        let rightValues = dictElements.map { $1 }
        guard _ltr.count == leftValues.count,
              _rtl.count == rightValues.count else {
            // return `nil` if either set contains less elements
            // i.e. if there were any duplicates
            // ROOM FOR IMPROVEMENT: This approach doesn't check for duplicates until
            // after the work has already been done.
            return nil
        }
    }
}

extension Dictionary {
    @inlinable public init(_ poc: POCOrderedSetImplementation<Key, Value>) where Value: Hashable {
        self = poc.asDictionary
    }
}

extension POCOrderedSetImplementation {
    @inlinable public var asElementsArray: [Element] {
        return Array(zip(_ltr, _rtl))
    }
    
    @inlinable public var asDictionary: [Left: Right] {
        Dictionary.init(uniqueKeysWithValues: asElementsArray)
    }
}
