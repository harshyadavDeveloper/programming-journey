// question link: https://leetcode.com/problems/validate-binary-search-tree/
// difficulty level: Medium
// description: Given the root of a binary tree, determine if it is a valid binary search tree (BST).
// A valid BST is defined as follows:
// The left subtree of a node contains only nodes with keys strictly less than the node's key.
// The right subtree of a node contains only nodes with keys strictly greater than the node's key.
// Both the left and right subtrees must also be binary search trees.

// approach here: a valid bst must follow 3 rules:
// 1. every value in the left must be smaller then the node 
// 2. every value in the right must greater than the node.
// 3. both subtree must independently satisfy these rules.
// The third is really important but easier to over look.

class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;

    TreeNode() {
    }

    TreeNode(int val) {
        this.val = val;
    }

    TreeNode(int val, TreeNode left, TreeNode right) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Solution {
    public boolean isValidBst(TreeNode root) {
        return checkIsValid(root, Integer.MIN_VALUE, Integer.MAX_VALUE);
    }

    public static boolean checkIsValid(TreeNode root, int min, int max) {
        if (root == null) {
            return true;
        }

        if (root.val <= min || root.val >= max) {
            return false;
        }

        return checkIsValid(root.left, min, root.val) && checkIsValid(root.right, root.val, max);
    }

     public static void main(String[] args) {
        Solution solution = new Solution();

        // Test Case 1: Valid BST
        //       10
        //      /  \
        //     5    15
        TreeNode root1 = new TreeNode(10);
        root1.left = new TreeNode(5);
        root1.right = new TreeNode(15);

        System.out.println("Test 1: " + solution.isValidBst(root1));
        // Expected: true

        // Test Case 2: Invalid BST
        //       10
        //      /  \
        //     5    15
        //         /
        //        8
        TreeNode root2 = new TreeNode(10);
        root2.left = new TreeNode(5);
        root2.right = new TreeNode(15);
        root2.right.left = new TreeNode(8);

        System.out.println("Test 2: " + solution.isValidBst(root2));
        // Expected: false (8 is in the right subtree of 10)

        // Test Case 3: Valid BST
        //          20
        //         /  \
        //       10    30
        //       / \   / \
        //      5  15 25  35
        TreeNode root3 = new TreeNode(20);
        root3.left = new TreeNode(10);
        root3.right = new TreeNode(30);
        root3.left.left = new TreeNode(5);
        root3.left.right = new TreeNode(15);
        root3.right.left = new TreeNode(25);
        root3.right.right = new TreeNode(35);

        System.out.println("Test 3: " + solution.isValidBst(root3));
        // Expected: true

        // Test Case 4: Invalid BST
        //       10
        //      /  \
        //     5    8
        TreeNode root4 = new TreeNode(10);
        root4.left = new TreeNode(5);
        root4.right = new TreeNode(8);

        System.out.println("Test 4: " + solution.isValidBst(root4));
        // Expected: false (8 is smaller than 10)

        // Test Case 5: Empty tree
        TreeNode root5 = null;

        System.out.println("Test 5: " + solution.isValidBst(root5));
        // Expected: true

        // Test Case 6: Invalid BST (value violates ancestor constraint)
        //          10
        //         /  \
        //        5    20
        //            /
        //           9
        TreeNode root6 = new TreeNode(10);
        root6.left = new TreeNode(5);
        root6.right = new TreeNode(20);
        root6.right.left = new TreeNode(9);

        System.out.println("Test 6: " + solution.isValidBst(root6));
        // Expected: false (9 is in the right subtree of 10)
    }

}
