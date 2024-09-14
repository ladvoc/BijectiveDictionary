//  =============================================================
//  File: BijectiveDictionary+Initializers.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary {
    
    /// Creates an empty dictionary.
    @inlinable public init() {
        self._ltr = Dictionary()
        self._rtl = Dictionary()
    }
    
    /// Creates an empty dictionary with preallocated space for at least the
    /// specified number of elements.
    ///
    /// Use this initializer to avoid intermediate reallocations of a dictionary's
    /// storage buffer when you know how many left-right pairs you are adding to a
    /// dictionary after creation.
    ///
    /// - Parameter minimumCapacity: The minimum number of left-right pairs that
    ///   the newly created dictionary should be able to store without
    ///   reallocating its storage buffer.
    @inlinable public init(minimumCapacity: Int) {
        self._ltr = Dictionary(minimumCapacity: minimumCapacity)
        self._rtl = Dictionary(minimumCapacity: minimumCapacity)
    }
    
    /// Creates a new dictionary from the left-right pairs in the given sequence.
    ///
    /// You use this initializer to create a dictionary when you have a sequence
    /// of left-right tuples with unique values on each side. Passing a sequence with duplicate
    /// values on either side to this initializer results in a runtime error. If your sequence might have duplicate
    /// left or right values, use the `BijectiveDictionary(_:uniquingWith:)` initializer instead.
    ///
    /// - Precondition: The sequence must not have duplicate left or right values.
    @inlinable public init<S>(uniqueLeftRightPairs pairs: S) where S: Sequence, S.Element == (Left, Right) {
        defer { _invariantCheck() }
        self._ltr = Dictionary(uniqueKeysWithValues: pairs)
        let reversePairs = pairs.lazy.map { pair in (pair.1, pair.0) }
        self._rtl = Dictionary(uniqueKeysWithValues: reversePairs)
    }
    
    /// Creates a bijective dictionary from a standard dictionary.
    ///
    /// Unlike a standard dictionary which only requires its keys be unique, a bijective
    /// must have both its left and right values be unique. Therefore, if the given dictionary
    /// does not have unique values, the result of this initializer is `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the number of key-value pairs in the
    ///   given dictionary.
    @inlinable public init?(_ dictionary: [Left: Right]) {
        self._ltr = dictionary
        self._rtl = Dictionary()
        _rtl.reserveCapacity(dictionary.count)
        
        for (leftValue, rightValue) in _ltr {
            guard _rtl.updateValue(leftValue, forKey: rightValue) == nil else {
                // Right values are non-unique.
                return nil
            }
        }
        _invariantCheck()
    }
}

extension Dictionary {
    
    /// Creates a standard dictionary from a bijective dictionary.
    ///
    /// - Complexity: O(1)
    @inlinable public init(_ bijectiveDictionary: BijectiveDictionary<Key, Value>) where Value: Hashable {
        self = bijectiveDictionary._ltr
    }
}
