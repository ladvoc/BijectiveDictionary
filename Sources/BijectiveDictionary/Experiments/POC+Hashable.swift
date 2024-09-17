extension POCOrderedSetImplementation: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_ltr)
    }
    
    public static func == (lhs: POCOrderedSetImplementation, rhs: POCOrderedSetImplementation) -> Bool {
        lhs._ltr == rhs._ltr
    }
}
