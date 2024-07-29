//  =============================================================
//  File: BijectiveDictionary+Hashable.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_ltr)
    }
    
    public static func == (lhs: BijectiveDictionary, rhs: BijectiveDictionary) -> Bool {
        lhs._ltr == rhs._ltr
    }
}
