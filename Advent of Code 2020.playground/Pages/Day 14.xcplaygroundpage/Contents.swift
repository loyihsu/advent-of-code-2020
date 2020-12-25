func generateBinary(_ number: Int) -> String {
    var output = [Character](repeating: "0", count: 36)
    var num = number, pos = 35
    while num > 0 {
        output[pos] = Character("\(num % 2)")
        pos -= 1
        num /= 2
    }
    return String(output)
}

func generateInt(_ binary: String) -> Int {
    var output = 0
    for char in binary {
        output = output * 2 + (char == "1" ? 1 : 0)
    }
    return output
}

func generateFilteredBinary(from command: Int, through mask: String) -> Int {
    var binary = Array(generateBinary(command))
    let maskArray = Array(mask)
    for idx in binary.indices where maskArray[idx] != "X" {
        binary[idx] = maskArray[idx]
    }
    return generateInt(String(binary))
}

func generateVer2FilteredBinary(from command: Int, through mask: String) -> [Int] {
    var binary = [Array(generateBinary(command))]
    let maskArray = Array(mask)
    for idx in maskArray.indices {
        if maskArray[idx] == "1" {
            for jdx in binary.indices {
                binary[jdx][idx] = "1"
            }
        } else if maskArray[idx] == "X" {
            var newArray = [[Character]]()
            for item in binary {
                var temp = item
                temp[idx] = "0"
                newArray.append(temp)
                temp[idx] = "1"
                newArray.append(temp)
            }
            binary = newArray
        }
    }
    return binary.map { generateInt(String($0)) }
}

func solver1(input: [String]) -> Int {
    var mask = "", map = [Int: Int]()
    for command in input {
        let parsedCommand = command.components(separatedBy: " = ")
        if command.contains("mask") {
            mask = parsedCommand.last!
        } else {
            let memoryCommand = parsedCommand.first!
            let memoryLocation = Int(memoryCommand[memoryCommand.index(after: memoryCommand.firstIndex(of: "[")!)..<memoryCommand.firstIndex(of: "]")!])!
            let writeCommand = generateFilteredBinary(from: Int(parsedCommand.last!)!, through: mask)
            map[memoryLocation] = writeCommand
        }
    }
    return map.values.reduce(0, +)
}

func solver2(input: [String]) -> Int {
    var mask = "", map = [Int: Int]()
    for command in input {
        let parsedCommand = command.components(separatedBy: " = ")
        if command.contains("mask") {
            mask = parsedCommand.last!
        } else {
            let memoryCommand = parsedCommand.first!
            let memoryLocation = Int(memoryCommand[memoryCommand.index(after: memoryCommand.firstIndex(of: "[")!)..<memoryCommand.firstIndex(of: "]")!])!
            generateVer2FilteredBinary(from: memoryLocation, through: mask).forEach {
                map[$0] = Int(parsedCommand.last!)!
            }
        }
    }
    return map.values.reduce(0, +)
}

func solve() {
    let input = day14input
    let parsedInput = input.components(separatedBy: .newlines)
    print("Part 1")
    print(solver1(input: parsedInput))
    print("Part 2")
    print(solver2(input: parsedInput))
}

solve()
