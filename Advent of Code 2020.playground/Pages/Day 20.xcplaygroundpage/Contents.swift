var matches = [Int: [String]](), nearby = [Int: [(Int, Bool)]]()
let monsterRaw = """
                  #
#    ##    ##    ###
 #  #  #  #  #  #
"""
let monster = monsterRaw.components(separatedBy: .newlines).map { [Character]($0) }
let monsterLongestLine = monster.map { $0.count }.max()!

func containOrReversedContain(array: [String], item: String) -> Bool {
    return array.contains(item) || array.contains(String(item.reversed()))
}

func leftRightMatches(rightEdgeOfLeft: String, leftEdgeOfRight: String) -> (Bool, Bool) {
    return ((rightEdgeOfLeft == leftEdgeOfRight || rightEdgeOfLeft == String(leftEdgeOfRight.reversed())), rightEdgeOfLeft == String(leftEdgeOfRight.reversed()))
}

func allSides(of block: [[Character]]) -> [String] {
    return [side_up(block: block), side_down(block: block), side_left(block: block), side_right(block: block)]
}

func side_up(block: [[Character]]) -> String {
    return String(block[0])
}

func side_down(block: [[Character]]) -> String {
    return String(block[block.count - 1])
}

func side_left(block: [[Character]]) -> String {
    var temp = ""
    for idx in block.indices {
        temp.append(block[idx][0])
    }
    return temp
}

func side_right(block: [[Character]]) -> String {
    var temp = ""
    for idx in block.indices {
        temp.append(block[idx][block.count-1])
    }
    return temp
}

func upsideDown(_ block: [[Character]]) -> [[Character]] {
    return block.reversed()
}

func flipped(_ block: [[Character]]) -> [[Character]] {
    return block.map { $0.reversed() }
}

func rotate(block: inout [[Character]]) {
    var newBlock = block
    for idx in 0..<block.count {
        for jdx in 0..<block.count {
            newBlock[idx][jdx] = block[block.count-jdx-1][idx]
        }
    }
    block = newBlock
}

func mapzipper(input: [Int: [[Character]]]) -> [[Character]] {
    let corners = nearby.filter { $0.value.count == 2 }, size = root2(input.count)
    var result = [[[[Character]]?]](repeating: [[[Character]]?](repeating: nil, count: size), count: size),
        map = [[Int?]](repeating: [Int?](repeating: nil, count: size), count: size), current = (0, 0)

    let first = corners.keys.first!
    result[0][0] = input[first]
    map[0][0] = first

    while containOrReversedContain(array: matches[first]!, item: side_up(block: result[0][0]!)) || containOrReversedContain(array: matches[first]!, item: side_left(block: result[0][0]!)) {
        rotate(block: &result[0][0]!)
    }

    while current.1 < result.count {
        if let currentPosItem = map[current.0][current.1], let potentialNeighbours = nearby[currentPosItem] {
            for pnidx in potentialNeighbours.indices where potentialNeighbours[pnidx].1 == false {
                if var temp = input[potentialNeighbours[pnidx].0] {
                    for _ in 0..<4 {
                        let compare = leftRightMatches(rightEdgeOfLeft: side_right(block: result[current.0][current.1]!),
                                                       leftEdgeOfRight: side_left(block: temp))
                        if compare.0 == true {
                            if compare.1 == true { temp = upsideDown(temp) }
                            if let foundNeighbour = nearby[potentialNeighbours[pnidx].0],
                               let idx = foundNeighbour.firstIndex(where: { $0.0 == currentPosItem }) {
                                nearby[potentialNeighbours[pnidx].0]![idx].1 = true
                            }
                            nearby[currentPosItem]![pnidx].1 = true
                            map[current.0][current.1 + 1] = potentialNeighbours[pnidx].0
                            result[current.0][current.1 + 1] = temp
                        } else {
                            rotate(block: &temp)
                        }
                    }
                }
            }
        }
        current = (current.0, current.1 + 1)
        if current.1 == result.count {
            if current.0 == result.count - 1 {
                break
            } else {
                current.1 = 0
                if let currentPosItem = map[current.0][current.1], let potentialNeighbours = nearby[currentPosItem] {
                    for pnidx in potentialNeighbours.indices where potentialNeighbours[pnidx].1 == false {
                        if let foundNeighbour = nearby[potentialNeighbours[pnidx].0],
                           let idx = foundNeighbour.firstIndex(where: { $0.0 == currentPosItem }) {
                            nearby[potentialNeighbours[pnidx].0]![idx].1 = true
                        }
                        if var temp = input[potentialNeighbours[pnidx].0] {
                            for _ in 0..<4 {
                                let compare = leftRightMatches(rightEdgeOfLeft: side_down(block: result[current.0][current.1]!),
                                                               leftEdgeOfRight: side_up(block: temp))
                                if compare.0 == true {
                                    if compare.1 == true { temp = flipped(temp) }
                                    nearby[currentPosItem]![pnidx].1 = true
                                    map[current.0+1][current.1] = potentialNeighbours[pnidx].0
                                    result[current.0+1][current.1] = temp
                                } else {
                                    rotate(block: &temp)
                                }
                            }
                        }
                    }
                }
                current.0 += 1
            }
        }
    }
    var end = [[Character]]()
    for idx in result.indices {
        var temp = [[Character]](repeating: [Character](), count: 8)
        for jdx in result[idx].indices {
            for kdx in result[idx][jdx]!.indices where kdx != 0 && kdx <= 8 {
                temp[kdx-1].append(contentsOf: result[idx][jdx]![kdx][1...8])
            }
        }
        end.append(contentsOf: temp)
    }
    return end
}

