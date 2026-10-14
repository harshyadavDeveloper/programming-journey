// You’ve reversed a linked list before — but do it recursively this time instead of iteratively. Trace by hand 
// first: what does the recursive call return, and where does the pointer-flipping actually happen — before or after 
// the recursive call returns?

class Main {
    public static void main(String[] args) { // 5 -> 10 -> 15 -> 20 -> 25
        Node first = new Node(5);
        Node second = new Node(10);
        Node third = new Node(15);
        Node fourth = new Node(20);
        Node fifth = new Node(25);

        first.next = second;
        second.next = third;
        third.next = fourth;
        fourth.next = fifth;

        // print(first);
        first = reverseRecursively(first);
        print(first);

    }

    public static Node reverse(Node head) {
        if (head == null || head.next == null) {
            return head;
        }

        Node current = head;
        Node prev = null;

        while (current != null) {
            Node next = current.next;
            current.next = prev;
            prev = current;
            current = next;
        }

        return prev;
    }

    public static Node reverseRecursively(Node head) { // 5 -> 10 -> 15 -> 20 -> 25
        if (head == null || head.next == null) {
            return head;
        }

        Node newHead = reverseRecursively(head.next);
        head.next.next = head;
        head.next = null;

        return newHead;

    }

    public static void print(Node head) {
        if (head == null) {
            return;
        }

        Node curr = head;
        while (curr != null) {
            System.out.print(curr.value + "->");
            curr = curr.next;
        }
    }
}

class Node {
    int value;
    Node next;

    Node(int value) {
        this.value = value;
        this.next = null;
    }
}