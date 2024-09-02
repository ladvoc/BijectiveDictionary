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
    /// - Complexity: O(1)
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
extension BijectiveDictionary.RightValues: Collection {
  public typealias Index = Dictionary<Right, Left>.Index
  public typealias Element = Right
  
  public var startIndex: Dictionary<Right, Left>.Index {
    return _rtl.keys.startIndex
  }
  
  public var endIndex: Dictionary<Right, Left>.Index {
    return _rtl.keys.endIndex
  }
  
  public func index(after i: Dictionary<Right, Left>.Index) -> Dictionary<Right, Left>.Index {
    return _rtl.keys.index(after: i)
  }
  
  public subscript(index: Dictionary<Right, Left>.Index) -> Right {
    get { return _rtl.keys[index] }
  }
}

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
