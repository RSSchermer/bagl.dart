/// WebGL rendering driver.
library web_gl;

import 'dart:async';
import 'dart:collection';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:collection/wrappers.dart';
import 'package:quiver/core.dart';

import 'index_geometry.dart';
import 'math.dart';
import 'matrix_list.dart';
import 'vertex_data.dart';

part 'src/web_gl/blending.dart';
part 'src/web_gl/color_mask.dart';
part 'src/web_gl/culling_mode.dart';
part 'src/web_gl/depth_test.dart';
part 'src/web_gl/errors.dart';
part 'src/web_gl/frame.dart';
part 'src/web_gl/program.dart';
part 'src/web_gl/region.dart';
part 'src/web_gl/rendering_context.dart';
part 'src/web_gl/sampler.dart';
part 'src/web_gl/shader.dart';
part 'src/web_gl/stencil_test.dart';
part 'src/web_gl/test_function.dart';
part 'src/web_gl/texture.dart';
part 'src/web_gl/winding_order.dart';

part 'src/web_gl/_context_geometry_resource_manager.dart';
part 'src/web_gl/_context_program_resource_manager.dart';
part 'src/web_gl/_context_sampler_resource_manager.dart';
part 'src/web_gl/_gl_enum_mapping.dart';
part 'src/web_gl/_gl_program.dart';
