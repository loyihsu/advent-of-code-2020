struct Coordinate: Hashable {
    var x: Int, y: Int, z: Int, q: Int
}

func compare(mode: Bool = false, array: [Int]) -> Int {
    var comp = mode ? Int.min : Int.max
    array.forEach { comp = (mode ? $0 > comp : $0 < comp) ? $0 : comp }
    return comp
}

func step(grid: [Coordinate: Bool], q mode: Bool = false) -> [Coordinate: Bool] {
    var newGrid = [Coordinate: Bool]()
    let arrx = grid.keys.map { $0.x }, arry = grid.keys.map { $0.y }, arrz = grid.keys.map { $0.z }, arrq = grid.keys.map { $0.q }
    for x in compare(array: arrx)-1...compare(mode: true, array: arrx)+2 {
        for y in compare(array: arry)-1...compare(mode: true, array: arry)+2 {
            for z in compare(array: arrz)-1...compare(mode: true, array: arrz)+2 {
                let range = mode ? compare(array: arrq)-1...compare(mode: true, array: arrq)+2 : 0...0
                for q in range {
                    let state = grid[Coordinate(x: x, y: y, z: z, q: q), default: false]
                    var tempsum = 0
                    for dx in -1...1 {
                        for dy in -1...1 {
                            for dz in -1...1 {
                                for dq in mode ? -1...1 : 0...0 {
                                    if !(dx == 0 && dy == 0 && dz == 0 && dq == 0) && (grid[Coordinate(x: x+dx, y: y+dy, z: z+dz, q: q+dq), default: false]) {
                                        tempsum += 1
                                    }
                                }
                            }
                        }
                    }
                    if (state && (tempsum == 2 || tempsum == 3)) || (state == false && tempsum == 3) {
                        newGrid[Coordinate(x: x, y: y, z: z, q: q)] = true
                    }
                }

            }
        }
    }
    return newGrid
}

func solver(input: [Coordinate: Bool], q mode: Bool = false) -> Int {
    var map = input
    (0..<6).forEach {_ in map = step(grid: map, q: mode) }
    return map.count
}

func solve() {
    let input = day17input
    let parsedInput = input.components(separatedBy: .newlines).map { Array($0) }
    var map = [Coordinate: Bool]()
    for row in parsedInput.indices {
        for col in parsedInput[row].indices {
            map[Coordinate(x: row, y: col, z: 0, q: 0)] = parsedInput[row][col] == "#"
        }
    }
    print("Part 1")
    print(solver(input: map))
    print("Part 2")
    print(solver(input: map, q: true))
}

solve()
