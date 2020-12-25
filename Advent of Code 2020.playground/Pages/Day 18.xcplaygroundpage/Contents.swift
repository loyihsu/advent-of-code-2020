func evaluator1(_ operators: String, _ operands: [String]) -> String {
    var rators = operators, rands = operands
    while !rators.isEmpty {
        let rator = rators.removeFirst()
        let rand1 = Int(rands.removeFirst())!
        let rand2 = Int(rands.removeFirst())!
        rands.insert(rator == "+" ? "\(rand1 + rand2)" : "\(rand1 * rand2)", at: 0)
    }
    return rands.last!
}

func evaluator2(_ operators: String, _ operands: [String]) -> String {
    var temperands = [String](), flag = false, rators = operators, rands = operands
    while let rator = rators.popLast() {
        if rator == "+" {
            let left = Int(rands.popLast()!)!
            var right = 0
            if flag == false {
                right = Int(rands.popLast()!)!
                flag = true
            }  else {
                right = Int(temperands.popLast()!)!
            }
            temperands.append("\(left + right)")
        } else {
            temperands.append(rands.popLast()!)
        }
    }
    if !rands.isEmpty {
        temperands.append(contentsOf: rands)
    }
    return "\(temperands.map { Int($0)! }.reduce(1, *))"
}

func clearBuffer(_ buffer: inout String, _ operands: inout [String]) {
    if buffer.isEmpty == false {
        operands.append(buffer)
        buffer = ""
    }
}

func solver(input: [String], mode: Int = 0) -> Int {
    var results = 0
    for line in input {
        var buffer = "", operands = [String](), operators = ""
        for char in line {
            if "+*(".contains(char) {
                operators.append(char)
            } else if char == ")" {
                clearBuffer(&buffer, &operands)
                var rators = "", rands = [String](), count = 2
                while let rator = operators.popLast() {
                    if rator == "(" { break }
                    rators.insert(rator, at: rators.startIndex)
                    for _ in 0..<count {
                        rands.insert(operands.popLast()!, at: 0)
                    }
                    count = 1
                }
                operands.append(mode == 0 ? evaluator1(rators, rands) : evaluator2(rators, rands))
            } else if char == " " {
                clearBuffer(&buffer, &operands)
            } else if char != " " {
                buffer.append(char)
            }
        }
        clearBuffer(&buffer, &operands)
        results += Int(mode == 0 ? evaluator1(operators, operands) : evaluator2(operators, operands))!
    }
    return results
}

func solve() {
    let input = day18input
    let lines = input.components(separatedBy: .newlines)
    print("Part 1")
    print(solver(input: lines))
    print("Part 2")
    print(solver(input: lines, mode: 1))
}

solve()
