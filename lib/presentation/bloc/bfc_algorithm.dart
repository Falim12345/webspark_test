import 'dart:collection';

class PathFinder {
  final List<List<String>> grid;
  final List<int> start;
  final List<int> end;
  final int size;

  PathFinder(this.grid, this.start, this.end) : size = grid.length;

  bool isValid(List<int> p) {
    return p[0] >= 0 &&
        p[0] < size &&
        p[1] >= 0 &&
        p[1] < size &&
        grid[p[0]][p[1]] != 'X';
  }

  List<List<int>> getNeighbors(List<int> p) {
    List<List<int>> directions = [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1],
      [1, 1],
      [1, -1],
      [-1, 1],
      [-1, -1]
    ];
    List<List<int>> neighbors = [];
    for (var d in directions) {
      int x = p[0] + d[0];
      int y = p[1] + d[1];
      List<int> neighbor = [x, y];
      if (isValid(neighbor)) {
        if (d[0] != 0 && d[1] != 0) {
          // Check if diagonal move is valid
          List<int> adj1 = [p[0] + d[0], p[1]];
          List<int> adj2 = [p[0], p[1] + d[1]];
          if (isValid(adj1) && isValid(adj2)) {
            neighbors.add(neighbor);
          }
        } else {
          neighbors.add(neighbor);
        }
      }
    }
    return neighbors;
  }

  List<List<int>> findShortestPath() {
    Queue<List<List<int>>> queue = Queue();
    queue.add([start]);
    Set<List<int>> visited = {start};

    while (queue.isNotEmpty) {
      List<List<int>> path = queue.removeFirst();
      List<int> current = path.last;

      if (ListEquality().equals(current, end)) {
        return path;
      }

      for (var neighbor in getNeighbors(current)) {
        if (!visited
            .any((element) => ListEquality().equals(element, neighbor))) {
          visited.add(neighbor);
          List<List<int>> newPath = List.from(path);
          newPath.add(neighbor);
          queue.add(newPath);
        }
      }
    }

    return [];
  }
}

class ListEquality {
  bool equals(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
}
