import java.util.HashMap;

class Main {
    static int count = 0;
    static int result = -1;

    public static void main(String[] args) {
        // int[] arr = { 20, 30, 40, 50, 60, 70, 80 };
        // TreeNode root = null;
        // root = buildBalancedBst(arr, 0, arr.length - 1);
        // int k = kthSmallest(root, 4);
        // System.out.println(k);
        // System.out.println(palindromicStringMap("aabbcdd"));

        // Node first = new Node(10);
        // Node second = new Node(20);
        // Node third = new Node(30);
        // Node fourth = new Node(40);

        // first.next = second;
        // second.next = third;
        // third.next = fourth;
        // // fourth.next is null
        // System.out.println(detectCycle(first)); // false
        int[] arr = { 2, 1, 5, 1, 3, 2 };
        int k = 3;

        System.out.println(maxSubarraySum(arr, k));
    }

    public static TreeNode buildBalancedBst(int[] arr, int start, int end) {
        if (start > end) {
            return null;
        }

        int mid = (start + end) / 2;
        TreeNode root = new TreeNode(arr[mid]);
        root.left = buildBalancedBst(arr, start, mid - 1);
        root.right = buildBalancedBst(arr, mid + 1, end);

        return root;

    }

    // 1. Find the k-th smallest element in a BST.
    public static int kthSmallest(TreeNode root, int k) {
        count = 0;
        result = -1;

        inOrder(root, k);
        return result;

    }

    private static void inOrder(TreeNode node, int k) {
        if (node == null || count >= k) {
            return;
        }

        inOrder(node.left, k);
        count++;
        if (count == k) {
            result = node.val;
            return;
        }

        inOrder(node.right, k);
    }

    // 2. Check if a string’s characters can be rearranged into a palindrome.
    public static boolean palindromicString(String word) {
        if (word.length() == 0) {
            return true;
        }
        int[] freq = new int[26];

        for (int i = 0; i < word.length(); i++) {
            char c = word.charAt(i);
            int index = c - 'a';
            freq[index]++;

        }
        int isOdd = 0;
        for (int i = 0; i < 26; i++) {
            if (freq[i] % 2 != 0) {
                isOdd += 1;
            }
        }
        if (isOdd > 1) {
            return false;
        }
        return true;

    }

    public static boolean palindromicStringMap(String word) {
        if (word.length() == 0) {
            return true;
        }

        HashMap<Character, Integer> map = new HashMap<>();

        for (int i = 0; i < word.length(); i++) {
            char c = word.charAt(i);
            map.put(c, map.getOrDefault(c, 0) + 1);
        }
        int isOdd = 0;

        for (HashMap.Entry<Character, Integer> entry : map.entrySet()) {
            int curr = entry.getValue();
            if (curr % 2 != 0) {
                isOdd += 1;
            }

        }
        if (isOdd > 1) {
            return false;
        }
        return true;
    }

    public static boolean isPalindrome(String word) {
        char[] str = word.toCharArray();
        int start = 0;
        int end = str.length - 1;

        while (start < end) {
            if (str[start] != str[end]) {
                return false;
            }
            start++;
            end--;
        }
        return true;
    }

    // 3. Given a linked list, detect if it has a cycle.
    public static boolean detectCycle(Node node) {
        if (node == null) {
            return false;
        }
        Node first = node;

        Node slow = first;
        Node fast = first;

        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            if (slow == fast) {
                return true;
            }

        }
        return false;

    }

    // 4. Given an array, find the maximum sum of any contiguous subarray of size k
    public static int maxSubarraySum(int[] arr, int k) {
        int sum = 0;
        for (int i = 0; i <= arr.length - k; i++) {
            int currSum = 0;
            for (int j = i; j < i + k; j++) {
                currSum += arr[j];
            }
            sum = Math.max(sum, currSum);
        }
        return sum;
    }

    // 5. Invert a binary tree (mirror it) and confirm the structure with a level-order print before and after.
    public  static TreeNode invertTree(TreeNode root){
        if(root == null){
            return null;
        }

        TreeNode temp = root.left;
        root.left = root.right;
        root.right = temp;

        invertTree(root.left);
        invertTree(root.right);
        return root;
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

class Node {
    int val;
    Node next;

    Node(int val) {
        this.val = val;
        this.next = null;
    }
}