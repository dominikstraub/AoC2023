public final class LinkedList<T> {
    /// Linked List's Node Class Declaration
    public class LinkedListNode<T> {
        public var value: T
        public fileprivate(set) var next: LinkedListNode?
        public fileprivate(set) weak var previous: LinkedListNode?

        public init(value: T) {
            self.value = value
        }
    }

    /// Typealiasing the node class to increase readability of code
    public typealias Node = LinkedListNode<T>

    /// The head of the Linked List
    public private(set) var head: Node?

    /// The tail of the Linked List
    public private(set) var tail: Node?

    /// The count of the Linked List
    public private(set) var count: Int = 0

    /// Computed property to iterate through the linked list and return the last node in the list (if any)
    // public var last: Node? {
    //     guard var node = head else {
    //         return nil
    //     }

    //     while let next = node.next {
    //         node = next
    //     }
    //     return node
    // }

    /// Computed property to check if the linked list is empty
    public var isEmpty: Bool {
        return head == nil
    }

    /// Computed property to iterate through the linked list and return the total number of nodes
    // public var count: Int {
    //     guard var node = head else {
    //         return 0
    //     }

    //     var count = 1
    //     while let next = node.next {
    //         node = next
    //         count += 1
    //     }
    //     return count
    // }

    /// Default initializer
    public init() {}

    /// Subscript function to return the node at a specific index
    ///
    /// - Parameter index: Integer value of the requested value's index
    public subscript(index: Int) -> T {
        let node = self.node(at: index)
        return node.value
    }

    /// Function to return the node at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameter index: Integer value of the node's index to be returned
    /// - Returns: LinkedListNode
    public func node(at index: Int) -> Node {
        assert(head != nil, "List is empty")
        assert(index >= 0, "index must be greater or equal to 0")

        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1 ..< index {
                node = node?.next
                if node == nil {
                    break
                }
            }

            assert(node != nil, "index is out of bounds.")
            return node!
        }
    }

    /// Append a value to the end of the list
    ///
    /// - Parameter value: The data value to be appended
    @discardableResult public func append(_ value: T) -> Node {
        let newNode = Node(value: value)
        append(newNode)
        return newNode
    }

    /// Append a copy of a LinkedListNode to the end of the list.
    ///
    /// - Parameter node: The node containing the value to be appended
    public func append(_ node: Node) {
        let newNode = node
        if let lastNode = tail {
            newNode.previous = lastNode
            lastNode.next = newNode
            tail = newNode
        } else {
            head = newNode
            tail = newNode
        }
        count += 1
    }

    /// Append a copy of a LinkedList to the end of the list.
    ///
    /// - Parameter list: The list to be copied and appended.
    public func append(_ list: LinkedList) {
        var nodeToCopy = list.head
        while let node = nodeToCopy {
            append(node.value)
            nodeToCopy = node.next
        }
    }

    /// Insert a value at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - value: The data value to be inserted
    ///   - index: Integer value of the index to be insterted at
    @discardableResult public func insert(_ value: T, at index: Int) -> Node {
        let newNode = Node(value: value)
        insert(newNode, at: index)
        return newNode
    }

    /// Insert a copy of a node at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - node: The node containing the value to be inserted
    ///   - index: Integer value of the index to be inserted at
    public func insert(_ newNode: Node, at index: Int) {
        if index == 0 {
            newNode.next = head
            if let head = head {
                head.previous = newNode
            } else {
                tail = newNode
            }
            head = newNode
        } else {
            let prev = node(at: index - 1)
            if let next = prev.next {
                next.previous = newNode
                newNode.next = next
            } else {
                tail = newNode
            }
            newNode.previous = prev
            prev.next = newNode
        }
        count += 1
    }

    /// Insert a copy of a LinkedList at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - list: The LinkedList to be copied and inserted
    ///   - index: Integer value of the index to be inserted at
    public func insert(_ list: LinkedList, at index: Int) {
        guard !list.isEmpty else { return }

        if index == 0 {
            list.tail?.next = head
            head = list.head
        } else {
            let prev = node(at: index - 1)
            let next = prev.next

            prev.next = list.head
            list.head?.previous = prev
            let last = list.tail
            last?.next = next
            next?.previous = last
        }
        count += list.count
    }

    /// Insert a copy of a LinkedList after a specified Node
    ///
    /// - Parameters:
    ///   - list: The LinkedList to be copied and inserted
    ///   - node: Node
    public func insert(_ list: LinkedList, after prev: Node) {
        guard !list.isEmpty else { return }

        let next = prev.next

        prev.next = list.head
        list.head?.previous = prev
        let last = list.tail
        last?.next = next
        next?.previous = last

        count += list.count
    }

    /// Function to remove all nodes/value from the list
    public func removeAll() {
        head = nil
        tail = nil
        count = 0
    }

    /// Function to remove a specific node.
    ///
    /// - Parameter node: The node to be deleted
    /// - Returns: The data value contained in the deleted node.
    @discardableResult public func remove(node: Node) -> Node {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        if let next = next {
            next.previous = prev
        } else {
            tail = prev
        }

        node.previous = nil
        node.next = nil
        count -= 1
        return node
    }

    /// Function to remove the last node/value in the list. Crashes if the list is empty
    ///
    /// - Returns: The data value contained in the deleted node.
    @discardableResult public func removeLast() -> Node {
        assert(!isEmpty)
        return remove(node: tail!)
    }

    /// Function to remove a node/value at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameter index: Integer value of the index of the node to be removed
    /// - Returns: The data value contained in the deleted node
    @discardableResult public func remove(at index: Int) -> Node {
        let node = self.node(at: index)
        return remove(node: node)
    }

    public var prettyPrint: String {
        var s = ""
        var node = head
        var prefixPadding = ""
        var count = 0
        while let nd = node {
            if count > 15 {
                break
            }
            s += prefixPadding
            if let previous = nd.previous?.value {
                s += "\(previous) "
            } else {
                s += ". "
            }
            s += "\(nd.value)"
            if let next = nd.next?.value {
                s += " \(next)"
            } else {
                s += " ."
            }
            node = nd.next
            if node != nil { s += "\n" }
            prefixPadding += "  "
            count += 1
        }
        return s
    }
}

