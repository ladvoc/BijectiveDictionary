//  =============================================================
//  File: BijectiveDictionary+RightValues.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary {
    
    /// A view of a bijective dictionary's right values.
    @frozen
    public struct RightValues {
        
        @usableFromInline
        internal let _rtl: Dictionary<Right, Left>
        
        @inlinable
        internal init(_ rtl: Dictionary<Right, Left>) {
            self._rtl = rtl
        }
    }
    
    /// A collection containing just the right values of the dictionary.
    ///
    /// When iterated over, order of the right values is not guaranteed. This may change
    /// in a future release.
    /// ```swift
    /// let countryCodes: BijectiveDictionary = ["TW": "Taiwan", "AR": "Argentina"]
    /// print(countryCodes)
    /// // Prints "["AR": "Argentina", "TW": "Taiwan"]"
    ///
    /// for right in countryCodes.rightValues {
    ///     print(right)
    /// }
    /// // Prints "Argentina"
    /// // Prints "Taiwan"
    /// ```
    ///
    /// - Complexity: O(1)
    ///
    @inlinable
    public var rightValues: RightValues {
        RightValues(_rtl)
    }
}

// MARK: - Sequence

extension BijectiveDictionary.RightValues: Sequence {
    
    /// The type that allows iteration over the elements of the right values view
    /// of a persistent dictionary.
    @frozen
    public struct Iterator: IteratorProtocol {
        
        @usableFromInline
        internal var keysIterator: Dictionary<Right, Left>.Keys.Iterator
        
        @inlinable
        internal init(keysIterator: Dictionary<Right, Left>.Keys.Iterator) {
            self.keysIterator = keysIterator
        }
        
        @inlinable
        public mutating func next() -> Right? {
            keysIterator.next()
        }
    }
    
    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(keysIterator: _rtl.keys.makeIterator())
    }
}

// MARK: - Collection

// TODO: implement collection

// MARK: - Other Conformances

extension BijectiveDictionary.RightValues: CustomStringConvertible {
    public var description: String { _rtl.keys.description }
}

extension BijectiveDictionary.RightValues: CustomDebugStringConvertible {
    public var debugDescription: String { _rtl.keys.debugDescription }
}

extension BijectiveDictionary.RightValues: Sendable
where Left: Sendable, Right: Sendable {}

extension BijectiveDictionary.RightValues.Iterator: Sendable
where Left: Sendable, Right: Sendable {}
