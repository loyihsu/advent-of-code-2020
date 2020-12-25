func solver1(input: [Int]) -> Int {
    var chart = [0, 0, 0, 0]
    chart[input[0]] += 1
    for idx in 1..<input.count {
        chart[input[idx] - input[idx-1]] += 1
    }
    chart[3] += 1
    return chart[1] * chart[3]
}

func solver2(input: [Int]) -> Int {
    var saved = [Int](repeating: 0, count: input.count)
    saved[0] = 1
    for idx in 1..<input.count {
        var sum = 0
        for jdx in 1...4 where idx - jdx >= 0 {
            if input[idx] - input[idx - jdx] <= 3 {
                sum += saved[idx - jdx]
            }
            saved[idx] = sum
        }
    }
    return saved.last!
}

func solve() {
    let rawInput = day10input
    let processedInput = rawInput.components(separatedBy: .newlines).map { Int($0)! }.sorted()
    print("Part 1")
    print(solver1(input: processedInput))
    print("Part 2")
    var arr = [0]
    arr.append(contentsOf: processedInput)
    arr.append(arr.last!+3)
    print(solver2(input: arr))
}

solve()
