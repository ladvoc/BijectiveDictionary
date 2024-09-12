# Using a BijectiveDictionary
Learn how to mutate and maintain a BijectiveDictionary.

## Reserving Capacity
Just like a `Dictionary`, if a ``BijectiveDictionary`` overflows its capacity, then it must internally allocate for more memory. While this process is automatic, it is not free. If we know the required capacity ahead of time, then we can allocate it in advance, thus eliminating unnecessary work. This can be done during initialization. 

```swift
let bDict = BijectiveDictionary<String, Int>(minimumCapacity: 10_000)
```

Or it can also be done during the lifetime of the dictionary. 

```swift
print(bDict.capacity) // 10_000
bDict.reserveCapacity(200_000)
print(bDict.capacity) // 200_000
```
## Reading a Value
```swift
let bDict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
bDict[left: "B"] // 2
bDict[right: 3] // "C"
```

## Order
># `BijectiveDictionary` does not preserve or guarantee ordering. 
>Do not forget that just like `Dictionary`, a `BijectiveDictionary` is unordered. The order of key-value pairs is stable between mutations but is otherwise unpredictable. For more info, see the docs for [Dictionary](https://github.com/swiftlang/swift/blob/28c6cc105da2e917416002df3e0accfc2ad2d23f/stdlib/public/core/Dictionary.swift#L316).

For the purposes of these docs, we will preserve the order, just to make it easier to reason about. But in practice, in actual code, the order of elements in a `BijectiveDictionary` will not be predictable.

## Mutation
Insertion and updates are done through the subscripts. The syntax is just like mutating a `Dictionary`. However, unlike a `Dictionary` both the "key" and the "value" can be used as a key. This is the reason why we instead use the words "left" and "right". We must also add these words to our subscript when we call them. In other words we must use `bDict[left: "B"]` rather than `bDict["B"]`. 

### Insertion
Just like a `Dictionary`, if the given "key" is not found, then the new key-value pair will be inserted.

```swift
var bDict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
bDict[left: "D"] = 4 
bDict[right: 5] = "E"
print(bDict) // ["A": 1, "B": 2, "C": 3, "D": 4, "E": 5]
```

Swift will also check for types. 
```swift
var bDict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
bDict[left: 4] = "D" // this is a compiler error
```

### Updates
Also just like a `Dictionary`, if the given "key" already exists, then the subscript will keep the "key" as-is, and will mutate the corresponding "value". 

```swift
var bDict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3]
bDict[left: "A"] = 12
bDict[right: 2] = "Z"
print(bDict) // ["A": 12, "Z": 2, "C": 3]
```


### Removal
Removal can be performed by using ``BijectiveDictionary/remove(byLeft:)`` and ``BijectiveDictionary/remove(byRight:)`` respectively. 

```swift
var bDict = ["A": 1, "B": 2, "C": 3, "D": 4, "E": 5]
bDict.remove(byLeft: "D")
print(bDict) // ["A": 1, "B": 2, "C": 3, "E": 5]
bDict.remove(byRight: 5)
print(bDict) // ["A": 1, "B": 2, "C": 3]
```


