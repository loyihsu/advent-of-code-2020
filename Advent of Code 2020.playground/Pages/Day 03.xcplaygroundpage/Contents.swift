func solver(movements: [(Int, Int)], map: [String]) -> Int {
    var res = 1
    for movement in movements {
        var startPos = (0, 0)
        var tree = 0
        while startPos.1 < map.count {
            let line = map[startPos.1]
            let pos = line.index(line.startIndex, offsetBy: startPos.0)
            if line[pos] == "#" {
                tree += 1
            }
            startPos.0 += movement.0
            startPos.1 += movement.1
            while startPos.0 >= line.count {
                startPos.0 -= line.count
            }
        }
        res *= tree
    }
    return res
}

func solve() {
    let rawInput = day3input
    let parsedInput = rawInput.components(separatedBy: .newlines)
    print("Part 1")
    print(solver(movements: [(3,1)], map: parsedInput))
    print("Part 2")
    print(solver(movements: [(1,1), (3,1), (5,1), (7,1), (1,2)], map: parsedInput))
}

solve()
