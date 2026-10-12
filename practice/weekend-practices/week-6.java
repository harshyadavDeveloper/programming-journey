class Main {

    public static void main(String[] args) {
        int[] arr = { 40, 20, 60, 10, 30, 50, 70 };

        TreeNode root = null;
        TreeNode root1 = null;
        TreeNode root2 = null;

        for (int num : arr) {
            root = insert(root, num);
            root1 = insert(root1, num);
            root2 = insert(root2, num);
        }

        // System.out.println("this tree has total leaves: " + countLeaves(root));
        // TreeNode target = returnParentNode(root, 10);
        // System.out.println("Parent of target is : " + target.val);
        // System.out.println("is the current tree balanced is? : " + isValidBST(root,
        // Long.MIN_VALUE, Long.MAX_VALUE));
        // System.out.println("The second largest value in the tree is " +
        // findSecondMax(root, null));
        System.out.println("are both the tree identical:  " + isSame(root1, root2));

    }

    public static TreeNode insert(TreeNode root, int num) {
        if (root == null) {
            return new TreeNode(num);
        }

        if (num < root.val) {
            root.left = insert(root.left, num);
        } else {
            root.right = insert(root.right, num);
        }
        return root;
    }

    // 1. Given the root of a binary tree, write a function to count the total
    // number of leaf nodes (nodes with no children).
    public static int countLeaves(TreeNode root) {
        if (root == null) {
            return 0;
        }

        if (root.left == null && root.right == null) {
            return 1;
        }

        return countLeaves(root.left) + countLeaves(root.right);
    }

    // 2. Given a BST and a target value, write a function that returns the node's
    // parent if the target exists, or null if it doesn't (don't just return whether
    // it exists — return the parent node).
    public static TreeNode returnParentNode(TreeNode node, int target) {
        if (node == null) {
            return null;
        }

        if (target < node.val) {
            if (node.left != null && node.left.val == target) {
                return node;
            }
            return returnParentNode(node.left, target);
        }
        if (target > node.val) {
            if (node.right != null && node.right.val == target) {
                return node;
            }
            return returnParentNode(node.right, target);
        }

        return null;
    }

    // 3. Write a function to check if a given binary tree is a valid BST. (Careful
    // — checking only node.left.val < node.val < node.right.val at each node is not
    // sufficient. Think about why.)
    public static boolean isValidBST(TreeNode root, long min, long max) {
        if (root == null) {
            return true;
        }

        if (root.val <= min || root.val >= max) {
            return false;
        }

        return isValidBST(root.left, min, root.val) && isValidBST(root.right, root.val, max);
    }

    // 4. Given a BST, find the second largest value in it, without using any
    // traversal that stores all values in an array/list first.

    // soluttion: Largest node ka left subtree hai → us left subtree ka largest node
    // = second largest.
    // Largest node ka left subtree nahi hai → largest ka parent = second largest.
    public static int findSecondMax(TreeNode root, TreeNode parent) {
        if (root == null) {
            return -1;
        }

        if (root.right == null) {
            if (root.left != null) {
                return findMax(root.left);
            }

            return parent.val;
        }

        return findSecondMax(root.right, root);

    }

    public static int findMax(TreeNode node) {
        if (node == null) {
            return -1;
        }

        if (node.right == null) {
            return node.val;
        }

        return findMax(node.right);
    }

    // 5. Given two binary trees, write a function that checks if they are identical
    // — same structure and same values at every position.
    public static boolean isSame(TreeNode root1, TreeNode root2) {
        if (root1 == null && root2 == null) {
            return true;
        }

        if ((root1 == null && root2 != null) || (root1 != null && root2 == null)) {
            return false;
        }

        if (root1.val == root2.val) {
            return isSame(root1.left, root2.left) && isSame(root1.right, root2.right);
        }

        return false;
    }

    // 6. Given a binary tree, write a function to find its diameter — the length of
    // the longest path between any two nodes (the path may or may not pass through
    // the root).
    public static int findDiameter(TreeNode root) {
        if (root == null) {
            return 0;
        }

        int leftHeight = calculateHeight(root.left);
        int rightHeight = calculateHeight(root.right);

        int currentDiameter = leftHeight + rightHeight + 2;

        int leftDiameter = findDiameter(root.left);
        int rightDiameter = findDiameter(root.right);
        return Math.max(currentDiameter, Math.max(leftDiameter, rightDiameter));

    }

    public static int calculateHeight(TreeNode node) {
        if (node == null) {
            return -1;
        }

        return 1 + Math.max(calculateHeight(node.left), calculateHeight(node.right));

    }

    // 8. Given a binary tree, print its boundary — root, then all left-edge nodes
    // top to bottom, then all leaf nodes left to right, then all right-edge nodes
    // bottom to top.
    public static void printBoundary(TreeNode root) {

        if (root == null) {
            return;
        }

        System.out.print(root.val + " ");

        printLeftBoundary(root.left);

        printLeaves(root.left);
        printLeaves(root.right);

        printRightBoundary(root.right);
    }

    public static void printLeftBoundary(TreeNode node) {

        if (node == null) {
            return;
        }
        if (node.left == null && node.right == null) {
            return;
        }

        System.out.print(node.val + " ");
        if (node.left != null) {
            printLeftBoundary(node.left);
        } else {
            printLeftBoundary(node.right);
        }
    }

    public static void printLeaves(TreeNode node) {

        if (node == null) {
            return;
        }

        if (node.left == null && node.right == null) {
            System.out.print(node.val + " ");
            return;
        }

        printLeaves(node.left);
        printLeaves(node.right);
    }

    public static void printRightBoundary(TreeNode node) {

        if (node == null) {
            return;
        }

        if (node.left == null && node.right == null) {
            return;
        }
        if (node.right != null) {
            printRightBoundary(node.right);
        } else {
            printRightBoundary(node.left);
        }

        System.out.print(node.val + " ");
    }

    // 9. Convert a given binary tree into its mirror image (left and right children
    // swapped at every node) in place.
    public static TreeNode mirrorTree(TreeNode root) {
        if (root == null) {
            return null;
        }

        TreeNode temp = root.left;
        root.left = root.right;
        root.right = temp;

        mirrorTree(root.left);
        mirrorTree(root.right);

        return root;
    }

    // 10. Given a BST and two integers low and high, return the sum of all node
    // values that fall within [low, high] inclusive —
    // without visiting nodes that can’t possibly be in range.
    public static int treeSum(TreeNode root, int low, int high) {
        if (root == null) {
            return 0;
        }
        if (root.val < low) {
            return treeSum(root.right, low, high);
        } else if (root.val > high) {
            return treeSum(root.left, low, high);
        } else {
            return root.val + treeSum(root.left, low, high) + treeSum(root.right, low, high);
        }
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