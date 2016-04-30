/// WebGL rendering driver.
library web_gl;

import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import 'dart:html';

import 'math.dart';
import 'vertex_data.dart';
import 'index_geometry.dart';

part 'src/web_gl/errors.dart';
part 'src/web_gl/rendering_context.dart';
part 'src/web_gl/program.dart';
