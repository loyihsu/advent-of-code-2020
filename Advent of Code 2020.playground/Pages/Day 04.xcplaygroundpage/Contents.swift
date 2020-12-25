let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
let nRequiredFields = ["cid"]

func filter(str: String) -> Bool {
    var flag = true
    for field in requiredFields where !str.contains(field) {
        flag = false
    }
    return flag
}

func seperator(_ input: String) -> [String] {
    var temp = "", output = [String]()
    for char in input {
        if char == " " || char == "\n" {
            output.append(temp)
            temp = ""
        } else {
            temp.append(char)
        }
    }
    if temp.isEmpty == false {
        output.append(temp)
    }
    return output
}

func part1Solver(form: [String]) -> Int {
    var count = 0
    for entry in form {
        if filter(str: entry) {
            count += 1
        }
    }
    return count
}

func part2Solver(input: [String]) -> Int {
    var count = 0
    for dat in input {
        var valid = true
        for entry in seperator(dat) {
            let e = entry.components(separatedBy: ":").last!
            if entry.contains("byr") {
                if Int(e)! > 2002 || Int(e)! < 1920 {
                    valid = false
                    break
                }
            } else if entry.contains("iyr") {
                if Int(e)! < 2010 || Int(e)! > 2020 {
                    valid = false
                    break
                }
            } else if entry.contains("eyr") {
                if Int(e)! < 2020 || Int(e)! > 2030 {
                    valid = false
                    break
                }
            } else if entry.contains("hgt") {
                let num = Int(e[...e.index(e.endIndex, offsetBy: -3)])!
                let cmViol = e.contains("cm") && (num > 193 || num < 150)
                let inViol = e.contains("in") && (num > 76 || num < 59)
                let noUnit = !e.contains("cm") && !e.contains("in")
                if cmViol || inViol || noUnit {
                    valid = false
                    break
                }
            } else if entry.contains("hcl") {
                if e.first! == "#" {
                    let filtered = e[e.index(after: e.startIndex)...].filter { "0123456789abcdef".contains($0) }
                    if filtered.count != 6 {
                        valid = false
                        break
                    }
                } else {
                    valid = false
                    break
                }
            } else if entry.contains("ecl") {
                if !"amb blu brn gry grn hzl oth".components(separatedBy: " ").contains(e) {
                    valid = false
                    break
                }
            } else if entry.contains("pid") {
                let filtered = e.filter { "0123456789".contains($0) }
                if filtered.count != 9 {
                    valid = false
                    break
                }
            }
        }
        if valid {
            count += 1
        }
    }

    return count
}

func solve() {
    let parsedInput = day4input.components(separatedBy: "\n\n")
    let filteredInput = parsedInput.filter { filter(str: $0) }
    print("Part 1")
    print(part1Solver(form: parsedInput))
    print("Part 2")
    print(part2Solver(input: filteredInput))
}

solve()
