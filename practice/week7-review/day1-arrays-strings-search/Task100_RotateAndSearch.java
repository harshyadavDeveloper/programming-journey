// Take array {15,18,2,3,6,12} (a sorted array rotated at some unknown pivot — you did this exact shape in Week 3 Day 7). Search 
// for value 3 in it in O(log n) time. Don’t just linear scan — use the modified binary search that handles rotation.
public class Task100_RotateAndSearch {
    public static void main(String[] args) {
        int[] arr = { 15, 18, 2, 3, 6, 12 };
        binarySearch(arr, 99);

    }

    public static void binarySearch(int[] arr, int target) {
        int start = 0;
        int end = arr.length - 1;
        int found = -1;

        while (start <= end) {
            int mid = start + (end - start) / 2;
            if (target == arr[mid]) {
                found = mid;
                break;
            }

            if (arr[start] <= arr[mid]) { // left is sorted
                if (target >= arr[start] && target < arr[mid]) {
                    end = mid - 1;

                } else {
                    start = mid + 1;
                }

            } else {
                if (target > arr[mid] && target <= arr[end]) {
                    start = mid + 1;
                } else {
                    end = mid - 1;
                }
            }

        }
        if (found == -1) {
            System.out.println("Not present in the array");
        } else {
            System.out.println("Found target at index: " + found);
        }
    }

}
