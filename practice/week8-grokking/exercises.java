import java.util.Arrays;
import java.util.concurrent.ThreadLocalRandom;

class Main {
    public static void main(String[] args) {
        // int[] arr = { 1, 4, 6, 7, 9, 10 };
        // int target = 4;
        // System.out.println(binarySearch(arr, target));
        // int[] arr = { 10, 20, 30, 40, 50 };

        // System.out.println(countArray(arr, 0)); // 5
        // int[] arr = { 3, 9, 2, 15, 6 };
        // int result = findMax(arr, 0);
        // System.out.println("Maximum element: " + result);
        // int[] arr = { 2, 5, 8, 12, 16, 23, 38, 56 };
        // int target = 23;
        // int result = recursiveBinarySearch(arr, 0, arr.length - 1, target);
        // System.out.println("Target index: " + result);
        int[] arr = { 8, 3, 5, 1, 9, 2, 7 };

        quicksort(arr, 0, arr.length - 1);

        System.out.println(Arrays.toString(arr));

    }

    public static int binarySearch(int[] arr, int target) { // [1,2,3,4,5,6] 6
        if (arr.length == 0) {
            return -1;
        }
        int foundIndex = -1;
        int low = 0;
        int high = arr.length - 1;

        while (low <= high) {
            int mid = (low + high) / 2;
            if (arr[mid] == target) {
                foundIndex = mid;
                break;
            } else if (target < arr[mid]) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }

        }

        return foundIndex;

    }

    public static int minIndex(int[] arr, int start) {
        int minIndex = start;

        for (int i = start + 1; i < arr.length; i++) {
            if (arr[i] < arr[minIndex]) {
                minIndex = i;
            }

        }
        return minIndex;
    }

    public static int[] selectionSort(int[] arr) {
        int[] sorted = arr.clone();
        int n = sorted.length;

        for (int i = 0; i < n - 1; i++) {
            int min = minIndex(sorted, i);

            int temp = sorted[i];
            sorted[i] = sorted[min];
            sorted[min] = temp;
        }
        return sorted;
    }

    public static int fact(int num) {
        if (num < 0) {
            throw new IllegalArgumentException("factorial undefined for negatives");
        }
        if (num == 0 || num == 1) {
            return 1;
        }

        return num * fact(num - 1);
    }

    // Chapter 4: quicksort
    // 4.1: Write out the code for the earlier sum function
    public static int sumArray(int[] arr, int index) {
        // stop if we reached the end of the array(index == arr.length) because before
        // accessing invalid index we return with 0
        if (index == arr.length) {
            return 0;
        }
        // increment the index until we reach the end of the array
        return arr[index] + sumArray(arr, index + 1);

    }

    // 4.2 Write a recursive function to count the number of items in a list.
    public static int countArray(int[] arr, int index) {
        // stop when the we reach beyound valid indice
        if (index == arr.length) {
            return 0;
        }
        // increment index till we reach the base. add 1 because index starts at 0
        return 1 + countArray(arr, index + 1);
    }

    // 4.3 Write a recursive function to find the maximum number in a list.
    public static int findMax(int[] arr, int index) {
        // if arr has only 1 element then it is the maximun
        if (index == arr.length - 1) {
            return arr[index];
        }

        int remainingMax = findMax(arr, index + 1); // find the max
        if (arr[index] > remainingMax) {
            return arr[index];
        } else {
            return remainingMax;
        }
    }

    // 4.4 Remember binary search from chapter 1? It’s a D&C algorithm, too. Can you
    // come up with the base case and recursive case for binary search?
    public static int recursiveBinarySearch(int[] arr, int start, int end, int target) {
        if (start > end) {
            return -1; // target not present in the arr
        }
        int mid = (start + end) / 2;
        if (arr[mid] == target) {
            return mid;
        }
        // based on the condition go towards base cases.
        if (arr[mid] < target) {
            return recursiveBinarySearch(arr, mid + 1, end, target);
        } else {
            return recursiveBinarySearch(arr, start, mid - 1, target);
        }
    }
    // theory questions:
    // How long would each of these operations take in big O notation?
    // 4.5 Printing the value of each element in an array: O(n). because it go thru
    // all the element once.

    // 4.6 Doubling the value of each element in an array: O(n) for same reason as
    // above:

    // 4.7 Doubling the value of just the first element in an array: O(1) — Only the
    // first element is accessed and doubled, so the operation takes constant time
    // regardless of the array's size.

    // 4.8 Creating a multiplication table with all the elements in the array. So
    // if your array is [2, 3, 7, 8, 10], you first multiply every element by 2,
    // then multiply every element by 3, then by 7, and so on: O(n²) — For each of
    // the n elements, we iterate through all n elements again to create the
    // multiplication table, resulting in n × n operations.

    // Implemention of quick sort Divide and rule:
    public static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    public static int partition(int[] arr, int low, int high) {
        int randomIndex = ThreadLocalRandom.current().nextInt(low, high + 1);

        // move the random pivot to the end
        swap(arr, randomIndex, high);
        int pivot = arr[high];
        int i = low;
        for (int j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                swap(arr, i, j);
                i++;
            }
        }
        // Place the pivot in its final position.
        swap(arr, i, high);
        return i;
    }

    public static void quicksort(int[] arr, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(arr, low, high);

            quicksort(arr, low, pivotIndex - 1);
            quicksort(arr, pivotIndex + 1, high);
        }
    }

    // if using in build function is not allowed
    public static int getPivotIndex(int low, int high) {
        return low + (high - low) / 2;
    }
}