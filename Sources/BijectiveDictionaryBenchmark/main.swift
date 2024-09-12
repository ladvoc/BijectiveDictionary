import BijectiveDictionary
import CollectionsBenchmark

var benchmark = Benchmark(title: "BijectiveDictionary Benchmark")


extension Sequence where Element == (left: String, right: Int) {
    func insertedByLeftIntoBijectiveDictionary() -> BijectiveDictionary<String, Int> {
        var bDict = BijectiveDictionary<String, Int>(minimumCapacity: underestimatedCount)
        for element in self {
            bDict[left: element.left] = element.right
        }
        return bDict
    }
    
    func insertedByRightIntoBijectiveDictionary() -> BijectiveDictionary<String, Int> {
        var bDict = BijectiveDictionary<String, Int>(minimumCapacity: underestimatedCount)
        for element in self {
            bDict[right: element.right] = element.left
        }
        return bDict
    }
    
    func insertedIntoDictionary() -> Dictionary<String, Int> {
        var dict = Dictionary<String, Int>(minimumCapacity: underestimatedCount)
        for element in self {
            dict[element.left] = element.right
        }
        return dict
    }
}



benchmark.registerInputGenerator(
    for: [(left: String, right: Int)].self) { size in
        return (0..<size).map { index in
            return (left: "String\(index)", right: index)
        }
    }

benchmark.addSimple(
    title: "BijectiveDictionary<String, Int> insertion into left",
    input: [(left: String, right: Int)].self
) { input in
    blackHole(input.insertedByLeftIntoBijectiveDictionary())
}

benchmark.addSimple(
    title: "BijectiveDictionary<String, Int> insertion into right",
    input: [(left: String, right: Int)].self
) { input in
    blackHole(input.insertedByRightIntoBijectiveDictionary())
}

benchmark.addSimple(
    title: "Dictionary<String, Int> insertion",
    input: [(left: String, right: Int)].self
) { input in
    blackHole(input.insertedIntoDictionary())
}

benchmark.main()
