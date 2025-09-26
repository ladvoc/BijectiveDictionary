//  =============================================================
//  File: BijectiveDictionary.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

/// A collection whose elements are left-right pairs.
///
/// A bijective dictionary is a specialized dictionary that offers efficient bidirectional access
/// in O(1) time, making it ideal for scenarios where the performance of reverse lookups is a
/// key consideration. However, this comes at the cost of increased memory usage.
///
/// Bijective dictionary closely mirrors the standard dictionary type from the standard library,
/// sharing many of the same initializers, methods, and properties. The key distinction lies in its
/// ability to access elements bidirectionally. In a bijective dictionary, keys and values are referred
/// to as “left values” and “right values” respectively, to avoid confusion, since either can be used
/// to access the other.
///
/// The following example demonstrates creating a bijective dictionary from a dictionary literal
/// that maps IANA time zones to their corresponding UTC offsets (not considering daylight savings time):
/// ```swift
/// var timeZones: BijectiveDictionary = [
///     "America/Los_Angeles": -8,
///     "Europe/London": 0
///     "Europe/Kiev": 2,
///     "Asia/Singapore": 8
/// ]
/// ```
///
/// With the dictionary constructed, an entry in `timeZones` can be accessed either by its left
/// value (time zone) or right value (UTC offset):
/// ```swift
/// print(timeZones[left: "America/Los_Angeles"]) // prints -8
/// print(timeZones[right: 2]) // prints "Europe/Kiev"
/// ```
///
/// The same subscripts can also be used to set values when the dictionary is mutable:
/// ```swift
/// timeZones[left: "Asia/Seoul"] = 9
/// timeZones[right: -9] = "America/Anchorage"
/// ```
///
public struct BijectiveDictionary<Left: Hashable, Right: Hashable> {

    /// Internal dictionary mapping left values to right values.
    @usableFromInline internal var _ltr: [Left: Right]

    /// Internal dictionary mapping right values to left values.
    @usableFromInline internal var _rtl: [Right: Left]

    /// The total number of left-right pairs that the dictionary can contain without
    /// allocating new storage.
    @inlinable public var capacity: Int {
        return Swift.min(_ltr.capacity, _rtl.capacity)
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
        get { self[left: leftValue] ?? defaultValue() }
        set(right) { self[left: leftValue] = right }
    }

    /// Accesses the left value associated with the given right value, falling back to the
    /// given default left value if the right value isn't found.
    ///
    /// - Complexity: O(1).
    @inlinable public subscript(
        right rightValue: Right,
        default defaultValue: @autoclosure () -> Left
    ) -> Left {
        get { self[right: rightValue] ?? defaultValue() }
        set(left) { self[right: rightValue] = left }
    }

    /// Accesses the right value associated with the given left value for reading and writing.
    ///
    /// - Complexity: O(1).
    @inlinable public subscript(left leftValue: Left) -> Right? {
        get {
            _ltr[leftValue]
        }
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
    }

    /// Accesses the left value associated with the given right value for reading and writing.
    ///
    /// - Complexity: O(1).
    @inlinable public subscript(right rightValue: Right) -> Left? {
        get {
            _rtl[rightValue]
        }
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
    }
    
    /// Find a left-right pair in the dictionary by left value.
    @inlinable public func findPairByLeft(_ leftValue: Left) -> Element? {
        guard let rightValue = self[left: leftValue] else { return nil }
        return (leftValue, rightValue)
    }
    
    /// Find a left-right pair in the dictionary by right value.
    @inlinable public func findPairByRight(_ rightValue: Right) -> Element? {
        guard let leftValue = self[right: rightValue] else { return nil }
        return (leftValue, rightValue)
    }
}

extension BijectiveDictionary: Encodable where Left: Encodable, Right: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(_ltr)
    }
}

extension BijectiveDictionary: Decodable where Left: Decodable, Right: Decodable {
    
    /// Decodes a bijective dictionary from a standard dictionary
    ///
    /// Initialization is delegated to ``init(_:)``. Therefore you should expect identical performance.
    /// - Complexity: O(*n*), where *n* is the number of key-value pairs in the
    ///   given dictionary.
    ///
    /// - Parameter decoder: the decoder used to decode the standard dictionary
    /// - Throws: `DecodingError.dataCorruptedError` if the given dictionary does not have unique values.
    /// `DecodingError.typeMismatch` if the encountered stored value is not a single value container.
    /// `DecodingError.valueNotFound` if the encountered encoded value is null.`
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawKeyedDictionary = try container.decode([Left: Right].self)
        
        guard let dict = Self(rawKeyedDictionary) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "The decoded dictionary must have unique keys and unique values."
            )
        }
        self = dict
    }
}
