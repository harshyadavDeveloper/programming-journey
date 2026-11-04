// Question Link: https://leetcode.com/problems/successful-pairs-of-spells-and-potions/description/?envType=daily-question&envId=2025-10-09
// Question Number : 2300
// Difficulty Level : Medium
// Description: You are given two positive integer arrays spells and potions, of length n and m respectively, where spells[i] represents the strength of the ith spell and potions[j] represents the strength of the jth potion.
// You are also given an integer success. A spell and potion pair is considered successful if the product of their strengths is at least success.
// Return an integer array pairs of length n where pairs[i] is the number of potions that will form a successful pair with the ith spell
// Example 1: Input: spells = [5,1,3], potions = [1,2,3,4,5], success = 7
//            Output: [4,0,3]
//            Explanation:
// - 0th spell: 5 * [1,2,3,4,5] = [5,10,15,20,25]. 4 pairs are successful.
// - 1st spell: 1 * [1,2,3,4,5] = [1,2,3,4,5]. 0 pairs are successful.
// - 2nd spell: 3 * [1,2,3,4,5] = [3,6,9,12,15]. 3 pairs are successful.
//   Thus, [4,0,3] is returned.

// approach 1: brute force approach. traverse the spells array and for each spell traverse the potions array and check if the product of spell and potion is greater than or equal to success. if yes increment the count. finally add the count to the result array
// time complexity : O(n*m)
// space complexity : O(n)

// approach 2: sort the potions array and for each spell use binary search to find the first potion which when multiplied with the spell gives a product greater than or equal to success. the number of successful pairs will be the total number of potions minus the index of the first successful potion
// time complexity : O(m log m + n log m) where m is the length of potions array and n is the length of spells array
// space complexity : O(1)

import java.util.Arrays;

class Solution {
    public int[] successfullPairs(int[] spells, int[] potions, long success) {
        int n = spells.length;
        int m = potions.length;
        int[] result = new int[n];

        for (int i = 0; i < n; i++) {
            int count = 0;
            for (int j = 0; j < m; j++) {
                long product = (long) spells[i] * (long) potions[j];
                if (product >= success) {
                    count++;
                }

            }
            result[i] = count;
        }

        return result;
    }

    public int[] successfulPairs2(int[] spells, int[] potions, long success) {
        int n = spells.length;
        int m = potions.length;
        int[] pairs = new int[n];
        Arrays.sort(potions);

        for (int i = 0; i < n; i++) {
            int s = spells[i];
            int left = 0, right = m - 1;
            while (left <= right) {
                int mid = (left + right) / 2;
                long product = (long) potions[mid] * s;
                if (product >= success) {
                    right = mid - 1;
                } else {
                    left = mid + 1;
                }

            }
            pairs[i] = m - left;

        }
        return pairs;
    }
}
