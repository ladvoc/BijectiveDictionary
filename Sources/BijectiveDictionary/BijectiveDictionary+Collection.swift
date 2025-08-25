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
    
    /// Find the index of a specific element.
    @inlinable public func index(of element: Element) -> Index? {
        guard let idx = _ltr.index(forKey: element.left),
              element.right == _ltr[idx].value else {
            return nil
        }
        return Index(idx)
    }
    
    /// Find the index of a specific element using only the left value.
    @inlinable public func index(forLeft leftValue: Left) -> Index? {
        guard let idx = _ltr.index(forKey: leftValue) else {
            return nil
        }
        return Index(idx)
    }
    
    /// Find the index of a specific element using only the right value.
    @inlinable public func index(forRight rightValue: Right) -> Index? {
        guard let leftValue = self[right: rightValue] else {
            return nil
        }
        return Index(_ltr.index(forKey: leftValue)!)
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
