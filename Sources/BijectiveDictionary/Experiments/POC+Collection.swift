//
//  File.swift
//  BijectiveDictionary
//
//  Created by Daniel Lyons on 2024-09-16.
//

import OrderedCollections

extension POCOrderedSetImplementation: Collection {
    public typealias Index = Int
    public var startIndex: Int { 0 }
    public var endIndex: Int {
        assert(_ltr.count == _rtl.count)
        return _ltr.count
    }
    
    public func index(after index: Int) -> Int {
        _ltr.index(after: index)
    }
    
    public subscript(position: Int) -> (left: Left, right: Right) {
        let leftValue = _ltr[position]
        let rightValue = _rtl[position]
        return (left: leftValue, right: rightValue)
    }
    
    @inlinable public var isEmpty: Bool {
        assert(_ltr.isEmpty == _rtl.isEmpty)
        return _ltr.isEmpty
    }
    
    @inlinable public var count: Int {
        assert(_ltr.count == _rtl.count)
        return _ltr.count
    }
}
