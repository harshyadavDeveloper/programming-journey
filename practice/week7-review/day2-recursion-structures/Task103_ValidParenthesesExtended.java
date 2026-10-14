// Extend your Week 4 valid-parentheses stack solution to handle three bracket types: (), {}, []. Test on "{[()]}" 
// (valid) and "{[(])}" (invalid — interleaved, not nested).

import java.util.Stack;

public class Task103_ValidParenthesesExtended {
    public static void main(String[] args) {
        System.out.println("IS the first one valid " + isValid("{[()]}"));
        System.out.println("IS the first one valid " + isValid("{[(])}"));

    }

    public static boolean isValid(String word) {
        if (word.isEmpty()) {
            return true;
        }
        Stack<Character> stack = new Stack<>();

        for (int i = 0; i < word.length(); i++) {
            char curr = word.charAt(i);

            if (curr == '(' || curr == '{' || curr == '[') {
                stack.add(curr);
            } else if (curr == ')' || curr == '}' || curr == ']') {
                if (stack.isEmpty()) {
                    return false;
                }

                char top = stack.peek();
                if (curr == ')' && top != '(') {
                    return false;
                } else if (curr == '}' && top != '{') {
                    return false;
                } else if (curr == ']' && top != '[') {
                    return false;
                }
                stack.pop();
            }
        }

        return stack.isEmpty();

    }
}
