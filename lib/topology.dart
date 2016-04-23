/// Data structures for describing geometries with buffered vertex data and
/// buffered index data.
library topology;

import 'dart:collection';
import 'dart:typed_data';

import 'buffered_vertex_data.dart';
import 'geometry_primitives.dart';

part 'src/topology/line_loop.dart';
part 'src/topology/line_strip.dart';
part 'src/topology/lines.dart';
part 'src/topology/points.dart';
part 'src/topology/triangle_fan.dart';
part 'src/topology/triangle_strip.dart';
part 'src/topology/triangles.dart';
