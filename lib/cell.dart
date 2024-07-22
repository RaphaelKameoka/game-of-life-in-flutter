class Cell {
  Cell({
    required this.alive,
    required this.index,
    required this.neighbors,
  });

  bool alive;
  final int index;
  final List<int> neighbors;

  static const int gridSize = 30;

  static List<int> getAdjacentIndices(int index) {
    int row = index ~/ gridSize;
    int col = index % gridSize;

    List<int> adjacentIndices = [];

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;

        int newRow = row + i;
        int newCol = col + j;

        if (newRow >= 0 && newRow < gridSize && newCol >= 0 && newCol < gridSize) {
          int newIndex = newRow * gridSize + newCol;
          adjacentIndices.add(newIndex);
        }
      }
    }

    return adjacentIndices;
  }
}