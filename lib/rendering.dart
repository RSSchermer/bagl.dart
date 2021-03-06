/// Data structures for rendering and customizing the rendering pipeline.
library bagl.rendering;

import 'dart:collection';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

import 'package:collection/wrappers.dart';
import 'package:quiver/core.dart';
import 'package:quiver/collection.dart';

import 'math.dart';
import 'matrix_list.dart';
import 'primitive_source.dart';
import 'struct.dart';
import 'texture.dart';

part 'src/rendering/blending.dart';
part 'src/rendering/color_mask.dart';
part 'src/rendering/context_attribute_data_resources.dart';
part 'src/rendering/context_index_data_resources.dart';
part 'src/rendering/context_program_resources.dart';
part 'src/rendering/context_texture_resources.dart';
part 'src/rendering/culling_mode.dart';
part 'src/rendering/depth_test.dart';
part 'src/rendering/errors.dart';
part 'src/rendering/frame.dart';
part 'src/rendering/program.dart';
part 'src/rendering/rendering_context.dart';
part 'src/rendering/shader.dart';
part 'src/rendering/stencil_test.dart';
part 'src/rendering/test_function.dart';
part 'src/rendering/uniforms.dart';
part 'src/rendering/winding_order.dart';

part 'src/rendering/_gl_enum_mapping.dart';
