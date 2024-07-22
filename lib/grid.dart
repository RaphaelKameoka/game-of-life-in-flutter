import 'package:flutter/material.dart';
import 'package:game_of_life_flutter/cell.dart';

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GridScreenState();
  }
}

class _GridScreenState extends State<GridScreen> {
  late List<Cell> _cells;

  void initState() {
    super.initState();
    _initializeCells();
  }

  void _initializeCells() {
    _cells = List.generate(
      30 * 30,
      (index) => Cell(
          alive: false,
          index: index,
          neighbors: Cell.getAdjacentIndices(index)),
    );
  }

  bool _hasAliveCells() {
    return _cells.any((cell) => cell.alive);
  }

  void _nextStep() {
    List<Cell> newCells = List.from(_cells);

    for (int i = 0; i < _cells.length; i++) {
      int aliveNeighbors = 0;

      for (int neighborIndex in _cells[i].neighbors) {
        if (_cells[neighborIndex].alive) {
          aliveNeighbors += 1;
        }
      }

      if (_cells[i].alive) {
        if (aliveNeighbors < 2 || aliveNeighbors > 3) {
          newCells[i] =
              Cell(alive: false, index: i, neighbors: _cells[i].neighbors);
        }
      } else {
        if (aliveNeighbors == 3) {
          newCells[i] =
              Cell(alive: true, index: i, neighbors: _cells[i].neighbors);
        }
      }
    }

    setState(() {
      _cells = newCells;
    });
  }

  void _startGame() async{
    while (_hasAliveCells()) {
      _nextStep();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _deleteGame(){
    setState(() {
      for (int i=0; i<_cells.length; i++){
        _cells[i].alive = false;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game of Life'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 30,
              ),
              itemCount: _cells.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _cells[index].alive = !_cells[index].alive;
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.all(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    color: _cells[index].alive ? Colors.black : Colors.white,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(100))
                  ),
                  child: IconButton(
                      iconSize: 70,
                      onPressed: _startGame,
                      icon: const Icon(Icons.play_arrow)),
                ),
                const SizedBox(width: 50),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(100))
                  ),
                  child: IconButton(
                      iconSize: 70,
                      onPressed: _deleteGame,
                      icon: const Icon(Icons.delete)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
