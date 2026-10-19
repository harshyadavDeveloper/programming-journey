// Given a BST, produce a sorted singly linked list of its values — using in-order traversal (Week 6) to get sorted order, 
// then your linked-list insert logic (Week 4) to build the list. One traversal should do both steps, not two separate passes.
public class Task108_TreeToSortedArrayToLinkedList {
    static Node head;
    static Node tail;

    public static void main(String[] args) {
        TreeNode root = new TreeNode(40);
        root.left = new TreeNode(20);
        root.right = new TreeNode(60);
        root.left.left = new TreeNode(10);
        root.left.right = new TreeNode(30);
        root.right.left = new TreeNode(50);
        root.right.right = new TreeNode(70);
        head = null;
        tail = null;

        converToLinkedList(root);
        Node curr = head;
        while (curr != null) {
            System.out.print(curr.val + "->");
            curr = curr.next;
        }
    }

    public static void converToLinkedList(TreeNode root) {
        if (root == null) {
            return;
        }
        converToLinkedList(root.left);
        Node newNode = new Node(root.val);
        if (head == null) {
            head = newNode;
            tail = newNode;
        } else {
            tail.next = newNode;
            tail = newNode;
        }
        converToLinkedList(root.right);

    }
}

class Node {
    int val;
    Node next;

    Node(int val) {
        this.val = val;
        this.next = null;
    }

}

class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;

    TreeNode(int val) {
        this.val = val;
        this.left = null;
        this.right = null;
    }
}
