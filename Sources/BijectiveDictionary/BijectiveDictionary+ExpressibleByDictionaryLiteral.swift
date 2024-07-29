//  =============================================================
//  File: BijectiveDictionary+ExpressibleByDictionaryLiteral.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 07/29/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (Left, Right)...) {
        self.init()
        reserveCapacity(elements.count)
        
        for (leftKey, rightKey) in elements {
            guard _ltr.updateValue(rightKey, forKey: leftKey) == nil else {
                fatalError("Bijective dictionary literal contains duplicate left value")
            }
            guard _rtl.updateValue(leftKey, forKey: rightKey) == nil else {
                fatalError("Bijective dictionary literal contains duplicate right value")
            }
        }
    }
}
