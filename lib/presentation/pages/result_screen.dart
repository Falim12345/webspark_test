import 'package:flutter/material.dart';
import 'package:webspark_test/presentation/pages/matrix_visual.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_controllers.dart';
import '../../data/model/path_model.dart';

class ResultListScreen extends StatelessWidget {
  const ResultListScreen({required this.pathsData, super.key});
  final List<PathData> pathsData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ResultListController.resultListTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: pathsData.length,
        itemBuilder: (context, index) {
          if (pathsData[index].isEmpty) {
            return const Card(
              child: ListTile(
                title: Text(
                  ResultListController.pathNotFound,
                  style: TextStyle(fontSize: 16, color: AppColors.errorColor),
                ),
              ),
            );
          } else {
            return Card(
              child: ListTile(
                title: Text(
                  pathsData[index].path,
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PathFindingScreen(
                        pathData: pathsData[index],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
