//  =============================================================
//  File: BijectiveDictionary+Conflict.swift
//  Project: BijectiveDictionary
//  -------------------------------------------------------------
//  Created by Jacob Gelman on 09/11/2024
//  Copyright © 2024 Jacob Gelman. All rights reserved.
//  =============================================================

extension BijectiveDictionary {
    
    /// The result of a conflict check.
    @frozen
    public enum Conflict: Hashable {
        
        /// The left value is already present.
        case left
        
        /// The right value is already present.
        case right
        
        /// Both the left and right values are already present in the same pair.
        case pair
        
        /// Both the left and right values are already present across two different pairs.
        case both(otherLeft: Left, otherRight: Right)
    }
    
    /// Check if a conflict exists between the given pair and the contents of the dictionary that, if inserted,
    /// would override an existing pair or break the bijective property.
    ///
    /// - Parameter pair: The left-right pair to perform the conflict check against.
    /// - Returns: The conflict, if one exists, or `nil`, indicating neither the left nor right value already
    ///   exist in the dictionary.
    /// - Complexity: O(1)
    ///
    ///  The following example demonstrates creating a dictionary mapping element symbols
    ///  to their atomic numbers and checking to see if a conflict exists:
    ///  ```swift
    ///  let dict: BijectiveDictionary = ["Ti": 22, "Si": 14, "He": 2]
    ///
    ///  guard let conflict = dict.conflict(for: ("Ti", 2)) else {
    ///      print("No conflict")
    ///      return
    ///  }
    ///  switch conflict {
    ///  case .left:
    ///      print("Symbol already present")
    ///  case .right:
    ///      print("Atomic number already present")
    ///  case .pair:
    ///      print("Pair already exists")
    ///  case .both(let otherSymbol, let otherNumber):
    ///      print("Other symbol: \(otherSymbol), other number: \(otherNumber)")
    /// }
    /// // prints "Other symbol: He, other number: 22"
    /// ```
    @inlinable
    public func conflict(with pair: Element) -> Conflict? {
        let existing = (findPairByLeft(pair.left), findPairByRight(pair.right))
        return switch existing {
        case (nil, nil): nil
        case (nil, .some): .right
        case (.some, nil): .left
        case (.some(let byLeft), .some(let byRight)):
            if byLeft.left != byRight.left || byLeft.right != byRight.right {
                .both(otherLeft: byRight.left, otherRight: byLeft.right)
            } else {
                .pair
            }
        }
    }
}
