import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;
import java.util.concurrent.ThreadLocalRandom;

class Main {
    static Map<String, Boolean> voted = new HashMap<>(); // for chapter 5: hashtables

    public static void main(String[] args) {
        // int[] arr = { 1, 4, 6, 7, 9, 10 };
        // int target = 4;
        // System.out.println(binarySearch(arr, target));
        // int[] arr = { 10, 20, 30, 40, 50 };

        // System.out.println(countArray(arr, 0)); // 5
        // int[] arr = { 3, 9, 2, 15, 6 };
        // int result = findMax(arr, 0);
        // System.out.println("Maximum element: " + result);
        // int[] arr = { 2, 5, 8, 12, 16, 23, 38, 56 };
        // int target = 23;
        // int result = recursiveBinarySearch(arr, 0, arr.length - 1, target);
        // System.out.println("Target index: " + result);
        // int[] arr = { 8, 3, 5, 1, 9, 2, 7 };

        // quicksort(arr, 0, arr.length - 1);

        // System.out.println(Arrays.toString(arr));
        System.out.println(createSocialNetworkGraph());

    }

    public static int binarySearch(int[] arr, int target) { // [1,2,3,4,5,6] 6
        if (arr.length == 0) {
            return -1;
        }
        int foundIndex = -1;
        int low = 0;
        int high = arr.length - 1;

        while (low <= high) {
            int mid = (low + high) / 2;
            if (arr[mid] == target) {
                foundIndex = mid;
                break;
            } else if (target < arr[mid]) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }

        }

