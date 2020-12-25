func solver(input: [Int], times: Int) -> Int {
    var map = [Int: Int](), processed = input, next = processed.popLast()!
    for (idx, val) in processed.enumerated() {
        map[val] = idx
    }
    var counter = input.count - 1
    while counter < times - 1 {
        if let idx = map[next] {
            map[next] = counter
            next = counter - idx
        } else {
            map[next] = counter
            next = 0
        }
        counter += 1
    }
    return next
}

func solve() {
    let input = day15input
    let parsedInput = input.components(separatedBy: ",").map { Int($0)! }
    print("Part 1")
    print(solver(input: parsedInput, times: 2020))
    print("Part 2")
    print(solver(input: parsedInput, times: 30_000_000))
}

solve()
