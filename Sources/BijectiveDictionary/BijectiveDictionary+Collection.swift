//  =============================================================
//  File: BijectiveDictionary+Collection.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary: Collection {
    
    /// The position of a left-right pair in a bijective dictionary.
    @frozen public struct Index: Comparable {
        @usableFromInline
        internal let _ltrIndex: DictionaryIndex<Left, Right>
        
        @inlinable
        init(_ ltrIndex: DictionaryIndex<Left, Right>) {
            self._ltrIndex = ltrIndex
        }
        
        @inlinable
        public static func < (lhs: Index, rhs: Index) -> Bool {
            lhs._ltrIndex < rhs._ltrIndex
        }
    }
    
    @inlinable public var startIndex: Index { Index(_ltr.startIndex) }
    @inlinable public var endIndex: Index { Index(_ltr.endIndex) }
    
    @inlinable
    public subscript(position: Index) -> Element {
        let element = _ltr[position._ltrIndex]
        return (left: element.key, right: element.value)
    }
    
    // swiftlint:disable:next identifier_name
    @inlinable public func index(after i: Index) -> Index {
        Index(_ltr.index(after: i._ltrIndex))
    }
    
    /// A Boolean value that indicates whether the dictionary is empty.
    @inlinable public var isEmpty: Bool {
        assert(_ltr.isEmpty == _rtl.isEmpty)
        return _ltr.isEmpty
    }
    
    /// The number of left-right pairs in the dictionary.
    ///
    /// - Complexity: O(1).
    @inlinable public var count: Int {
        assert(_ltr.count == _rtl.count)
        return _ltr.count
    }
}

extension BijectiveDictionary.Index: Sendable
where Left: Sendable, Right: Sendable {}
