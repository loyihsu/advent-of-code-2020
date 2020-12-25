func solver(input: [String]) -> (Int, String) {
    var map = [String: [String]](), counter = [String: Int](), checker = [String: String](), sum = 0
    for listitem in input {
        let parsed = listitem.components(separatedBy: " (contains ")
        let listValues = parsed.first!.components(separatedBy: " ")
        listValues.forEach { counter[$0, default: 0] += 1 }
        let allergenList = parsed.last![parsed.last!.startIndex..<parsed.last!.index(before: parsed.last!.endIndex)]
        let parsedAllergenList = allergenList.components(separatedBy: ", ")
        for item in parsedAllergenList {
            if let preexist = map[item] {
                map[item] = listValues.filter { preexist.contains($0) }
            } else {
                map[item, default: []].append(contentsOf: listValues)
            }
        }
    }

    while let kid = map.firstIndex(where: { $0.value.count == 1 }) {
        let temp = map[kid].value.first!
        checker[map[kid].key] = temp
        for key in map.keys {
            map[key, default: []] = map[key, default: []].filter { $0 != temp }
        }
    }

    let allergenList = checker.sorted(by: { $0.key < $1.key }).map { $0.value }
    for (key, value) in counter where !allergenList.contains(key) {
        sum += value
    }
    return (sum, allergenList.joined(separator: ","))
}

func solve() {
    let input = day21input
    let parsedInput = input.components(separatedBy: .newlines)
    print("Part 1")
    let res = solver(input: parsedInput)
    print(res.0)
    print("Part 2")
    print(res.1)
}

solve()
