//  =============================================================
//  File: BijectiveDictionary+LeftValues.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary {
    
    /// A view of a bijective dictionary's left values.
    @frozen
    public struct LeftValues {
        
        @usableFromInline
        internal let _ltr: Dictionary<Left, Right>
        
        @inlinable
        internal init(_ ltr: Dictionary<Left, Right>) {
            self._ltr = ltr
        }
    }
    
    /// A collection containing just the left values of the dictionary.
    ///
    /// When iterated over, left values appear in this collection in the same order as they occur in the
    /// dictionary’s left-right pairs. Each left value is unique.
    ///
    /// ```swift
    /// let countryCodes: BijectiveDictionary = ["TW": "Taiwan", "AR": "Argentina"]
    /// print(countryCodes)
    /// // Prints "["AR": "Argentina", "TW": "Taiwan"]"
    ///
    /// for left in countryCodes.leftValues {
    ///     print(left)
    /// }
    /// // Prints "AR"
    /// // Prints "TW"
    /// ```
    ///
    /// - Complexity: O(1)
    ///
    @inlinable
    public var leftValues: LeftValues {
        LeftValues(_ltr)
    }
}

// MARK: - Sequence

extension BijectiveDictionary.LeftValues: Sequence {
    
    /// The type that allows iteration over the elements of the left values view
    /// of a persistent dictionary.
    @frozen
    public struct Iterator: IteratorProtocol {
        
        @usableFromInline
        internal var keysIterator: Dictionary<Left, Right>.Keys.Iterator
        
        @inlinable
        internal init(keysIterator: Dictionary<Left, Right>.Keys.Iterator) {
            self.keysIterator = keysIterator
        }
        
        @inlinable
        public mutating func next() -> Left? {
            keysIterator.next()
        }
    }
    
    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(keysIterator: _ltr.keys.makeIterator())
    }
}

// MARK: - Collection
extension BijectiveDictionary.LeftValues: Collection {
  public typealias Index = Dictionary<Left, Right>.Index
  public typealias Element = Left
  
  public var startIndex: Dictionary<Left, Right>.Index {
    return _ltr.keys.startIndex
  }
  
  public var endIndex: Dictionary<Left, Right>.Index {
    return _ltr.keys.endIndex
  }
  
  public func index(after i: Dictionary<Left, Right>.Index) -> Dictionary<Left, Right>.Index {
    return _ltr.keys.index(after: i)
  }
  
  public subscript(index: Dictionary<Left, Right>.Index) -> Left {
    get { return _ltr.keys[index] }
  }
}

// MARK: - Other Conformances

extension BijectiveDictionary.LeftValues: CustomStringConvertible {
    public var description: String { _ltr.keys.description }
}

extension BijectiveDictionary.LeftValues: CustomDebugStringConvertible {
    public var debugDescription: String { _ltr.keys.debugDescription }
}

extension BijectiveDictionary.LeftValues: Sendable
where Left: Sendable, Right: Sendable {}

extension BijectiveDictionary.LeftValues.Iterator: Sendable
where Left: Sendable, Right: Sendable {}
