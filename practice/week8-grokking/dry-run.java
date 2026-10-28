class Main {
    public static void main(String[] args) {
        int[] arr = { 1, 4, 6, 7, 9, 10 };
        int target = 4;
        System.out.println(binarySearch(arr, target));

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
}