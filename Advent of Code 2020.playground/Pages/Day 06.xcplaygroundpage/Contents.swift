func convertToInt(char: Character) -> Int {
    let a = Character("a").unicodeScalars.first!.value
    return Int(char.unicodeScalars.first!.value - a)
}

func countYeses(in group: String) -> Int {
    var count = [Bool](repeating: false, count: 26)
    group.filter({ !" \n".contains($0) }).forEach { count[convertToInt(char: $0)] = true }
    return count.filter { $0 == true }.count
}

func countAllYeses(in group: String) -> Int {
    var count = [Bool](repeating: false, count: 26),temp = [Bool](repeating: false, count: 26), first = false
    for people in group.components(separatedBy: .newlines) {
        if first == false {
            people.forEach { count[convertToInt(char: $0)] = true }
            first = true
        } else {
            people.forEach { temp[convertToInt(char: $0)] = true }
            for idx in 0..<26 {
                count[idx] = count[idx] && temp[idx]
                temp[idx] = false
            }
        }
    }
    return count.filter { $0 == true }.count
}

func solver1(input: [String]) -> Int {
    return input.reduce(0, { $0 + countYeses(in: $1) })
}

func solver2(input: [String]) -> Int {
    return input.reduce(0, { $0 + countAllYeses(in: $1) })
}

func solve() {
    let rawInput = day6input
    let parsedInput = rawInput.components(separatedBy: "\n\n")
    print("Part 1")
    print(solver1(input: parsedInput))
    print("Part 2")
    print(solver2(input: parsedInput))
}

solve()
