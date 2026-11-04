// question link: https://leetcode.com/problems/minimum-moves-to-equal-array-elements-ii/description/
// question difficulty: Medium
// description: Given an integer array nums of size n, return the minimum number of moves required to make all array elements equal.
// In one move, you can increment or decrement an element of the array by 1.
// Test cases are designed so that the answer will fit in a 32-bit integer.

/*

Example 1:

Input: nums = [1,2,3]
Output: 2
Explanation:
Only two moves are needed (remember each move increments or decrements one element):
[1,2,3]  =>  [2,2,3]  =>  [2,2,2]
Example 2:

Input: nums = [1,10,2,9]
Output: 16
 
*/
// approach: here we can increment or decrement an element. so first we can sort the array. from there we can get the mid element of the array. and then for the element 
// lesser then mid we can count no. of jumps(diff) and for geater element we can subtract and add the diff to the count. the reason this works is because we can both 
// increment and decrement the elements. if we choose the smaller target or a larger target then the median, the totoal distance travlled by all the elements increases 
// or remains the same. 
// the median balances the numbers of elements on both the sides, minimizing the sum of absolute differences.  

import java.util.Arrays;

class Solution {
    public int minMoves2(int[] nums) {
        Arrays.sort(nums);

        int start = 0;
        int end = nums.length - 1;
        int mid = start + (end - start) / 2;
        int count = 0;

        for (int i = 0; i < nums.length; i++) {
            if (nums[i] < nums[mid]) {
                int diff = nums[mid] - nums[i];
                count += diff;
            }

            if (nums[i] > nums[mid]) {
                int diff = nums[i] - nums[mid];
                count += diff;
            }
        }

        return count;
    }

}