func resultGenerator(winner: [Int]) -> Int {
    var output = 0
    for (idx, val) in winner.reversed().enumerated() {
        output += (idx + 1) * val
    }
    return output
}

func stringify(_ array: [Int]) -> String {
    return array.map { "\($0)" }.joined()
}

func game(_ player1: [Int], _ player2: [Int], recursive: Bool = false) -> (Int, Int) {
    var person1 = player1, person2 = player2, player1Book = [String: Bool](), player2Book = [String: Bool]()
    while person1.isEmpty == false && person2.isEmpty == false {
        if player1Book[stringify(person1)] == true || player2Book[stringify(person2)] == true {
            return (resultGenerator(winner: person1), 1)
        }
        player1Book[stringify(person1)] = true
        player2Book[stringify(person2)] = true

        let temp1 = person1.removeFirst(), temp2 = person2.removeFirst()
        if recursive && person1.count >= temp1 && person2.count >= temp2 {
            if game([Int](person1[0..<temp1]), [Int](person2[0..<temp2]), recursive: true).1 == 1 {
                person1.append(contentsOf: [temp1, temp2])
            } else {
                person2.append(contentsOf: [temp2, temp1])
            }
        } else {
            temp1 > temp2 ? person1.append(contentsOf: [temp1, temp2]) : person2.append(contentsOf: [temp2, temp1])
        }
    }
    let winner = person2.isEmpty ? 1 : 2
    return (resultGenerator(winner: person2.isEmpty ? person1 : person2), winner)
}

func solve() {
    let input = day22input
    let parsedInput = input.components(separatedBy: "\n\n")
    let player1 = parsedInput[0].components(separatedBy: .newlines)[1...].map { Int($0)! }
    let player2 = parsedInput[1].components(separatedBy: .newlines)[1...].map { Int($0)! }
    print("Part 1")
    print(game(player1, player2).0)
    print("Part 2")
    print(game(player1, player2, recursive: true).0)
}

solve()
