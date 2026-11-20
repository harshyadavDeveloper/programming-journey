import java.util.*;

class DijkstraAlgorithm {
    public static String findLowestCost(Map<String, Long> costs, Set<String> processed) {
        long lowestCost = Long.MAX_VALUE;
        String lowestNode = null;

        for (Map.Entry<String, Long> entry : costs.entrySet()) {
            long currentCost = entry.getValue();
            String currentNode = entry.getKey();

            if (currentCost < lowestCost && !processed.contains(currentNode)) {
                lowestCost = currentCost;
                lowestNode = currentNode;
            }

        }
        return lowestNode;
    }

    public static void main(String[] args) {
        // 1. Create graph
        Map<String, Map<String, Long>> graph = new HashMap<>();

        graph.put("start", new HashMap<>());
        graph.put("A", new HashMap<>());
        graph.put("B", new HashMap<>());
        graph.put("fin", new HashMap<>());

        graph.get("start").put("A", 6L);
        graph.get("start").put("B", 2L);

        graph.get("A").put("fin", 1L);

        graph.get("B").put("A", 3L);
        graph.get("B").put("fin", 5L);

        Map<String, Long> costs = new HashMap<>();

        costs.put("A", 6L);
        costs.put("B", 2L);
        costs.put("fin", Long.MAX_VALUE);

        // 3. Create parents
        Map<String, String> parents = new HashMap<>();

        parents.put("A", "start");
        parents.put("B", "start");
        parents.put("fin", null);

        Set<String> processed = new HashSet<>();

        String node = findLowestCost(costs, processed); // find the cheapest node

        while (node != null) {

            // Cost to reach the current node from start
            long cost = costs.get(node);

            // Get all neighbours of the current node
            Map<String, Long> neighbours = graph.get(node);

            for (Map.Entry<String, Long> entry : neighbours.entrySet()) {

                // Which neighbour am I checking?
                String neighbour = entry.getKey();

                // Cost of the edge from current node to neighbour
                long edgeCost = entry.getValue();

                // Total cost to reach neighbour through current node
                long newCost = cost + edgeCost;

                // Previously known cheapest cost to reach this neighbour
                long oldCost = costs.getOrDefault(
                        neighbour, Long.MAX_VALUE);

                // Is the newly discovered route cheaper?
                if (oldCost > newCost) {

                    // Update the cheapest known cost
                    costs.put(neighbour, newCost);

                    // Remember the current node as its parent
                    parents.put(neighbour, node);
                }
            }

            // Current node is completely processed
            processed.add(node);

            // Find the next cheapest unprocessed node
            node = findLowestCost(costs, processed);
        }
        System.out.println("Minimum cost: " + costs.get("fin"));

        List<String> path = new ArrayList<>();
        String current = "fin";

        if (costs.get("fin") != Long.MAX_VALUE) {
            while (current != null) {
                path.add(current);
                current = parents.get(current);

            }
            Collections.reverse(path);

            System.out.println("Shortest path: " + path);
        } else {
            System.out.println("No path found");
        }
    }
}