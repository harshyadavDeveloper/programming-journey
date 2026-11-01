import java.util.ArrayList;
import java.util.List;
// question link: https://leetcode.com/problems/kids-with-the-greatest-number-of-candies/
// question difficulty: Easy
// description: There are n kids with candies. You are given an integer array candies, where each candies[i] represents the number of candies the ith kid has, and an integer extraCandies, denoting the number of extra candies that you have.
// Return a boolean array result of length n, where result[i] is true if, after giving the ith kid all the extraCandies, they will have the greatest number of candies among all the kids, or false otherwise.
// Note that multiple kids can have the greatest number of candies.

// approach 1: Nested loop: Time Complexity: 0(n²)
// For each kid, add the extra candies to their current candies and compare 
// the resulting total with every other kid's candies. If the kid has at 
// least as many candies as everyone else, add true to the result list; 
// otherwise, add false. This approach uses nested loops, resulting in O(n²) 
// time complexity.

class Solution {
    public List<Boolean> kidsWithCandies(int[] candies, int extraCandies) {
        List<Boolean> max = new ArrayList<>();

        for (int i = 0; i < candies.length; i++) {
            int sum = candies[i] + extraCandies;
            boolean isMax = false;
            for (int j = 0; j < candies.length; j++) {
                if (i == j) {
                    continue;
                }
                if (sum >= candies[j]) {
                    isMax = true;
                } else {
                    isMax = false;
                    break;
                }

            }
            // if (isMax) {
            // max.add(true);
            // } else {
            // max.add(false);
            // }
            max.add(isMax);

        }

        return max;
    }

    public List<Boolean> kidsWithCandies2(int[] candies, int extraCandies) {
        List<Boolean> max = new ArrayList<>();

        int maxCandies = candies[0];
        for (int i = 0; i < candies.length; i++) {
            if (candies[i] > maxCandies) {
                maxCandies = candies[i];
            }

        }

        for (int i = 0; i < candies.length; i++) {
            if ((candies[i] + extraCandies) >= maxCandies) {
                max.add(true);
            } else {
                max.add(false);
            }
        }
        return max;
    }
}

class Main {
    public static void main(String[] args) {
        Solution solution = new Solution();
        // Test Case 1
        int[] candies1 = { 2, 3, 5, 1, 3 };
        int extraCandies1 = 3;
        System.out.println(solution.kidsWithCandies2(candies1, extraCandies1));
        // Expected: [true, true, true, false, true]

        // Test Case 2
        int[] candies2 = { 4, 2, 1, 1, 2 };
        int extraCandies2 = 1;
        System.out.println(solution.kidsWithCandies2(candies2, extraCandies2));
        // Expected: [true, false, false, false, false]

        // Test Case 3
        int[] candies3 = { 12, 1, 12 };
        int extraCandies3 = 10;
        System.out.println(solution.kidsWithCandies2(candies3, extraCandies3));
        // Expected: [true, false, true]

        // Test Case 4: All kids have equal candies
        int[] candies4 = { 5, 5, 5 };
        int extraCandies4 = 0;
        System.out.println(solution.kidsWithCandies2(candies4, extraCandies4));
        // Expected: [true, true, true]

        // Test Case 5: Single kid
        int[] candies5 = { 3 };
        int extraCandies5 = 2;
        System.out.println(solution.kidsWithCandies2(candies5, extraCandies5));
        // Expected: [true]
    }
}