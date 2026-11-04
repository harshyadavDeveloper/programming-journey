// question link: https://leetcode.com/problems/find-missing-elements/description/?envType=daily-question&envId=2026-08-14
// question difficulty: Easy
// description: You are given an integer array nums consisting of unique integers.
// Originally, nums contained every integer within a certain range. However, some integers might have gone missing from the array.
// The smallest and largest integers of the original range are still present in nums.
// Return a sorted list of all the missing integers in this range. If no integers are missing, return an empty list.

/*
Example 1:
Input: nums = [1,4,2,5]
Output: [3]
Explanation:
The smallest integer is 1 and the largest is 5, so the full range should be [1,2,3,4,5]. Among these, only 3 is missing.
Example 2:
Input: nums = [7,8,6,9]
Output: []
Explanation:
The smallest integer is 6 and the largest is 9, so the full range is [6,7,8,9]. All integers are already present, so no integer is missing.

*/

// approach: find the max and min values from the arr, mark every number that exists and then collect the numbers between the minimum and maximum that were never marked.

import java.util.ArrayList;
import java.util.List;

class Solution {
    public List<Integer> findMissingElements(int[] nums) {
        if (nums.length == 0) {
            return new ArrayList<>();
        }
        int n = nums.length;
        int min = nums[0];
        int max = nums[0];
        List<Integer> result = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            if (nums[i] < min) {
                min = nums[i];
            }

            if (nums[i] > max) {
                max = nums[i];
            }
        }

        boolean[] seen = new boolean[max + 1];
        for (int num : nums) {
            seen[num] = true;
        }

        for (int i = min; i <= max; i++) {
            if (!seen[i]) {
                result.add(i);
            }
        }
        return result;

    }

}