class Node {
    init(_ val: Int, next: Node? = nil) {
        self.val = val
        self.next = next
    }
    var val: Int
    var next: Node? = nil
}

class LinkedList {
    init(_ array: [Int]) {
        for item in array {
            append(Node(item))
        }
    }

    deinit {
        while isEmpty == false {
            if head?.val == tail?.val {
                table[head!.val] = nil
                head = nil
                tail = nil
            } else {
                table[head!.val] = nil
                head = head?.next
            }
        }
    }

    func append(_ newNode: Node) {
        if head == nil {
            head = newNode
            tail = newNode
        } else {
            tail?.next = newNode
            tail = tail?.next
        }
        if newNode.val > max {
            max = newNode.val
        }
        table[newNode.val] = newNode
    }

    func removeFirst() -> Node? {
        guard let res = head else { return nil }
        head = head?.next
        res.next = nil
        return res
    }

    func insert(contentsOf c: [Node], after: Node) {
        let flag = after.next == nil ? true : false
        for item in c.reversed() {
            let newNode = item
            if flag == true && item.val == c.last?.val {
                tail = newNode
            }
            newNode.next = after.next
            after.next = newNode
            if newNode.val > max {
                max = newNode.val
            }
            table[newNode.val] = newNode
        }
    }

    func moveHeadToTail() -> Node? {
        let item = head
        head = head?.next
        item?.next = nil
        tail?.next = item
        tail = tail?.next
        return item
    }

    var isEmpty: Bool { head == nil }
    var max: Int = 0
    var head: Node?
    var tail: Node?
    var table = [Int: Node]()
}

func solver(input: LinkedList, moves: Int, mode: Bool = false) -> String {
    let max = input.max
    for _ in 0..<moves {
        if let round = input.moveHeadToTail() {
            var pickedNumber = [Node]()
            for _ in 0..<3 {
                pickedNumber.append(input.removeFirst()!)
            }
            var destination = round.val - 1 > 0 ? round.val - 1 : max
            while pickedNumber.contains(where: { $0.val == destination }) {
                destination -= 1
                if destination <= 0 {
                    destination = max
                }
            }
            if let item = input.table[destination] {
                input.insert(contentsOf: pickedNumber, after: item)
            }
        }
    }

    if mode == false {
        if let item = input.table[1] {
            var temp = item.next ?? input.head, output = ""
            while let current = temp, current.val != item.val {
                output.append("\(current.val)")
                temp = current.next ?? input.head
            }
            return output
        }
    } else {
        if let search = input.table[1], let head = input.head {
            let first = search.next ?? head
            let second = first.next ?? head
            return "\(first.val * second.val)"
        }
    }
    return ""
}

func solve() {
    let input = day23input.map { Int("\($0)")! }
    var parsedInput: LinkedList? = LinkedList(input)

    print("Part 1")
    print(solver(input: parsedInput!, moves: 100))

    print("Part 2")
    parsedInput = LinkedList(input)
    let max = input.max()!
    for idx in max+1...1_000_000 {
        parsedInput!.append(Node(idx))
    }
    print(solver(input: parsedInput!, moves: 10_000_000, mode: true))

}

solve()
