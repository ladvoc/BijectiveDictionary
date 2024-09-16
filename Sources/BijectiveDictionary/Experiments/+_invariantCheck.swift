
extension POCOrderedSetImplementation {
#if DEBUG
    @usableFromInline @inline(never)
    internal func _invariantCheck() {
        print("👷🏼‍♀️ WIP: _invariantCheck is kept for consistency, but I'm not sure it's necessary, yet")
    }
#else
    @inlinable @inline(__always)
    internal func _invariantCheck() {}
#endif
}
