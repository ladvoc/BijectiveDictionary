//
//  File.swift
//  BijectiveDictionary
//
//  Created by Daniel Lyons on 2024-09-16.
//

extension POCOrderedSetImplementation: ExpressibleByDictionaryLiteral {
    /// Creates a new BijectiveDictionary from a dictionary literal.
    ///
    /// >Warning: Both left and right values must be unique or else this will fatal error.
    public init(dictionaryLiteral elements: (Left, Right)...) {
        self.init(minimumCapacity: elements.count)
        
        for (leftKey, rightKey) in elements {
            let (leftInserted, atLeftIndex) = _ltr.append(leftKey)
            let (rightInserted, atRightIndex) = _rtl.append(rightKey)
            
            guard leftInserted == true,
                  rightInserted == true,
                  atLeftIndex == atRightIndex else {
                fatalError("dictionary literal contains duplicate value")
            }
        }
    }
}
