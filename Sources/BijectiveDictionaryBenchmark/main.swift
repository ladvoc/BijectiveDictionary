import BijectiveDictionary
import CollectionsBenchmark

var benchmark = Benchmark(title: "BijectiveDictionary Benchmark")

// MARK: Input Generators
benchmark.registerInputGenerator(
    for: [(left: Int, right: Int)].self
) { size in
    return (0..<size).map { index in
        return (left: index, right: index)
    }
}

benchmark.registerInputGenerator(
    for: [Int: Int].self
) { size in
    let keys = Set(0..<size)
    let values = keys
    let pairs = zip(keys, values)
    return Dictionary(uniqueKeysWithValues: pairs)
}

benchmark.registerInputGenerator(
    for: (Int, [Int]).self
) { size in
    let int = size
    let arrayOfInt = Array(0..<size)
    return (int, arrayOfInt)
}

// MARK: Benchmarks
// MARK: Initializers
benchmark.addSimple(
    title: "BijectiveDictionary<Int, Int> init minimum capacity",
    input: Int.self
) { input in
    blackHole(BijectiveDictionary<Int, Int>(minimumCapacity: input))
}

benchmark.addSimple(
    title: "BijectiveDictionary<Int, Int> init from Dictionary value",
    input: [Int: Int].self
) { input in
    blackHole(BijectiveDictionary<Int, Int>(input))
}

benchmark.add(
    title: "BijectiveDictionary<Int, Int> init unique left-right pairs",
    input: Int.self
) { input in
    let leftValues = Array(0..<input) // positive values
    let rightValues = Array(-input..<0) // negative values
    let pairs = zip(leftValues, rightValues)
    return { timer in
        blackHole(BijectiveDictionary<Int, Int>(uniqueLeftRightPairs: pairs))
    }
}

// MARK: Iteration
benchmark.add(
    title: "BijectiveDictionary<Int, Int> sequential iteration",
    input: [(left: Int, right: Int)].self
) { input in
    let bDict = BijectiveDictionary<Int, Int>(uniqueLeftRightPairs: input)
    return { timer in
        for element in bDict {
            blackHole(element)
        }
    }
}

// MARK: Insertion
benchmark.addSimple(
    title: "BijectiveDictionary<Int, Int> insertion into left",
    input: [(left: Int, right: Int)].self
) { input in
    let insertedByLeftIntoBijectiveDictionary = {
        var bDict = BijectiveDictionary<Int, Int>(minimumCapacity: input.underestimatedCount)
        for element in input {
            bDict[left: element.left] = element.right
        }
        return bDict
    }
    blackHole(insertedByLeftIntoBijectiveDictionary())
}

benchmark.addSimple(
    title: "BijectiveDictionary<Int, Int> insertion into right",
    input: [(left: Int, right: Int)].self
) { input in
    let insertedByRightIntoBijectiveDictionary = {
        var bDict = BijectiveDictionary<Int, Int>(minimumCapacity: input.underestimatedCount)
        for element in input {
            bDict[right: element.right] = element.left
        }
        return bDict
    }
    blackHole(insertedByRightIntoBijectiveDictionary())
}

benchmark.addSimple(
    title: "Dictionary<Int, Int> insertion",
    input: [(left: Int, right: Int)].self
) { input in
    let insertedIntoDictionary = {
        var dict = Dictionary<Int, Int>(minimumCapacity: input.underestimatedCount)
        for element in input {
            dict[element.left] = element.right
        }
        return dict
    }
    blackHole(insertedIntoDictionary())
}

// MARK: Removal

        }
    }
}

}

benchmark.main()
