# Creating a BijectiveDictionary

Learn the many different ways to initialize a `BijectiveDictionary`.

## Creating an Empty `BijectiveDictionary`
An empty dictionary can be created using ``BijectiveDictionary/init()``
Because `BijectiveDictionary` is generic, you will also need to somewhere declare your `Left` and `Right` value types. 

```swift
let bDict = BijectiveDictionary<String, Int>()
```

Or an empty `BijectiveDictionary` can also be created with a literal. However, this will require that you explicitly declare the type (unless it can be inferred elsewhere). 

```swift
let bDict: BijectiveDictionary<String, Int> = [:]
```

### Reserving Capacity
An empty dictionary can also be created with a minimum capacity using ``BijectiveDictionary/init(minimumCapacity:)``. Remember that, (just like a standard `Dictionary`) when a `BijectiveDictionary` exceeds it's capacity, it must reallocate its storage buffer under the hood. This reallocation is automatic and you do not need to remember to do it, but it is not free. It is good to avoid this work, if you know in advance that you will have a large number of items. 

```swift
let bDict = BijectiveDictionary<String, Int>(minimumCapacity: 10_000)
```

## Initialize with Values
### Create a `BijectiveDictionary` from a Literal
See: ``BijectiveDictionary/init(dictionaryLiteral:)``

``BijectiveDictionary`` conforms to `ExpressibleByDictionaryLiteral` and therefore can be initialized with common `Dictionary` syntax. (Note, this creates a `BijectiveDictionary` directly, and does not create any `Dictionary`.) In practice, this is one of the easiest ways to create a `BijectiveDictionary`.  

># Warning
>The dictionary literal used here must not contain any duplicates in the left or right values or else this initializer will fatal error. 
```swift
let bDict: BijectiveDictionary<String, Int> = ["A": 1, "B": 2, "C": 3]
```


### Initialize with a Sequence of Tuples
See ``BijectiveDictionary/init(uniqueLeftRightPairs:)``
```swift
let values = [
    ("A", 1),
    ("B", 2),
    ("C", 3),
]
let bDict = BijectiveDictionary(uniqueLeftRightPairs: values)
```

## Conversion
### Convert a `Dictionary` to a `BijectiveDictionary`
See ``BijectiveDictionary/init(_:)``

```swift
let dict = ["A": 1, "B": 2, "C": 3]
guard let bDict = BijectiveDictionary(dict) else {
    print("Right values are non-unique.")
}
print("bDict is now unwrapped.")
```

### Convert a `BijectiveDictionary` to a `Dictionary`
```swift
let bDict: BijectiveDictionary = ["A": 1, "B": 2, "C": 3] 
let dict = Dictionary(bDict) 
```

### Codable
`BijectiveDictionary` also conforms to `Codable` and therefore can be easily converted back and forth from `JSON`, `Data`, `XML` and any other serialization scheme that supports `Codable`. The `Codable` implementation for `BijectiveDictionary` is designed to perfectly mimic `Dictionary`'s `Codable` implementation. In other words, you should expect that and encoded representation of a `Dictionary` should produce an equivalent `BijectiveDictionary` and vice versa. 
