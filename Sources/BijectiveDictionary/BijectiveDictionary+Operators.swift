//  =============================================================
//  File: BijectiveDictionary+Operators.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary {
    
    static func == (lhs: Self, rhs: [Left: Right]) -> Bool {
        lhs._ltr == rhs
    }
    static func == (lhs: [Left: Right], rhs: Self) -> Bool {
        lhs == rhs._ltr
    }
}
