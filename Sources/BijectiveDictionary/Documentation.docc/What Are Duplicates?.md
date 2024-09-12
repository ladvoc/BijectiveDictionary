# What Are Duplicates?
Learn what `BijectiveDictionary` means when referring to duplicates.

## Duplicates
Throughout the documentation we will use the term `duplicate`. This term has a slightly different meaning in `BijectiveDictionary` than it means in other collections such as `Dictionary`. 

### Duplicates in `Dictionary`
A `Dictionary` cannot have duplicate keys, but it can have duplicate values. Therefore when you create a `Dictionary` using the initializer `Dictionary.init(uniqueKeysWithValues:)`, you must provide unique keys. In other words the keys can have no duplicates. But it is okay for the values to have duplicates. Providing duplicate keys will result in a runtime error. 

For this reason, `Dictionary` also comes with another initializer (`Dictionary.init(_:uniquingKeysWith:)`). This initializer will not result in a runtime error. In order to achieve this, you must provide it a closure which will be called any time that duplicate keys are encountered. This will instruct the initializer how to resolve the duplicate. 

### Duplicates in `BijectiveDictionary`
`BijectiveDictionary` aims to mimic `Dictionary`'s API as closely as possible, only making changes when necessary. Unlike `Dictionary`, a `BijectiveDictionary` requires both the left and the right values to be unique. But let's be a little more specific on what that means. 

1. Within the left values, there can be no duplicates. 
2. Within the right values, there can be no duplicates. 
3. However, it is okay if the same value exists on both the right and left side. This is not considered a duplicate. 
