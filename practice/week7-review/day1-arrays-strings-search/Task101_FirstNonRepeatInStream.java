
// Given a string, find the first character that does not repeat, but do it using a frequency approach (Week 2), then separately 
// re-derive it using a HashMap (Week 5) preserving insertion order — compare the two approaches and note in a comment which one 
// is cleaner and why.
import java.util.HashMap;
import java.util.LinkedHashMap;

public class Task101_FirstNonRepeatInStream {
    public static void main(String[] args) {
        String word = "aatish";
        // frequency(word);
        mapFreq(word);

    }

    public static void frequency(String word) {
        if (word.length() == 0) {
            return;
        }
        int[] freq = new int[26];

        for (int i = 0; i < word.length(); i++) {
            char c = word.charAt(i);
            int index = c - 'a';
            freq[index]++;
        }

        for (int i = 0; i < word.length(); i++) {
            char c = word.charAt(i);
            int index = c - 'a';
            if (freq[index] == 1) {
                System.out.println(c + ": " + freq[index]);
                break;
            }
        }
    }

    public static void mapFreq(String word) {
        HashMap<Character, Integer> frequencies = new LinkedHashMap<>();

        for (int i = 0; i < word.length(); i++) {
            char c = word.charAt(i);
            frequencies.put(c, frequencies.getOrDefault(c, 0) + 1);
        }

        // System.out.println(frequencies);
        for (char c : frequencies.keySet()) {
            if (frequencies.get(c) == 1) {
                System.out.println(c + ": " + frequencies.get(c));
                break;

            }
        }
    }

}
