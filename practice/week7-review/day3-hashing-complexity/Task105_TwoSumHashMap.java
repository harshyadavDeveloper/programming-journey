// Given an unsorted array and a target sum, return the indices of two numbers that add up to the target — using a 
// HashMap in a single pass (not nested loops). State the Big-O of your solution and compare it to the brute-force 
// nested-loop version you’d have written in Week 1.

import java.util.HashMap;

public class Task105_TwoSumHashMap {
    public static void main(String[] args) {
        int[] arr = { 12, 18, 15, 9, 4, 10 };
        int target = 30;
        twoSumHashMap(arr, target);
    }

    public static void twoSumHashMap(int[] arr, int target) {
        HashMap<Integer, Integer> map = new HashMap<>();

        for (int i = 0; i < arr.length; i++) {
            int complement = target - arr[i];
            if (map.containsKey(complement)) {
                System.out.println("Two Indices are: " + complement + " " + arr[i]);
                break;
            }
            map.put(arr[i], i);
        }
    }

}
