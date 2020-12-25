struct Position {
    var x: Int = 0
    var y: Int = 0
    var distanceFromStart: Int { (x < 0 ? -x : x) + (y < 0 ? -y : y) }
    mutating func move(x: Int, y: Int) {
        self.x += x
        self.y += y
    }
    mutating func move(by mover: Mover) {
        self.x += mover.x
        self.y += mover.y
    }
}

struct Mover {
    var x: Int = 0
    var y: Int = 0
    init (_ input: (Int, Int) = (0, 0)) {
        x = input.0
        y = input.1
    }
    mutating func increase(by offsets: (Int, Int)) {
        x += offsets.0
        y += offsets.1
    }
    mutating func rotate(dir: Character) {
        if dir == "L" {
            let temp = self
            self.x = -temp.y
            self.y = temp.x
        } else {
            let temp = self
            self.x = temp.y
            self.y = -temp.x
        }
    }
}

func solver1(input: [String]) -> Int {
    var position = Position(), mover = Mover((1, 0))
    for dir in input {
        let instruction = dir[dir.startIndex], unit = Int(dir[dir.index(after: dir.startIndex)...])!
        if instruction == "N" {
            position.move(x: 0, y: unit)
        } else if instruction == "S" {
            position.move(x: 0, y: -unit)
        } else if instruction == "E" {
            position.move(x: unit, y: 0)
        } else if instruction == "W" {
            position.move(x: -unit, y : 0)
        } else if "LR".contains(instruction) {
            (0..<unit/90).forEach { _ in mover.rotate(dir: instruction) }
        } else {
            (0..<unit).forEach { _ in position.move(by: mover) }
        }
    }
    return position.distanceFromStart
}

func solver2(input: [String]) -> Int {
    var position = Position(), mover = Mover((10, 1))
    for dir in input {
        let instruction = dir[dir.startIndex], unit = Int(dir[dir.index(after: dir.startIndex)...])!
        if instruction == "N" {
            mover.increase(by: (0, unit))
        } else if instruction == "S" {
            mover.increase(by: (0, -unit))
        } else if instruction == "E" {
            mover.increase(by: (unit, 0))
        } else if instruction == "W" {
            mover.increase(by: (-unit, 0))
        } else if "LR".contains(instruction) {
            (0..<unit/90).forEach { _ in mover.rotate(dir: instruction) }
        } else {
            (0..<unit).forEach { _ in position.move(by: mover) }
        }
    }
    return position.distanceFromStart
}

func solve() {
    let rawInput = day12input
    let parsedInput = rawInput.components(separatedBy: .newlines)
    print("Part 1")
    print(solver1(input: parsedInput))
    print("Part 2")
    print(solver2(input: parsedInput))
}

solve()
