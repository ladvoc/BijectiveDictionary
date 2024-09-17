public enum BijectiveDictionaryBuildResults<Left: Hashable, Right: Hashable> {
    
    case success(BijectiveDictionary<Left, Right>)
    case conflicts(BijectiveDictionary<Left, Right>, conflicts: [BijectiveDictionary<Left, Right>.Element])
}
extension BijectiveDictionaryBuildResults: Sendable where Left: Sendable, Right: Sendable {}

extension BijectiveDictionaryBuildResults: Equatable where Left: Equatable, Right: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lhsDict), .success(rhsDict)):
            return lhsDict == rhsDict
        case (.success, .conflicts):
            return false
        case (.conflicts, .success):
            return true
        case let (.conflicts(lhsDict, lhsConflicts), .conflicts(rhsDict, rhsConflicts)):
            return lhsDict == rhsDict &&
            lhsConflicts.map { $0.0 } == rhsConflicts.map { $0.0 } &&
            lhsConflicts.map { $0.1 } == rhsConflicts.map { $0.1 }
        }
    }
}

extension BijectiveDictionary {
    /// Builds a ``BijectiveDictionary`` from a collection of pairs
    /// - Parameter pairs: A `Collection` of left-right pairs
    /// - Returns: A `success` (with the dictionary) if there were no conflicts, or a `conflicts` (with the
    /// incomplete dictionary, and the remaining conflicts that you need to resolve). 
    @inlinable public static func build<C>(
        from pairs: C
    ) -> BijectiveDictionaryBuildResults<Left, Right> where C: Collection, C.Element == (Left, Right) {
        // check if there are duplicates
        // if there are conflicts: return `BijectiveDictionaryBuildResults.conflicts
        // if there are NO conflicts: return `BijectiveDictionaryBuildResults.success`
        
        let keys = pairs.map { $0.0 }
        let values = pairs.map { $0.1 }
        let hasConflicts: Bool = keys.hasDuplicates || values.hasDuplicates
        var insertedLeftValues: Set<Left> = []
        var insertedRightValues: Set<Right> = []
        if hasConflicts {
            var conflicts: [BijectiveDictionary<Left, Right>.Element] = []
            var dict = BijectiveDictionary<Left, Right>(minimumCapacity: pairs.count)
            for (leftValue, rightValue) in pairs {
                let alreadyInsertedLeftValue = insertedLeftValues.contains(leftValue) // O(1)
                let alreadyInsertedRightValue = insertedRightValues.contains(rightValue) // O(1)
                guard !alreadyInsertedLeftValue && !alreadyInsertedRightValue else {
// Left, Right, or both values have already been inserted
                    switch (alreadyInsertedLeftValue, alreadyInsertedRightValue) {
                    case (true, true):
                        conflicts.append((leftValue, rightValue))
                        continue
                    case (true, false):
                        conflicts.append((leftValue, rightValue))
                        continue
                    case (false, true):
                        conflicts.append((leftValue, rightValue))
                        continue
                    case (false, false):
                        preconditionFailure("This state should not be possible here.")
                        continue
                    }
                }
                
// Neither left nor right value has been inserted yet.
                dict[left: leftValue] = rightValue
                dict[right: rightValue] = leftValue
                insertedLeftValues.insert(leftValue)
                insertedRightValues.insert(rightValue)
            }
            return BijectiveDictionaryBuildResults.conflicts(dict, conflicts: conflicts)
        } else {
            // pairs has no conflicts
            var dict = BijectiveDictionary<Left, Right>(minimumCapacity: pairs.count)
            for (leftValue, rightValue) in pairs {
                dict._ltr.updateValue(rightValue, forKey: leftValue)
                dict._rtl.updateValue(leftValue, forKey: rightValue)
            }
            
            return BijectiveDictionaryBuildResults.success(dict)
        }
    }
}

extension Collection where Element: Hashable {
    public var hasDuplicates: Bool {
        let selfAsSet = Set(self)
        if self.count == selfAsSet.count {
            return false
        } else {
            return true
        }
    }
}
