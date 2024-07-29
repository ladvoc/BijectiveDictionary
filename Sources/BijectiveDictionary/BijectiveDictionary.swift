//  =============================================================
//  File: BijectiveDictionary.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

/// A collection whose elements are left-right pairs.
///
/// A bijective dictionary is like a standard dictionary but offers bidirectional O(1) access
/// at the cost of increased memory usage—useful when time efficiency of reverse lookups
/// is a key consideration.
///
/// A bijective dictionary's keys are values are referred to as "left values" and "right values"
/// respectively to avoid confusion since either can be used to access the other.
public struct BijectiveDictionary<Left: Hashable, Right: Hashable> {
    
    /// Internal dictionary mapping left values to right values.
    @usableFromInline internal var _ltr: [Left: Right]
    
    /// Internal dictionary mapping right values to left values.
    @usableFromInline internal var _rtl: [Right: Left]
    
    /// The total number of key-value pairs that the dictionary can contain without
    /// allocating new storage.
    @inlinable public var capacity: Int {
        assert(_ltr.capacity == _rtl.capacity)
        return _ltr.capacity
    }
    
    /// Reserves enough space to store the specified number of left-right pairs.
    ///
    /// If you are adding a known number of left-right pairs to a dictionary, use this
    /// method to avoid multiple reallocations. This method ensures that the
    /// dictionary has unique, mutable, contiguous storage, with space allocated
    /// for at least the requested number of left-right pairs.
    ///
    /// - Parameter minimumCapacity: The requested number of left-right pairs to store.
    @inlinable public mutating func reserveCapacity(_ minimumCapacity: Int) {
        _ltr.reserveCapacity(minimumCapacity)
        _rtl.reserveCapacity(minimumCapacity)
    }
    
    /// Removes the given right value and its associated left value from the dictionary.
    ///
    /// - Parameter rightValue: The right value to remove along with its associated left value.
    /// - Returns: The left value that was removed, or `nil` if the right value was not
    ///   present in the dictionary.
    ///
    /// - Complexity: O(*n*), where *n* is the number of left-right pairs in the
    ///   dictionary.
    @discardableResult
    @inlinable public mutating func remove(byRight rightValue: Right) -> Left? {
        defer { _invariantCheck() }
        guard let leftValue = _rtl.removeValue(forKey: rightValue) else { return nil }
        _ltr.removeValue(forKey: leftValue)
        return leftValue
    }
    
    /// Removes the given left value and its associated right value from the dictionary.
    ///
    /// - Parameter leftValue: The left value to remove along with its associated right value.
    /// - Returns: The right value that was removed, or `nil` if the left value was not
    ///   present in the dictionary.
    ///
    /// - Complexity: O(*n*), where *n* is the number of left-right pairs in the
    ///   dictionary.
    @discardableResult
    @inlinable public mutating func remove(byLeft leftValue: Left) -> Right? {
        defer { _invariantCheck() }
        guard let rightValue = _ltr.removeValue(forKey: leftValue) else { return nil }
        _rtl.removeValue(forKey: rightValue)
        return rightValue
    }
    
    // TODO: add other useful methods from `Dictionary`.
    
    /// Removes all left-right pairs from the dictionary.
    ///
    /// Calling this method invalidates all indices with respect to the
    /// dictionary.
    ///
    /// - Parameter keepCapacity: Whether the dictionary should keep its
    ///   underlying buffer. If you pass `true`, the operation preserves the
    ///   buffer capacity that the collection has, otherwise the underlying
    ///   buffer is released.  The default is `false`.
    ///
    /// - Complexity: O(*n*), where *n* is the number of left-right pairs in the
    ///   dictionary.
    @inlinable public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        defer { _invariantCheck() }
        _ltr.removeAll(keepingCapacity: keepCapacity)
        _rtl.removeAll(keepingCapacity: keepCapacity)
    }
    
    /// Accesses the right value associated with the given left value, falling back to the
    /// given default right value if the left value isn't found.
    ///
    /// - Complexity: O(1).
    @inlinable public subscript(
        left leftValue: Left,
        default defaultValue: @autoclosure () -> Right
    ) -> Right {
        set(right) { self[left: leftValue] = right }
        get { self[left: leftValue] ?? defaultValue() }
    }
    
    /// Accesses the left value associated with the given right value, falling back to the
    /// given default left value if the right value isn't found.
    ///
    /// - Complexity: O(1).
    @inlinable public subscript(
        right rightValue: Right,
        default defaultValue: @autoclosure () -> Left
    ) -> Left {
        set(left) { self[right: rightValue] = left }
        get { self[right: rightValue] ?? defaultValue() }
    }
    
    /// Accesses the right value associated with the given left value for reading and writing.
    ///
    /// - Complexity: O(1).
    @inlinable public subscript(left leftValue: Left) -> Right? {
        set(rightValue) {
            defer { _invariantCheck() }
            
            guard let rightValue else {
                // Right value being set to `nil`.
                guard let existing = _ltr[leftValue] else { return }
                _rtl[existing] = nil
                _ltr[leftValue] = nil
                return
            }
            
            if let replacedLeft = _rtl.updateValue(leftValue, forKey: rightValue),
                replacedLeft != leftValue {
                _ltr[replacedLeft] = nil
            }
            if let replacedRight = _ltr.updateValue(rightValue, forKey: leftValue),
                replacedRight != rightValue {
                _rtl[replacedRight] = nil
            }
        }
        get {
            _ltr[leftValue]
        }
    }
    
    /// Accesses the left value associated with the given right value for reading and writing.
    ///
    /// - Complexity: O(1).
    @inlinable public subscript(right rightValue: Right) -> Left? {
        set(leftValue) {
            defer { _invariantCheck() }
            
            guard let leftValue else {
                // Left value being set to `nil`.
                guard let existing = _rtl[rightValue] else { return }
                _ltr[existing] = nil
                _rtl[rightValue] = nil
                return
            }
            
            if let replacedLeft = _rtl.updateValue(leftValue, forKey: rightValue),
                replacedLeft != leftValue {
                _ltr[replacedLeft] = nil
            }
            if let replacedRight = _ltr.updateValue(rightValue, forKey: leftValue),
                replacedRight != rightValue {
                _rtl[replacedRight] = nil
            }
        }
        get {
            _rtl[rightValue]
        }
    }
}
