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
}