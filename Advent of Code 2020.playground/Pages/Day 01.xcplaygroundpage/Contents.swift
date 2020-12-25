func twoSum(_ array: [Int], sum: Int) -> (Int, Int)? {
    var output = (Int.min, Int.min), map = [Int: Int]()
    array.indices.forEach { map[array[$0]] = $0 }
    for idx in array.indices {
        if let sdx = map[sum-array[idx]] {
            output.0 = array[idx]
            output.1 = array[sdx]
        }
    }
    return output.0 == Int.min || output.1 == Int.min ? nil : output
}

func threeSum(_ array: [Int], sum: Int) -> (Int, Int, Int)? {
    var output = (Int.min, Int.min, Int.min), trray = array
    for idx in array.indices {
        trray = array
        trray.remove(at: idx)
        if let res = twoSum(trray, sum: sum - array[idx]) {
            output.0 = array[idx]
            output.1 = res.0
            output.2 = res.1
        }
    }
    return output.0 == Int.min || output.1 == Int.min || output.2 == Int.min ? nil : output
}

func solver1(input: [Int]) {
    if let res = twoSum(input, sum: 2020) {
        print(res.0 * res.1)
    }
}

func solver2(input: [Int]) {
    if let res = threeSum(input, sum: 2020) {
        print(res.0 * res.1 * res.2)
    }
}

func solve() {
    let rawInput = day1input
    let parsedInput = rawInput.components(separatedBy: .newlines).map { Int($0)! }
    print("Part 1")
    solver1(input: parsedInput)
    print("Part 2")
    solver2(input: parsedInput)
}

solve()
