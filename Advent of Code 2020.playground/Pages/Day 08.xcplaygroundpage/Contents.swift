func through(from commands: String) -> (Bool, Int) {
    var accumulator = 0, parsedCommands = commands.components(separatedBy: .newlines)
    var pos = 0, visited = [Bool](repeating: false, count: parsedCommands.count), flag = false

    while true {
        if pos >= visited.count {
            break
        } else if visited[pos] == true || pos < 0 {
            flag = true
            break
        }
        visited[pos] = true
        let pcmd = parsedCommands[pos].components(separatedBy: .whitespaces)
        let cmd = pcmd[0], val = Int(pcmd[1])!
        if cmd == "acc" {
            accumulator += val
        }
        if cmd == "jmp" {
            pos += val
        } else {
            pos += 1
        }
    }
    return (flag, accumulator)
}

func solver1(input: String) -> Int {
    return through(from: input).1
}

func solver2(input: String) -> Int? {
    var temp = input.components(separatedBy: .newlines)
    for idx in temp.indices {
        let original = temp[idx]
        var tmp = temp[idx].components(separatedBy: " ")
        tmp[0] = temp[idx].contains("nop") ? "jmp" : "nop"
        temp[idx] = tmp.joined(separator: " ")
        let result = through(from: temp.joined(separator: "\n"))
        temp[idx] = original
        if result.0 == false {
            return result.1
        }
    }
    return nil
}

func solve() {
    let rawinput = day8input
    print("Part 1")
    print(solver1(input: rawinput))
    print("Part 2")
    print(solver2(input: rawinput) ?? "Not found.")
}

solve()
