extension POCOrderedSetImplementation {
    
    static func == (lhs: Self, rhs: [Left: Right]) -> Bool {
        lhs.asDictionary == rhs
    }
    static func == (lhs: [Left: Right], rhs: Self) -> Bool {
        lhs == rhs.asDictionary
    }
}
