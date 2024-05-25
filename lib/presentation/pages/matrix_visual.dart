import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_controllers.dart';
import '../../data/model/path_model.dart';
import '../bloc/bfc_algorithm.dart';

class PathFindingScreen extends StatefulWidget {
  const PathFindingScreen({required this.pathData, super.key});

  final PathData pathData;

  @override
  PathFindingScreenState createState() => PathFindingScreenState();
}

class PathFindingScreenState extends State<PathFindingScreen> {
  List<List<int>> path = [];

  @override
  void initState() {
    super.initState();
    findPath();
  }

  void findPath() {
    PathFinder pathFinder = PathFinder(widget.pathData.fieldMatrix,
        widget.pathData.start, widget.pathData.end);
    List<List<int>> foundPath = pathFinder.findShortestPath();
    setState(() {
      path = foundPath;
    });
  }

  Color getColor(int x, int y) {
    if (widget.pathData.start[0] == x && widget.pathData.start[1] == y) {
      return AppColors.startingPointColor;
    } else if (widget.pathData.end[0] == x && widget.pathData.end[1] == y) {
      return AppColors.endPointColor;
    } else if (widget.pathData.fieldMatrix[x][y] == 'X') {
      return AppColors.obstacleColor;
    } else if (path.any((point) => point[0] == x && point[1] == y)) {
      return AppColors.pathColor;
    } else {
      return AppColors.emptyPointColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    int rowCount = widget.pathData.fieldMatrix.length;
    int colCount = widget.pathData.fieldMatrix[0].length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(MatrixController.matrixTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colCount,
              ),
              itemCount: rowCount * colCount,
              itemBuilder: (context, index) {
                int x = index ~/ colCount;
                int y = index % colCount;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.obstacleColor),
                    color: getColor(x, y),
                  ),
                  child: Center(
                    child: Text('($x,$y)'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              path.map((point) => '(${point[0]},${point[1]})').join(' -> '),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
