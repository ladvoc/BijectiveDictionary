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
        internal let _ltr: Dictionary<Left, Right>
        
        @inlinable
        internal init(_ ltr: Dictionary<Left, Right>) {
            self._ltr = ltr
        }
    }
    
    /// A collection containing just the right values of the dictionary.
    ///
    /// When iterated over, right values appear in this collection in the same order as they occur in the
    /// dictionary’s left-right pairs. Each right value is unique.
    ///
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
        RightValues(_ltr)
    }
}

// MARK: - Sequence

extension BijectiveDictionary.RightValues: Sequence {
    
    /// The type that allows iteration over the elements of the right values view
    /// of a persistent dictionary.
    @frozen
    public struct Iterator: IteratorProtocol {
        
        @usableFromInline
        internal var valuesIterator: Dictionary<Left, Right>.Values.Iterator
        
        @inlinable
        internal init(valuesIterator: Dictionary<Left, Right>.Values.Iterator) {
            self.valuesIterator = valuesIterator
        }
        
        @inlinable
        public mutating func next() -> Right? {
            valuesIterator.next()
        }
    }
    
    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(valuesIterator: _ltr.values.makeIterator())
    }
}

// MARK: - Collection

// TODO: implement collection

// MARK: - Other Conformances

extension BijectiveDictionary.RightValues: CustomStringConvertible {
    public var description: String { _ltr.values.description }
}

extension BijectiveDictionary.RightValues: CustomDebugStringConvertible {
    public var debugDescription: String { _ltr.values.debugDescription }
}

extension BijectiveDictionary.RightValues: Sendable
where Left: Sendable, Right: Sendable {}

extension BijectiveDictionary.RightValues.Iterator: Sendable
where Left: Sendable, Right: Sendable {}
