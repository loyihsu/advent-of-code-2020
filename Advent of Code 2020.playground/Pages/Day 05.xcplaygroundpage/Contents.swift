func generateID(from input: String) -> Int {
    var row = (0, 127), col = (0, 7), pos = (-1, -1)
    for idx in input.indices {
        if idx == input.index(before: input.endIndex) {
            pos.1 = input[idx] == "R" ? col.1 : col.0
        } else if idx > input.index(input.startIndex, offsetBy: input.count - 4) {
            col = input[idx] == "R" ? ((col.0+col.1+1)/2, col.1) : (col.0, (col.0+col.1)/2)
        } else if idx == input.index(input.startIndex, offsetBy: input.count - 4) {
            pos.0 = input[idx] == "F" ? row.0 : row.1
        } else {
            row = input[idx] == "F" ? (row.0, (row.0+row.1)/2) : ((row.0+row.1+1)/2, row.1)
        }
    }
    return pos.0 * 8 + pos.1
}

func solver1(input: [String]) -> Int {
    var max = Int.min
    input.forEach {
        let temp = generateID(from: $0)
        max = temp > max ? temp : max
    }
    return max
}

func solver2(input: [String], max: Int) -> Int? {
    var list = [Bool](repeating: false, count: max+1)
    input.forEach { list[generateID(from: $0)] = true }
    var prev = -1
    for idx in list.indices where list[idx] == false {
        if idx - prev > 1 {
            return idx
        } else {
            prev = idx
        }
    }
    return nil
}

func solve() {
    let rawinput = day5input
    let parsedInput = rawinput.components(separatedBy: .newlines)
    print("Part 1")
    let max = solver1(input: parsedInput)
    print(max)
    print("Part 2")
    if let res = solver2(input: parsedInput, max: max) {
        print(res)
    }
}

solve()
