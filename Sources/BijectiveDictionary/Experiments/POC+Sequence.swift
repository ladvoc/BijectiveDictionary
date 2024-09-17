//
//  POCOrderedSetImplementation
//
//  Created by Daniel Lyons on 2024-09-16.
//

import OrderedCollections

extension POCOrderedSetImplementation: Sequence {
    public func makeIterator() -> Iterator {
        Iterator(
            _ltr: _ltr,
            _rtl: _rtl,
            start: 0,
            end: _ltr.count - 1
        )
    }
    
    public typealias Element = (left: Left, right: Right)
    
    @frozen public struct Iterator: IteratorProtocol {
        public init(
            _ltr: OrderedSet<Left>,
            _rtl: OrderedSet<Right>,
            start: Int,
            end: Int
        ) {
            self._ltr = _ltr
            self._rtl = _rtl
            self.current = start
            self.end = end
        }
        
        let _ltr: OrderedSet<Left>
        let _rtl: OrderedSet<Right>
        var current: Int
        let end: Int
        
        public mutating func next() -> (left: Left, right: Right)? {
            defer { current += 1 }
            guard current < end else {
                return nil
            }
            let leftValue = _ltr[current]
            let rightValue = _rtl[current]
            return (left: leftValue, right: rightValue)
        }
    }
}
