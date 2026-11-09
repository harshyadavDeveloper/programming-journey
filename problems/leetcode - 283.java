// question link: https://leetcode.com/problems/move-zeroes/description/
// question difficulty: Easy
// description: Given an integer array nums, move all 0's to the end of it while
// maintaining the relative order of the non-zero elements.
// Note that you must do this in-place without making a copy of the array.

/*
 * Example 1:
 * 
 * Input: nums = [0,1,0,3,12]
 * Output: [1,3,12,0,0]
 * Example 2:
 * 
 * Input: nums = [0]
 * Output: [0]
 */

// approach: here we have an interPos variable that starts from 0.
// Then loop through the array, and wherever there is a non-zero element,
// place that element at the interPos index by swapping nums[i] with nums[interPos].
// After placing the non-zero element, increment interPos so that it points
// to the next available position for a non-zero element.
//
// This way, all non-zero elements are moved to the beginning of the array
// while maintaining their relative order. The remaining positions
// automatically contain zeroes.

class Solution {
    public void moveZeroes(int[] nums) {
        int interPos = 0;

        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != 0) {
                int temp = nums[i];
                nums[i] = nums[interPos];
                interPos++;
            }
        }

    }
}