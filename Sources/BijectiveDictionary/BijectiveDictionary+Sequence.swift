//  =============================================================
//  File: BijectiveDictionary+Sequence.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary: Sequence {

    /// A tuple containing an individual left-right pair.
    public typealias Element = (left: Left, right: Right)
    
    @frozen public struct Iterator {
        @usableFromInline
        internal var _ltrIterator: Dictionary<Left, Right>.Iterator
        
        @usableFromInline
        internal init(ltrIterator: Dictionary<Left, Right>.Iterator) {
            self._ltrIterator = ltrIterator
        }
    }
    
    @inlinable public func makeIterator() -> Iterator {
        Iterator(ltrIterator: _ltr.makeIterator())
    }
}

extension BijectiveDictionary.Iterator: IteratorProtocol {
    
    @inlinable public mutating func next() -> BijectiveDictionary.Element? {
        let element: (Left, Right)? = _ltrIterator.next()
        return element
    }
}
