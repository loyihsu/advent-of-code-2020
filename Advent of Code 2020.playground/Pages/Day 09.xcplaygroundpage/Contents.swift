func preamble(input: [Int], level: Int) -> [Int] {
    var previous = [Int](), answer = [Int]()
    for idx in input.indices {
        if idx < level {
            previous.append(input[idx])
        } else {
            if twoSum(in: previous, input[idx]) == false {
                answer.append(input[idx])
            }
            previous.removeFirst()
            previous.append(input[idx])
        }
    }

    return answer
}

func twoSum(in prev: [Int], _ find: Int) -> Bool {
    for number in prev {
        if prev.contains(find-number) {
            if find-number == number {
                let found = prev.filter { $0 == number }
                if found.count > 1 {
                    return true
                }
            } else {
                return true
            }
        }
    }
    return false
}

func find(sum: Int, in array: [Int]) -> Int {
    var low = Int.max, high = Int.min
    for scope in 1..<array.count-1 {
        for idx in scope..<array.count {
            var s = 0, stemp = [Int]()
            for jdx in 0...scope {
                s += array[idx-jdx]
                stemp.append(array[idx-jdx])
            }
            if s == sum {
                for st in stemp {
                    if st < low {
                        low = st
                    }
                    if st > high {
                        high = st
                    }
                }
                return low + high
            }
        }
    }
    return low + high
}

func solve() {
    let rawInput = day9input
    let parsedInput = rawInput.components(separatedBy: .newlines).map { Int($0)! }
    print("Part 1")
    let res = preamble(input: parsedInput, level: 25)
    print(res.first!)
    print("Part 2")
    print(find(sum: res.first!, in: parsedInput))
}

solve()
