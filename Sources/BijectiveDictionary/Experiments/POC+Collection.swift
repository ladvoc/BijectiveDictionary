//
//  File.swift
//  BijectiveDictionary
//
//  Created by Daniel Lyons on 2024-09-16.
//

import OrderedCollections

// TODO: Conform to Collection
extension POCOrderedSetImplementation {
    @inlinable public var isEmpty: Bool {
        assert(_ltr.isEmpty == _rtl.isEmpty)
        return _ltr.isEmpty
    }
    
    @inlinable public var count: Int {
        assert(_ltr.count == _rtl.count)
        return _ltr.count
    }
}