func solver1(input: [Int: [[Character]]]) -> (Int) {
    let allKeys = input.keys
    for key1 in allKeys {
        for key2 in allKeys where key1 != key2 {
            let current1 = input[key1]!, current2 = input[key2]!
            let sides = allSides(of: current1)
            for side in sides {
                let otherSides = allSides(of: current2)
                if containOrReversedContain(array: otherSides, item: side) {
                    matches[key1, default: []].append(side)
                    nearby[key1, default: []].append((key2, false))
                }
            }
        }
    }
    let sorted = matches.sorted { $0.value.count < $1.value.count }
    var count = 0, mul = 1, edges = [Int]()
    for item in sorted where count < 4 {
        edges.append(item.key)
        mul *= item.key
        count += 1
    }
    return mul
}

func solver2(input: [Int: [[Character]]]) -> Int {
    let zippedMap = mapzipper(input: input)
    var globalCount = 0, map = zippedMap, hashCount = 0
    for _ in 0..<4 {
        var current = map
        for _ in 0..<2 {
            current = flipped(current)
            var idx = 0, count = 0
            while idx < current.count-monster.count {
                var jdx = 0
                while jdx < current[idx].count-monsterLongestLine {
                    var flag = true
                    for sdx in 0..<monster.count {
                        for tdx in 0..<monster[sdx].count where monster[sdx][tdx] == "#" {
                            if current[idx+sdx][jdx+tdx] != "#" {
                                flag = false
                                break
                            }
                        }
                        if flag == false { break }
                    }
                    if flag { count += 1 }
                    globalCount = count > globalCount ? count : globalCount
                    jdx += 1
                }
                idx += 1
            }
        }
        rotate(block: &map)
    }
    for line in zippedMap {
        for char in line where char == "#" {
            hashCount += 1
        }
    }
    return hashCount - monsterRaw.filter { $0 == "#" }.count * globalCount
}

func solve() {
    let input = day20input
    let parsedInput = input.components(separatedBy: "\n\n")
    var map = [Int: [[Character]]]()
    for item in parsedInput {
        var parsed = item.components(separatedBy: ":\n")
        let key = parsed.removeFirst(), value = parsed.popLast()!.components(separatedBy: .newlines).map { [Character]($0) }
        map[Int(key[key.index(key.startIndex, offsetBy: 5)...])!] = value
    }
    print("Part 1")
    print(solver1(input: map))
    print("Part 2")
    print(solver2(input: map))
}

solve()