//: End of the base class declarations & beginning of extensions' declarations:

// MARK: - Extension to enable the standard conversion of a list to String

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = head
        while let nd = node {
            s += "\(nd.value)"
            node = nd.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
}

// MARK: - Extension to add a 'reverse' function to the list

public extension LinkedList {
    func reverse() {
        var node = head
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
}

public extension LinkedList {
    func reversed() {
        let list = LinkedList<T>()
        var currentNode = tail
        while let node = currentNode {
            list.append(node)
            currentNode = node.previous
        }
    }
}

// MARK: - An extension with an implementation of 'map' & 'filter' functions

public extension LinkedList {
    func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while let nd = node {
            result.append(transform(nd.value))
            node = nd.next
        }
        return result
    }

    func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while let nd = node {
            if predicate(nd.value) {
                result.append(nd.value)
            }
            node = nd.next
        }
        return result
    }
}

// MARK: - Extension to enable initialization from an Array

extension LinkedList {
    convenience init(array: [T]) {
        self.init()

        array.forEach { append($0) }
    }
}

// MARK: - Extension to enable initialization from an Array Literal

extension LinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()

        elements.forEach { append($0) }
    }
}

public extension LinkedList where T: Equatable {
    @inlinable func contains(_ value: T) -> Bool {
        var currentNode = head
        while let node = currentNode {
            if node.value == value {
                return true
            }
            currentNode = node.next
        }
        return false
    }
}

// MARK: - Collection

extension LinkedList: Collection {
    public typealias Index = LinkedListIndex<T>

    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    /// - Complexity: O(1)
    public var startIndex: Index {
        return LinkedListIndex<T>(node: head, tag: 0)
    }

    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    /// - Complexity: O(n), where n is the number of elements in the list. This can be improved by keeping a reference
    ///   to the last node in the collection.
    public var endIndex: Index {
        return LinkedListIndex<T>(node: tail, tag: count - 1)
    }

    public subscript(position: Index) -> T {
        return position.node!.value
    }

    public func index(after idx: Index) -> Index {
        return LinkedListIndex<T>(node: idx.node?.next, tag: idx.tag + 1)
    }
}

// MARK: - Collection Index

/// Custom index type that contains a reference to the node at index 'tag'
public struct LinkedListIndex<T>: Comparable {
    public let node: LinkedList<T>.LinkedListNode<T>?
    public let tag: Int

    public static func== <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag == rhs.tag)
    }

    public static func< <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag < rhs.tag)
    }
}

extension LinkedList.LinkedListNode: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}
