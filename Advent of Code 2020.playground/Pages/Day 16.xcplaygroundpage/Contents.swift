var valid = [String: [(Int, [Int])]]()

func applyRules(_ rules: [[(Int,Int)]], _ item: Int) -> (Bool, [Int]) {
    var output = false, pos = [Int]()
    for (idx, rulearr) in rules.enumerated() where applyRule(rulearr, item) {
        output = true
        pos.append(idx)
    }
    return (output, pos)
}

func applyRule(_ rules: [(Int, Int)], _ item: Int) -> Bool {
    var flag = false
    for rule in rules where rule.0 <= item && item <= rule.1 {
        flag = true
        break
    }
    return flag
}

func solver1(parts: [String]) -> Int {
    var output = 0, rules = [[(Int,Int)]]()
    for line in parts[0].components(separatedBy: .newlines) {
        let parsed = line.components(separatedBy: ": ").last!
        var temp = [(Int,Int)]()
        for field in parsed.components(separatedBy: " or ") {
            let range = field.components(separatedBy: "-")
            temp.append((Int(range[0])!, Int(range[1])!))
        }
        rules.append(temp)
    }
    let part2 = parts[1].components(separatedBy: .newlines)[1]
    let parsedPart2 = part2.components(separatedBy: ",").map { Int($0)! }
    for idx in parsedPart2.indices {
        let res = applyRules(rules, parsedPart2[idx])
        if !res.0 {
            output += parsedPart2[idx]
        } else {
            valid[part2, default: []].append((idx, res.1))
        }
    }
    var part3 = parts[2].components(separatedBy: .newlines)
    part3.removeFirst()
    for line in part3 {
        let parsedLine = line.components(separatedBy: ",").map { Int($0)! }
        for idx in parsedLine.indices {
            let res = applyRules(rules, parsedLine[idx])
            if !res.0 {
                output += parsedLine[idx]
            } else {
                valid[line, default: []].append((idx, res.1))
            }
        }
    }
    return output
}

func solver2(parts: [String]) -> Int {
    let values = valid.values, count = values.first!.count,
        allFieldsCount = parts[0].components(separatedBy: .newlines).count
    var possibilities = [[Int]](repeating: Array(0..<allFieldsCount), count: count),
        res = [Int](repeating: -1, count: count), result = 1
    for value in values {
        for item in value {
            possibilities[item.0] = possibilities[item.0].filter { item.1.contains($0) }
        }
    }
    while possibilities.filter({ $0.count == 1 }).count > 0 {
        var remover = [Int]()
        for idx in possibilities.indices {
            if possibilities[idx].count == 1 {
                let temp = possibilities[idx].popLast()!
                res[idx] = temp
                remover.append(temp)
            }
        }
        for idx in possibilities.indices {
            possibilities[idx] = possibilities[idx].filter { !remover.contains($0) }
        }
    }
    let poses = (0..<6).map { res.firstIndex(of: $0)! },
        part2 = parts[1].components(separatedBy: .newlines).last!.components(separatedBy: ",").map { Int($0)! }
    for pos in poses {
        result *= part2[pos]
    }
    return result
}

func solve() {
    let input = day16input
    let parts = input.components(separatedBy: "\n\n")
    print("Part 1")
    print(solver1(parts: parts))
    print("Part 2")
    let res2 = solver2(parts: parts)
    print(res2)
}

solve()
