func solver(input: [String]) -> Int {
    var key = Int(input[1])!, door = Int(input[0])!, loop = 0, temp = 1
    while temp != door {
        temp = (temp * 7) % 20201227
        loop += 1
    }
    temp = 1
    for _ in 0..<loop {
        temp = (temp * key) % 20201227
    }
    return temp
}
func solve() {
    let input = day25input
    let parsedInput = input.components(separatedBy: .newlines)
    print(solver(input: parsedInput))
}

solve()
