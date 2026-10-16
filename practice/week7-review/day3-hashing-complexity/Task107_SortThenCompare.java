// Pick any sort you implemented in Week 3 (bubble, selection, or insertion) and
// run it on an array, then separately
// solve Task 105 (two-sum) using the sort-then-two-pointer approach instead of
// HashMap. Compare the Big-O of both
// two-sum solutions in a comment — which is faster, and is there a tradeoff?

class Main {
    public static void main(String[] args) {
        int[] arr = { 10, 4, 8, 12, 13, 20 };
        bubbleSort(arr);
        for (int a : arr) {
            System.out.print(a + " ");
        }
        twoSum(arr, 14);

    }

    public static void twoSum(int[] arr, int target) {
        int start = 0;
        int end = arr.length - 1;

        while (start < end) {
            int sum = arr[start] + arr[end];
            if (sum == target) {
                System.out.println("two indices are: " + start + " " + end);
                break;
            } else if (sum < target) {
                start++;
            } else {
                end--;
            }
        }
    }

    public static int[] bubbleSort(int[] arr) {
        int n = arr.length;

        for (int pass = 0; pass < n - 1; pass++) {
            for (int i = 0; i < n - 1 - pass; i++) {
                if (arr[i] > arr[i + 1]) {
                    int temp = arr[i];
                    arr[i] = arr[i + 1];
                    arr[i + 1] = temp;
                }
            }
        }
        return arr;
    }
}
/*
 * HashMap Two Sum:
 * Time: O(n) average
 * Space: O(n)
 * 
 * Bubble Sort + Two Pointers:
 * Time: O(n^2) overall
 * Space: O(1) auxiliary
 * 
 * Tradeoff:
 * HashMap is faster on average but uses extra memory.
 * The sorting approach uses less auxiliary memory, but bubble sort
 * makes it slower. With an efficient O(n log n) sorting algorithm,
 * the sorting approach takes O(n log n) overall.
 */