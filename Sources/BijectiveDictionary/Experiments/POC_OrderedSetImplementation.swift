
import OrderedCollections

public struct POCOrderedSetImplementation<Left: Hashable, Right: Hashable> {
    /// An ordered set of left values
    @usableFromInline internal var _ltr: OrderedSet<Left>
    
    /// An ordered set of right values
    @usableFromInline internal var _rtl: OrderedSet<Right>
    
    func index(for leftValue: Left) -> Int? {
        _ltr.firstIndex(of: leftValue)
    }
    
    func index(for rightValue: Right) -> Int? {
        _rtl.firstIndex(of: rightValue)
    }
    
    @available(*, deprecated)
    @inlinable public var capacity: Int {
        print("OrderedSet does not have built in capacity variable")
        return 0
    }
    
    @inlinable public mutating func reserveCapacity(_ minimumCapacity: Int) {
        _ltr.reserveCapacity(minimumCapacity)
        _rtl.reserveCapacity(minimumCapacity)
    }
    
    @discardableResult
    @inlinable public mutating func remove(byRight rightValue: Right) -> Left? {
        defer { _invariantCheck() } // unnecessary?
        guard let rightIndex = _rtl.firstIndex(of: rightValue) else {
            return nil
        }
        _rtl.remove(at: rightIndex)
        let leftValue = _ltr[rightIndex]
        _ltr.remove(at: rightIndex)
        return leftValue
    }
    
    @discardableResult
    @inlinable public mutating func remove(byLeft leftValue: Left) -> Right? {
        defer { _invariantCheck() } // unnecessary?
        guard let leftIndex = _ltr.firstIndex(of: leftValue) else {
            return nil
        }
        _ltr.remove(at: leftIndex)
        let rightValue = _rtl[leftIndex]
        _rtl.remove(at: leftIndex)
        return rightValue
    }
    
    @inlinable public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        _ltr.removeAll(keepingCapacity: keepCapacity)
        _rtl.removeAll(keepingCapacity: keepCapacity)
    }
    
    @inlinable public subscript(
        left leftValue: Left,
        default defaultValue: @autoclosure () -> Right
    ) -> Right {
        get { self[left: leftValue] ?? defaultValue() }
        set(right) { self[left: leftValue] = right }
    }
    
    @inlinable public subscript(
        right rightValue: Right,
        default defaultValue: @autoclosure () -> Left
    ) -> Left {
        get { self[right: rightValue] ?? defaultValue() }
        set(left) { self[right: rightValue] = left }
    }
    
    @inlinable public subscript(left leftValue: Left) -> Right? {
        get {
            guard let leftIndex = _ltr.firstIndex(of: leftValue) else {
                return nil
            }
            return _rtl[safe: leftIndex]
        }
        set(newRightValue) {
            defer { _invariantCheck() } // unnecessary?
            guard let newRightValue else {
                // Right value being set to `nil`.
                
                // I'm not sure what to do here.
                // I don't think Left or Right is guaranteed to be an Optional here
                guard let index = _ltr.firstIndex(of: leftValue) else {
                    // setting right value to `nil`, by a non-existent left value
                    return // do nothing
                }
                // nil right value, real left value
                _ltr.remove(at: index) // remove both
                _rtl.remove(at: index)
                return
            }
            guard let index = _ltr.firstIndex(of: leftValue) else {
                // Inserting new left-right pair.
                let (leftInserted, atLeftIndex) = _ltr.append(leftValue)
                let (rightInserted, atRightIndex) = _rtl.append(newRightValue)
                
                guard leftInserted == true, rightInserted == true,
                      atLeftIndex == atRightIndex else {
                    fatalError("error occured while inserting right value: \(newRightValue) by left: \(leftValue) through subscript")
                }
                return
            }
            
            // Updating left-right pair (by left)...
//            // We've already guaranteed that the left value is present
//            // so it will update (not append)
//            _ltr.updateOrAppend(leftValue)
            _rtl.elements[index] = newRightValue // O(n)
        }
    }
    
    @inlinable public subscript(right rightValue: Right) -> Left? {
        get {
            guard let rightIndex = _rtl.firstIndex(of: rightValue) else {
                return nil
            }
            return _ltr[safe: rightIndex]
        }
        set(newLeftValue) {
            defer { _invariantCheck() }
            guard let newLeftValue else {
                // Left value being set to `nil`.
                
                // I'm not sure what to do here.
                // I don't think Left or Right is guaranteed to be an Optional here
                guard let index = _rtl.firstIndex(of: rightValue) else {
                    // setting left value to `nil`, by a non-existent right value
                    return // do nothing
                }
                // `nil` left value, real right value
                _ltr.remove(at: index)
                _rtl.remove(at: index)
                return
            }
            guard let index = _rtl.firstIndex(of: rightValue) else {
                // Inserting new left-right pair.
                let (leftInserted, atLeftIndex) = _ltr.append(newLeftValue)
                let (rightInserted, atRightIndex) = _rtl.append(rightValue)
                
                guard leftInserted == true, rightInserted == true,
                      atLeftIndex == atRightIndex else {
                    fatalError("error occured while inserting left value: \(newLeftValue) by right: \(rightValue) through subscript")
                }
                return
            }
            
            // Updating left-right pair (by right)...
            _ltr.elements[index] = newLeftValue
//            // We've already guaranteed that the right value is present
//            // so it will update (not append)
//            _rtl.updateOrAppend(rightValue)
            
        }
    }
    
    @inlinable public func indexByLeft(_ leftValue: Left) -> Int? {
        _ltr.firstIndex(of: leftValue)
    }
    
    @inlinable public func indexByRight(_ rightValue: Right) -> Int? {
        _rtl.firstIndex(of: rightValue)
    }
    
    @inlinable public func findPairByLeft(_ leftValue: Left) -> Element? {
        guard let rightValue = self[left: leftValue] else { return nil }
        return (left: leftValue, right: rightValue)
    }
    
    @inlinable public func findPairByRight(_ rightValue: Right) -> Element? {
        guard let leftValue = self[right: rightValue] else { return nil }
        return (left: leftValue, right: rightValue)
    }
}

// MARK: Sendable
extension POCOrderedSetImplementation: Sendable
where Left: Sendable, Right: Sendable {}

extension OrderedSet {
    @inlinable
    public subscript(safe index: Index) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }
        return self[index]
    }
    
    /// Replaces the old value (if it is present) with the new value
    ///
    /// Will do nothing if the old value is not present.
    /// Replaced
    @available(*, deprecated, message: "WIP: Unfinished")
    @discardableResult @inlinable
    public func replace(old oldValue: Element, withNew newValue: Element) -> (replaced: Bool, index: Int) {
        guard oldValue != newValue else {
            // New and old value are the same so let's do nothing.
            let index = self.firstIndex(of: oldValue)
            return (replaced: false, index: index ?? -1)
        }
        guard let index = self.firstIndex(of: oldValue) else {
            // self does not contain old value (old value is not present in self)
            return (replaced: false, index: -1)
        }
        
        // remove old value
        // append new value
        return (replaced: true, index: -1)
    }
}

