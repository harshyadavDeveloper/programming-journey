import java.util.ArrayList;
import java.util.List;

public class Task109_BFSPathTrace {
    public static void main(String[] args) {
        TreeNode root = new TreeNode(40);
        root.left = new TreeNode(20);
        root.right = new TreeNode(60);
        root.left.left = new TreeNode(10);
        root.left.right = new TreeNode(30);
        root.right.left = new TreeNode(50);
        root.right.right = new TreeNode(70);

    }

    public static List<Integer> printSum(TreeNode root, int target) {
        if (root == null) {
            return null;
        }
        if (root.val == target) {
            List<Integer> path = new ArrayList<>();
            path.add(root.val);
            return path;

        } else if (root.val < target) {
            List<Integer> path = printSum(root.right, target);
            if (path == null) {
                return null;
            }
            path.add(0, root.val);
            return path;
        } else {
            List<Integer> path = printSum(root.left, target);
            if (path == null) {
                return null;
            }
            path.add(0, root.val);
            return path;
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