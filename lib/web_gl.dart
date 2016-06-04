/// WebGL rendering driver.
library web_gl;

import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import 'dart:html';

import 'package:quiver/core.dart';

import 'index_geometry.dart';
import 'math.dart';
import 'matrix_list.dart';
import 'vertex_data.dart';

part 'src/web_gl/errors.dart';
part 'src/web_gl/frame.dart';
part 'src/web_gl/program.dart';
part 'src/web_gl/region.dart';
part 'src/web_gl/rendering_context.dart';
part 'src/web_gl/shader.dart';
