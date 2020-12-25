let directions = ["e", "se", "sw", "w", "nw", "ne"]
var map = [Position: Bool]()

struct Position: Hashable {
    var x: Int = 0
    var y: Int = 0
    var z: Int = 0

    mutating func move(x: Int, y: Int, z: Int){
        self.x += x
        self.y += y
        self.z += z
    }
}

func decoder(referencePoint: Position = Position(), _ instruction: String) -> Position {
    var position = referencePoint, instruction = instruction
    while instruction.isEmpty == false {
        if instruction.starts(with: "e") {
            instruction.removeFirst()
            position.move(x: 1, y: -1, z: 0)
        } else if instruction.starts(with: "se") {
            instruction.removeFirst(2)
            position.move(x: 0, y: -1, z: 1)
        } else if instruction.starts(with: "sw") {
            instruction.removeFirst(2)
            position.move(x: -1, y: 0, z: 1)
        } else if instruction.starts(with: "w") {
            instruction.removeFirst()
            position.move(x: -1, y: 1, z: 0)
        } else if instruction.starts(with: "nw") {
            instruction.removeFirst(2)
            position.move(x: 0, y: 1, z: -1)
        } else if instruction.starts(with: "ne") {
            instruction.removeFirst(2)
            position.move(x: 1, y: 0, z: -1)
        }
    }
    return position
}

func solver1(input: [String]) -> Int {
    for instruction in input {
        let position = decoder(instruction)
        map[position] = !map[position, default: false]
    }
    return map.values.filter { $0 == true }.count
}

func solver2(times: Int) -> Int {
    for _ in 0..<times {
        var current = map
        for key in map.keys {
            directions.map { decoder(referencePoint: key, $0) }.forEach { map[$0] = map[$0, default: false] }
        }
        for (position, isBlack) in map {
            let blackNeighbours = directions.map { decoder(referencePoint: position, $0) }.reduce(0) {
                $0 + (map[$1, default: false] == true ? 1 : 0)
            }
            if isBlack && ![1, 2].contains(blackNeighbours) {
                current[position] = false
            } else if !isBlack && blackNeighbours == 2 {
                current[position] = true
            }
        }
        map = current
    }
    return map.filter { $1 }.count
}

func solve() {
    let input = day24input
    let parsedInput = input.components(separatedBy: .newlines)
    print("Part 1")
    print(solver1(input: parsedInput))
    print("Part 2")
    print(solver2(times: 100))
}

solve()
