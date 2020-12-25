func expand(rules: [Int: String], rule: String, depth: Int = 4) -> String {
    guard rule != "42 | 42 8" else { return "(\(expand(rules: rules, rule: "42", depth: depth))+)" }
    guard rule != "42 31 | 42 11 31" else {
        let rule42 = expand(rules: rules, rule: "42"), rule31 = expand(rules: rules, rule: "31", depth: depth)
        var string = "(\(rule42))(\(rule31))"
        for _ in 0..<depth {
            string = "(\(rule42))(\(string))?(\(rule31))"
        }
        return string
    }
    if rule.contains("\"") {
        return rule.components(separatedBy: "\"").joined()
    } else if Int(rule) != nil {
        return expand(rules: rules, rule: rules[Int(rule)!, default: ""], depth: depth)
    } else if rule.contains("|") {
        return "(\(rule.components(separatedBy: " | ").map { expand(rules: rules, rule: $0, depth: depth) }.joined(separator: "|")))"
    } else {
        return rule.components(separatedBy: .whitespaces).map { expand(rules: rules, rule: $0, depth: depth) }.joined()
    }
}

func solver(map: [Int: String], message: String, recursiveDepth: Int = 1, searchMode: Bool = true) -> Int {
    var prevCount = -1
    for depth in 0..<recursiveDepth {
        var execDepth = !searchMode ? recursiveDepth : depth, count = 0
        let rule = "^\(expand(rules: map, rule: map[0, default: ""], depth: execDepth))$"
        for mes in message.components(separatedBy: .newlines) where matches(for: rule, in: mes).isEmpty == false {
            count += 1
        }
        if !searchMode || count == prevCount {
            if searchMode { print(depth) }
            else { prevCount = count }
            break
        } else {
            prevCount = count
        }
    }
    return prevCount
}

func solve() {
    let input = day19input
    let parsedInput = input.components(separatedBy: "\n\n")

    var map = [Int: String]()
    for rule in parsedInput[0].components(separatedBy: .newlines) {
        let parsed = rule.components(separatedBy: ": ")
        let key = Int(parsed[0])!
        let value = parsed[1]
        map[key] = value
    }

    print("Part 1")
    print(solver(map: map, message: parsedInput[1]))
    map[8] = "42 | 42 8"
    map[11] = "42 31 | 42 11 31"
    print("Part 2")
    print(solver(map: map, message: parsedInput[1], recursiveDepth: 4, searchMode: false))
}

solve()
