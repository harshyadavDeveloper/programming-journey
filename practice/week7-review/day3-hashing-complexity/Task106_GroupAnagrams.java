
// Given an array of strings, group all anagrams together (e.g. "eat", "tea", "tan", "ate", "nat", "bat" → 
// [eat,tea,ate], [tan,nat], [bat]). Use a HashMap where the key represents “same letters” — figure out what to use 
// as that key.
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class Task106_GroupAnagrams {
    public static void main(String[] args) {
        String[] words = { "eat", "tea", "tan", "ate", "nat", "bat" };

        List<List<String>> result = groupAnagrams(words);

        System.out.println(result);
    }

    public static List<List<String>> groupAnagrams(String[] words) {
        Map<String, List<String>> map = new HashMap<>();
        for (String word : words) {
            char[] chars = word.toCharArray();
            Arrays.sort(chars);
            String key = new String(chars);

            map.putIfAbsent(key, new ArrayList<>());
            map.get(key).add(word);
        }
        return new ArrayList<>(map.values());
    }
}
