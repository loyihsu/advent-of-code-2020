func solver(_ str: String, mode part2: Bool = false) -> Bool {
    let parse = str.components(separatedBy: ": ")
    let ruleParse = parse[0].components(separatedBy: .whitespaces), testcase = parse[1]
    let bounds = ruleParse[0], char = Character(ruleParse[1])
    let boundsParse = bounds.components(separatedBy: "-")
    if part2 {
        let before = Int(boundsParse.first!)! - 1, after = Int(boundsParse.last!)! - 1
        let chr1 = testcase[testcase.index(testcase.startIndex, offsetBy: before)],
            chr2 = testcase[testcase.index(testcase.startIndex, offsetBy: after)]
        return chr1 != chr2 && (chr1 == char || chr2 == char)
    } else {
        let lowerbound = Int(boundsParse[0])!, upperbound = Int(boundsParse[1])!
        let count = testcase.reduce(0) { $0 + ($1 == char ? 1 : 0) }
        return count >= lowerbound && count <= upperbound
    }
}


func solve() {
    let rawInput = day2input
    let parsedInput = rawInput.components(separatedBy: .newlines)
    print("Part 1")
    print(parsedInput.filter { solver($0) }.count)
    print("Part 2")
    print(parsedInput.filter { solver($0, mode: true) }.count)
}

solve()
