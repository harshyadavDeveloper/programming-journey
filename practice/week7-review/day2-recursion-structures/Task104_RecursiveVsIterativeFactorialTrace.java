// Write factorial both recursively and iteratively. For factorial(5), trace the recursive version’s call stack by 
// hand — write out each frame waiting to return, then compare against the iterative version’s single loop. Comment 
// on which one actually uses more memory and why.

public class Task104_RecursiveVsIterativeFactorialTrace {
    public static void main(String[] args) {

        int factorials = factorialRecursive(5);
        System.out.println(factorials);

    }

    public static int factorial(int num) {
        if (num == 0) {
            return 1;
        }
        int fact = 1;

        for (int i = 1; i <= num; i++) {
            fact *= i;
        }

        return fact;
    }

    public static int factorialRecursive(int num) {
        if (num == 0 || num == 1) {
            return 1;
        }

        return num * factorialRecursive(num - 1);
    }

    /*
     * iterative menthod used O(1) memory and recursion uses O(n) memory because
     * each call creates a stack which remains active until the base
     * case returns. Therefore the recursive version uses more memory than the
     * iterative one.
     * 
     */

}