        return foundIndex;

    }

    public static int minIndex(int[] arr, int start) {
        int minIndex = start;

        for (int i = start + 1; i < arr.length; i++) {
            if (arr[i] < arr[minIndex]) {
                minIndex = i;
            }

        }
        return minIndex;
    }

    public static int[] selectionSort(int[] arr) {
        int[] sorted = arr.clone();
        int n = sorted.length;

        for (int i = 0; i < n - 1; i++) {
            int min = minIndex(sorted, i);

            int temp = sorted[i];
            sorted[i] = sorted[min];
            sorted[min] = temp;
        }
        return sorted;
    }

    public static int fact(int num) {
        if (num < 0) {
            throw new IllegalArgumentException("factorial undefined for negatives");
        }
        if (num == 0 || num == 1) {
            return 1;
        }

        return num * fact(num - 1);
    }

    // Chapter 4: quicksort
    // 4.1: Write out the code for the earlier sum function
    public static int sumArray(int[] arr, int index) {
        // stop if we reached the end of the array(index == arr.length) because before
        // accessing invalid index we return with 0
        if (index == arr.length) {
            return 0;
        }
        // increment the index until we reach the end of the array
        return arr[index] + sumArray(arr, index + 1);

    }

    // 4.2 Write a recursive function to count the number of items in a list.
    public static int countArray(int[] arr, int index) {
        // stop when the we reach beyound valid indice
        if (index == arr.length) {
            return 0;
        }
        // increment index till we reach the base. add 1 because index starts at 0
        return 1 + countArray(arr, index + 1);
    }

    // 4.3 Write a recursive function to find the maximum number in a list.
    public static int findMax(int[] arr, int index) {
        // if arr has only 1 element then it is the maximun
        if (index == arr.length - 1) {
            return arr[index];
        }

        int remainingMax = findMax(arr, index + 1); // find the max
        if (arr[index] > remainingMax) {
            return arr[index];
        } else {
            return remainingMax;
        }
    }

    // 4.4 Remember binary search from chapter 1? It’s a D&C algorithm, too. Can you
    // come up with the base case and recursive case for binary search?
    public static int recursiveBinarySearch(int[] arr, int start, int end, int target) {
        if (start > end) {
            return -1; // target not present in the arr
        }
        int mid = (start + end) / 2;
        if (arr[mid] == target) {
            return mid;
        }
        // based on the condition go towards base cases.
        if (arr[mid] < target) {
            return recursiveBinarySearch(arr, mid + 1, end, target);
        } else {
            return recursiveBinarySearch(arr, start, mid - 1, target);
        }
    }
    // theory questions:
    // How long would each of these operations take in big O notation?
    // 4.5 Printing the value of each element in an array: O(n). because it go thru
    // all the element once.

    // 4.6 Doubling the value of each element in an array: O(n) for same reason as
    // above:

    // 4.7 Doubling the value of just the first element in an array: O(1) — Only the
    // first element is accessed and doubled, so the operation takes constant time
    // regardless of the array's size.

    // 4.8 Creating a multiplication table with all the elements in the array. So
    // if your array is [2, 3, 7, 8, 10], you first multiply every element by 2,
    // then multiply every element by 3, then by 7, and so on: O(n²) — For each of
    // the n elements, we iterate through all n elements again to create the
    // multiplication table, resulting in n × n operations.

    // Implemention of quick sort Divide and rule:
    public static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    public static int partition(int[] arr, int low, int high) {
        int randomIndex = ThreadLocalRandom.current().nextInt(low, high + 1);

        // move the random pivot to the end
        swap(arr, randomIndex, high);
        int pivot = arr[high];
        int i = low;
        for (int j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                swap(arr, i, j);
                i++;
            }
        }
        // Place the pivot in its final position.
        swap(arr, i, high);
        return i;
    }

    public static void quicksort(int[] arr, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(arr, low, high);

            quicksort(arr, low, pivotIndex - 1);
            quicksort(arr, pivotIndex + 1, high);
        }
    }

    // if using in build function is not allowed
    public static int getPivotIndex(int low, int high) {
        return low + (high - low) / 2;
    }

    // Chapter 5: HashTables(HashMap)
    public static void chapter5() {
        Map<String, Integer> ages = new HashMap<>();
        ages.put("Ravi", 24);
        ages.put("Pooja", 23);
        System.out.println(ages.get("Ravi"));
    }
    // It’s important for hash functions to consistently return the same output
    // for the same input. If they don’t, you won’t be able to find your item
    // after you put it in the hash table!

    // Which of these hash functions are consistent?
    // 5.1 f(x) = 1 Returns 1 for all input
    // Consistent. because the same input will produce same hash value, it doesnt
    // matter if the same input will always produces same hash values. Thats an
    // collision not and inconsistency

    // 5.2 f(x) = random.random() Returns a random number every time
    // Inconsistent. becasue it return random number everytime so it will produce
    // different hash values for same input everytime

    // 5.3 f(x) = next_empty_slot() Returns the index of the next
    // Inconsistent. It returns the index of the next available empty slot. Even
    // though the input is "Ravi" both times, it returns different indices because
    // the next empty slot changes. A hash function should calculate the index based
    // on the input key, not on which slot happens to be empty next.
    // Consistent. It uses the length of the input string as the index. The same
    // input "Ravi" always produces 4.
    public static void voteSystem(String name) {

        if (voted.containsKey(name)) {
            System.out.println("Kick them out! Already voted.");
        } else {
            voted.put(name, true);
            System.out.println("You can vote!");
        }
    }
    // 5.4 If we use these four different hash functions to store strings in a hash
    // table of size 10, which one distributes the strings across the 10 slots most
    // effectively?
    // 1. Always return 1 -> Everything goes into one slot -> Very Bad
    // 2. String length -> Strings of equal length collide -> Poor
    // 3. First character -> Strings with the same starting character collide ->
    // Poor
    // 4. Sum of prime values % 10 -> Considers all characters -> Best among these
    // four

    // 5.5 A phonebook where the keys are names and values are phone
    // numbers. The names are as follows: Esther, Ben, Bob, and Dan.
    // best answer for this will be option 4

    // 5.6 A mapping from battery size to power. The sizes are A, AA, AAA,
    // and AAAA.
    // best answer is function 2 and 4

    // 5.7 A mapping from book titles to authors. The titles are Maus, Fun
    // Home, and Watchmen.
    // best answer is function 3 and 4

    // Chapter 6: Breadth First Search
    // 6.1 Find the length of the shortest path from start to finish.(refer the
    // diagram in the diagrams folder)
    // Possible Paths:
    // 1. S → A → F (2 edges)
    // 2. S → B → D → F (3 edges)
    // Shortest path: S → A → F
    // Shortest path length: 2

    // 6.2 Find the length of the shortest path from cab to bat.
    // Possible Paths:
    // 1. cab -> cat -> mat -> bat (3 edges)
    // 2. cab -> cat -> bat (2 edges)
    // 3. cab -> car -> cat -> mat -> bat (4 edges)
    // 4. cab -> car -> bar -> bat (3 edges)
    // Shortest path: cab -> cat -> bat
    // shortes path length: 2
    public static Map<String, List<String>> createSocialNetworkGraph() {
        Map<String, List<String>> graph = new HashMap<>();

        graph.put("you", Arrays.asList("alice", "bob", "claire"));
        graph.put("bob", Arrays.asList("anuj", "peggy"));
        graph.put("alice", Arrays.asList("rekha"));
        graph.put("claire", Arrays.asList("thom", "jonny"));

        graph.put("anuj", new ArrayList<>());
        graph.put("peggy", new ArrayList<>());
        graph.put("rekha", new ArrayList<>());
        graph.put("thom", new ArrayList<>());
        graph.put("jonny", new ArrayList<>());

        return graph;

    }

    public static boolean findMangoSeller(Map<String, List<String>> friendsList) {
        Queue<String> searchQueue = new LinkedList<>();
        Set<String> searched = new HashSet<>();
        searchQueue.addAll(friendsList.get("you"));

        while (!searchQueue.isEmpty()) {
            String person = searchQueue.poll();
            if (!searched.contains(person)) {
                searched.add(person);
                if (isMangoSeller(person)) {
                    return true;
                } else {
                    searchQueue.addAll(friendsList.get(person));
                }
            }

        }
        return false;

    }

    public static boolean isMangoSeller(String name) {
        return name.endsWith("m");
    }

    // Chapter 10: Greedy Algorithm
    // 10.1: You work for a furniture company, and you have to ship furniture
    // all over the country. You need to pack your truck with boxes. All
    // the boxes are of different sizes, and you’re trying to maximize
    // the space you use in each truck. How would you pick boxes to
    // maximize space? Come up with a greedy strategy. Will that give
    // you the optimal solution?
    // answer: Sort all boxes in descending order of size. Repeatedly select the
    // largest box that fits into the remaining truck capacity until no more boxes
    // can fit.
    // Will it produce the optimal solution?
    // No. Choosing the largest box first does not guarantee maximum space
    // utilization. A combination of smaller boxes might fill the truck more
    // efficiently.
    // For example, with a truck capacity of 10 and boxes of sizes 6, 5, and 5, the
    // greedy algorithm selects 6, leaving 4 units unused. However, selecting both
    // boxes of size 5 fills the truck completely.
    // Therefore, this greedy strategy does not guarantee an optimal solution.

    // 10.2: You’re going to Europe, and you have seven days to see everything
    // you can. You assign a point value to each item (how much you want to see it)
    // and estimate how long it takes. How can you
    // maximize the point total (seeing all the things you really want to
    // see) during your stay? Come up with a greedy strategy. Will that
    // give you the optimal solution?
    // answer: Calculate how many points each attraction offers per day. Sort the
    // attractions from highest to lowest and select them in that order, skipping
    // any attraction that doesn't fit within the remaining seven days.
    // Will it give the optimal solution?
    // No. Although this strategy selects attractions that offer the most points per
    // day individually, it doesn't consider how different attractions combine. A
    // combination of attractions with lower individual ratios might give a higher
    // total score.
    // Therefore, the greedy approach does not guarantee an optimal solution.

    // Greedy Approximation Algorithm - Radio Station Problem
    public static Set<String> selectRadioStationsGreedy() {

        Set<String> statesNeeded = new HashSet<>(Arrays.asList(
                "mt", "wa", "or", "id", "nv", "ut", "ca", "az"));

        Map<String, Set<String>> stations = new HashMap<>();

        stations.put("kone", new HashSet<>(Arrays.asList("id", "nv", "ut")));
        stations.put("ktwo", new HashSet<>(Arrays.asList("wa", "id", "mt")));
        stations.put("kthree", new HashSet<>(Arrays.asList("or", "nv", "ca")));
        stations.put("kfour", new HashSet<>(Arrays.asList("nv", "ut")));
        stations.put("kfive", new HashSet<>(Arrays.asList("ca", "az")));

        Set<String> finalStations = new HashSet<>();

        // Repeat until all states are covered
        while (!statesNeeded.isEmpty()) {

            String bestStation = null;
            Set<String> statesCovered = new HashSet<>();

            // Find the station covering the most uncovered states
            for (Map.Entry<String, Set<String>> entry : stations.entrySet()) {

                String station = entry.getKey();
                Set<String> statesForStation = entry.getValue();

                Set<String> covered = new HashSet<>(statesNeeded);
                covered.retainAll(statesForStation);

                if (covered.size() > statesCovered.size()) {
                    bestStation = station;
                    statesCovered = covered;
                }
            }

            // Prevent an infinite loop if some states cannot be covered
            if (bestStation == null) {
                throw new IllegalStateException(
                        "Cannot cover remaining states: " + statesNeeded);
            }

            // Add the selected station
            finalStations.add(bestStation);

            // Remove states that are now covered
            statesNeeded.removeAll(statesCovered);
        }

        return finalStations;
    }
}