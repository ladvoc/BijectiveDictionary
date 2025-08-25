//  =============================================================
//  File: BijectiveDictionary+Descriptions.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { _ltr.description }
    public var debugDescription: String { _ltr.debugDescription }
}

extension BijectiveDictionary: CustomReflectable {
    public var customMirror: Mirror {
        Mirror(self, unlabeledChildren: _ltr, displayStyle: .dictionary)
    }
}
