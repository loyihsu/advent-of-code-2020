func solver1(at arrival: Int, _ possibilities: [Int]) -> Int {
    var min = Int.max, bid = 0
    for possibility in possibilities {
        let temp = possibility * ((arrival / possibility) + 1)
        if temp < min {
            min = temp
            bid = possibility
        }
    }
    return (min - arrival) * bid
}

/// Chinese Remainder Theorem
func solver2(_ possibilities: [String]) -> Int {
    var earliestTime = 0, runningProduct = 1
    for (idx, val) in possibilities.enumerated() where val != "x" {
        let value = Int(val)!
        while (earliestTime + idx) % value != 0 {
            earliestTime += runningProduct
        }
        runningProduct *= value
    }
    return earliestTime
}

func solve() {
    let rawinput = day13input
    var parsedInput = rawinput.components(separatedBy: .newlines)
    let arrivalTime = Int(parsedInput.removeFirst())!
    let listOfPossibility = parsedInput.last!.components(separatedBy: ",").filter { $0 != "x" }.map { Int($0)! }
    let allPossibilities = parsedInput.last!.components(separatedBy: ",")
    print("Part 1")
    print(solver1(at: arrivalTime, listOfPossibility))
    print("Part 2")
    print(solver2(allPossibilities))
}

solve()
