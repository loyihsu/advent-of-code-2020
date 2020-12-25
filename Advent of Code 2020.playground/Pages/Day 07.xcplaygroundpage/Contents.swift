struct InnerBag {
    var number: Int
    var color: String
}

func ruleParser(rules: [String]) -> [String: [InnerBag]] {
    var output = [String: [InnerBag]]()
    for rule in rules {
        let parsed = rule.components(separatedBy: " bags contain ")
        if parsed.last!.contains("no other bags") {
            output[parsed.first!] = [ ]
        } else {
            let lasts = parsed.last!.components(separatedBy: ", ")
            if lasts.isEmpty == false {
                for item in lasts {
                    var process = item.components(separatedBy: .whitespaces)
                    process.popLast()
                    let num = Int(process.removeFirst())!
                    output[parsed.first!, default: []].append(InnerBag.init(number: num, color: process.joined(separator: " ")))
                }
            } else {
                var process = parsed.last!.components(separatedBy: .whitespaces)
                process.popLast()
                let num = Int(process.removeFirst())!
                output[parsed.first!] = [InnerBag.init(number: num, color: process.joined(separator: " "))]
            }
        }
    }
    return output
}

func solver1(input: [String]) -> Int {
    let rules = ruleParser(rules: input)
    var real = "shiny gold", search = [real], realSearch: Set<String> = []
    var count = 0

    while let s = search.popLast() {
        realSearch.insert(s)
        for rule in rules {
            if rule.value.contains(where: {
                $0.color == s
            }) {
                search.append(rule.key)
            }
        }
    }

    let arr = Array(realSearch)

    for r in rules where r.key != real {
        for s in arr {
            if r.value.contains(where: {
                $0.color == s
            }) {
                count += 1
                break
            }
        }
    }
    return count
}

func search(rules: [String: [InnerBag]], for bag: String) -> Int {
    guard !rules[bag]!.isEmpty else { return 1 }
    var res = 1
    for item in rules[bag]! {
        res += item.number * search(rules: rules, for: item.color)
    }
    return res
}

func solver2(input: [String]) -> Int {
    let rules = ruleParser(rules: input)
    let res = search(rules: rules, for: "shiny gold")
    return res-1
}

func solve() {
    let parsedInput = day7input.components(separatedBy: ".\n")
    print("Part 1")
    print(solver1(input: parsedInput))
    print("Part 2")
    print(solver2(input: parsedInput))
}

solve()
