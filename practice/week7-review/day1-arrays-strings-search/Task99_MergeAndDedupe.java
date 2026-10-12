// Given two arrays, already sorted: {1,3,5,7,9} and {2,3,5,8,10} — merge them into a single sorted array with no duplicate 
// values. Don’t convert to a Set and sort again — use the two-pointer merge technique from your Week 2 merge-sorted-arrays 
// task, adapted to skip duplicates as you go.

public class Task99_MergeAndDedupe {
    public static void main(String[] args) {
        int[] arr1 = { 1, 2, 2, 4, 6, 6, 8 };
        int[] arr2 = { 2, 3, 4, 4, 6, 7, 8 };
        mergeSortedArray(arr1, arr2);

    }

    public static void mergeSortedArray(int[] arr1, int[] arr2) {
        int[] merged = new int[arr1.length + arr2.length];
        int i = 0, j = 0, k = 0;

        while (i < arr1.length && j < arr2.length) {
            int value;
            if (arr1[i] <= arr2[j]) {
                value = arr1[i];
                i++;
            } else {
                value = arr2[j];
                j++;
            }

            if (k == 0 || merged[k - 1] != value) {
                merged[k] = value;
                k++;
            }

        }

        while (i < arr1.length) {
            int value = arr1[i++];
            if (k == 0 || merged[k - 1] != value) {
                merged[k] = value;
            }
        }

        while (j < arr2.length) {
            int value = arr2[j++];
            if (k == 0 || merged[k - 1] != value) {
                merged[k] = value;
            }
        }

        for (int index = 0; index < k; index++) {
            System.out.print(merged[index] + " ");
        }

        // for (int num : merged) {
        // System.out.print(num + " ");
        // }
    }

    public static int removeDuplicates(int[] arr) {
        if (arr.length == 0) {
            return 0;
        }

        int j = 0;

        for (int i = 1; i < arr.length; i++) {
            if (arr[i] != arr[j]) {
                j++;
                arr[j] = arr[i];
            }
        }

        return j + 1;
    }

}
