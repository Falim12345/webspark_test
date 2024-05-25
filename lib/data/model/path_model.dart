class PathData {
  final String path;
  final List<List<String>> fieldMatrix;
  final List<int> start;
  final List<int> end;

  PathData({
    required this.path,
    required this.fieldMatrix,
    required this.start,
    required this.end,
  });

  bool get isEmpty => path.isEmpty;
}
