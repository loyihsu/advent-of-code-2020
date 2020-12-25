let allDirs = [(0, -1), (0, 1), (-1, 0), (1, 0), (-1, 1), (1, 1), (-1, -1), (1, -1)]

func solver1(input: [String]) -> [String] {
    var posy = 0, output = input

    while posy < input.count {
        var posx = input[posy].startIndex, temp = Array(output[posy]), tosx = 0
        while posx < input[posy].endIndex {
            if input[posy][posx] == "L" {
                var signal = false
                let lowery = posy - 1 >= 0 ? posy - 1 : 0
                let highery = posy + 1 < input.count ? posy + 1 : input.count - 1
                let lowerx = posx != input[posy].startIndex ? input[posy].index(before: posx) : input[posy].startIndex
                let higherx = input[posy].index(after: posx) != input[posy].endIndex ? input[posy].index(after: posx) : input[posy].index(before: input[posy].endIndex)
                for scany in lowery...highery {
                    var scanx = lowerx
                    while scanx <= higherx {
                        if !(scanx == posx && scany == posy) && input[scany][scanx] == "#" {
                            signal = true
                            break
                        }
                        scanx = input[posy].index(after: scanx)
                    }
                    if signal { break }
                }

                if !signal {
                    temp[tosx] = "#"
                }
            } else if input[posy][posx] == "#" {
                var count = 0
                let lowery = posy - 1 >= 0 ? posy - 1 : 0
                let highery = posy + 1 < input.count ? posy + 1 : input.count - 1
                let lowerx = posx != input[posy].startIndex ? input[posy].index(before: posx) : input[posy].startIndex
                let higherx = input[posy].index(after: posx) != input[posy].endIndex ? input[posy].index(after: posx) : input[posy].index(before: input[posy].endIndex)
                for scany in lowery...highery {
                    var scanx = lowerx
                    while scanx <= higherx {
                        if !(scanx == posx && scany == posy) && input[scany][scanx] == "#" {
                            count += 1
                        }
                        scanx = input[posy].index(after: scanx)
                    }
                }
                if count >= 4 {
                    temp[tosx] = "L"
                }
            }
            posx = input[posy].index(after: posx)
            tosx += 1
        }
        output[posy] = String(temp)
        posy += 1
    }
    return output
}

func findFirstNonEmpty(input: [String], startPos: (Int, String.Index), directionSet: (Int, Int)) -> Character? {
    var posy = startPos.0, posx = startPos.1
    if (posy == 0 && directionSet.0 == -1) || (posy == input.count - 1 && directionSet.0 == 1) {
        return nil
    } else {
        posy += directionSet.0
    }
    if (posx == input[posy].startIndex && directionSet.1 == -1) || (posx == input[posy].index(before: input[posy].endIndex) && directionSet.1 == 1) {
        return nil
    } else {
        posx = input[posy].index(posx, offsetBy: directionSet.1)
    }
    while posy >= 0 && posy < input.count && posx >= input[posy].startIndex && posx < input[posy].endIndex {
        if input[posy][posx] != "." {
            return input[posy][posx]
        }
        if posy + directionSet.0 < 0 || posy + directionSet.0 == input.count {
            break
        } else {
            posy += directionSet.0
        }
        if posx == input[posy].startIndex && directionSet.1 == -1 {
            break
        } else {
            posx = input[posy].index(posx, offsetBy: directionSet.1)
        }
    }
    return nil
}

func solver2(input: [String]) -> [String]  {
    var output = input, posy = 0
    while posy < input.count {
        var posx = input[posy].startIndex
        var temp = Array(output[posy])
        var tosx = 0
        while posx < input[posy].endIndex {
            if input[posy][posx] == "L" {
                var signal = false
                for dir in allDirs {
                    if let res = findFirstNonEmpty(input: input, startPos: (posy, posx), directionSet: dir) {
                        if res == "#" {
                            signal = true
                            break
                        }
                    }
                }
                if !signal {
                    temp[tosx] = "#"
                }
            } else if input[posy][posx] == "#" {
                var count = 0
                allDirs.forEach {
                    if let res = findFirstNonEmpty(input: input, startPos: (posy, posx), directionSet: $0) {
                        if res == "#" {
                            count += 1
                        }
                    }
                }
                if count >= 5 {
                    temp[tosx] = "L"
                }
            }
            posx = input[posy].index(after: posx)
            tosx += 1
        }
        output[posy] = String(temp)
        posy += 1
    }

    return output
}

func execution(input: [String], _ solvingFunction: ([String]) -> [String]) -> Int {
    var flag = true, solution = solvingFunction(input)
    while flag {
        let temp = solvingFunction(solution)
        if temp == solution {
            flag = false
        } else {
            solution = temp
        }
    }

    var output = 0
    for line in solution {
        for char in line where char == "#" {
            output += 1
        }
    }
    return output
}

func solve() {
    let rawinput = day11input
    let parsedInput = rawinput.components(separatedBy: .newlines)
    print("Part 1")
    print(execution(input: parsedInput, solver1))
    print("Part 2")
    print(execution(input: parsedInput, solver2))
}

solve()
