//  =============================================================
//  File: BijectiveDictionary+Invariant.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary {
    #if DEBUG
        @usableFromInline @inline(never)
        internal func _invariantCheck() {
            assert(_ltr.count == _rtl.count, "Internal dictionaries should always have same count after update.")
        }
    #else
        @inlinable @inline(__always)
        internal func _invariantCheck() {}
    #endif
}
