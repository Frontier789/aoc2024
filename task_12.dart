import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File("input/12.txt");
  final contents = await file.readAsString();
  final map = LineSplitter().convert(contents);

  final h = map.length;
  final w = map[0].length;

  List? visited = List.generate(w, (_) => List.filled(h, 0, growable: false), growable: false);

  int calcCirc2(int x, int y) {
    int sides = 0;
    final v = map[x][y];

    if (x == 0 || map[x-1][y] != v) {
      if (y == 0 || map[x][y-1] != v || (map[x][y-1] == v && x != 0 && map[x-1][y-1] == v)) {
        sides += 1;
      }
    }
    if (y == 0 || map[x][y-1] != v) {
      if (x == 0 || map[x-1][y] != v || (map[x-1][y] == v && y != 0 && map[x-1][y-1] == v)) {
        sides += 1;
      }
    }
    if (x+1 == w || map[x+1][y] != v) {
      if (y == 0 || map[x][y-1] != v || (map[x][y-1] == v && x+1 != w && map[x+1][y-1] == v)) {
        sides += 1;
      }
    }
    if (y+1 == w || map[x][y+1] != v) {
      if (x == 0 || map[x-1][y] != v || (map[x-1][y] == v && y+1 != h && map[x-1][y+1] == v)) {
        sides += 1;
      }
    }
    return sides;
  }

  int calcCirc(int x, int y) {
    int circ = 0;
    if (x == 0 || map[x-1][y] != map[x][y]) circ += 1;
    if (y == 0 || map[x][y-1] != map[x][y]) circ += 1;
    if (x+1 == w || map[x+1][y] != map[x][y]) circ += 1;
    if (y+1 == w || map[x][y+1] != map[x][y]) circ += 1;
    return circ;
  }

  List<(int,int)> neighbors(int x, int y) {
    List<(int,int)> neighs = [];
    if (x > 0 && map[x-1][y] == map[x][y]) neighs.add((x-1,y));
    if (y > 0 && map[x][y-1] == map[x][y]) neighs.add((x,y-1));
    if (x+1 < w && map[x+1][y] == map[x][y]) neighs.add((x+1,y));
    if (y+1 < w && map[x][y+1] == map[x][y]) neighs.add((x,y+1));
    return neighs;
  }

  (int, int, int) traversePlot(int x, int y) {
    List<(int, int)> points = [(x,y)];
    visited[x][y] = 1;

    int area = 0;
    int circ = 0;
    int circ2 = 0;

    while (points.isNotEmpty) {
      final (x, y) = points.removeLast();
      // print("\tVisiting $x,$y");
      
      area += 1;
      circ += calcCirc(x,y);
      circ2 += calcCirc2(x,y);

      for (final (xn, yn) in neighbors(x,y)) {
        if (visited[xn][yn] == 0) {
          visited[xn][yn] = 1;
          points.add((xn, yn));
        }
      }
    }

    return (area, circ, circ2);
  }

  var sum1 = 0;
  var sum2 = 0;

  for (var x = 0; x < w; x++) {
    for (var y = 0; y < h; y++) {
      if (visited[x][y] == 0) {
        // print("Found a plot at $x,$y type=${map[x][y]}");
        final (area, circ, circ2) = traversePlot(x, y);
        // print("\tarea=$area circ=$circ circ2=$circ2");

        sum1 += area * circ;
        sum2 += area * circ2;
      }
    }
  }

  print("Task 1: $sum1");
  print("Task 2: $sum2");
}
