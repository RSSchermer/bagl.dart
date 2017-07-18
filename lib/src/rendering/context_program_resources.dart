part of bagl.rendering;

/// Manages the provisioning and deprovisioning of program related GPU resources
/// for a [RendingContext].
class ContextProgramResources {
  /// The [RenderingContext] with which these [ContextProgramResources] are
  /// associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  /// Expands [Program]s with their associated [_GLProgram] for all currently
  /// provisioned programs.
  Expando<_GLProgram> _programGLProgram = new Expando();

  ContextProgramResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [program].
  bool areProvisionedFor(Program program) => _programGLProgram[program] != null;

  /// Provisions GPU resources for the [program].
  ///
  /// Compiles and links the [program]'s shaders. If resources were already
  /// provisioned previously for the [program], then these resources will be
  /// reused.
  ///
  /// Throws a [ShaderCompilationError] if the [program]'s vertex shader or
  /// fragment shader fails to compile.
  ///
  /// Throws a [ProgramLinkingError] if the [program] fails to link.
  void provisionFor(Program program) {
    if (!areProvisionedFor(program)) {
      final glProgramHandle = _context.createProgram();
      final vertexShader =
          _compileShader(WebGL.VERTEX_SHADER, program.vertexShaderSource);
      final fragmentShader =
          _compileShader(WebGL.FRAGMENT_SHADER, program.fragmentShaderSource);

      _context.attachShader(glProgramHandle, vertexShader);
      _context.attachShader(glProgramHandle, fragmentShader);
      _context.linkProgram(glProgramHandle);

      final success =
          _context.getProgramParameter(glProgramHandle, WebGL.LINK_STATUS);

      if (!success) {
        throw new ProgramLinkingError(
            _context.getProgramInfoLog(glProgramHandle));
      }

      _programGLProgram[program] = new _GLProgram(
          context, program, glProgramHandle, vertexShader, fragmentShader);
    }
  }

  /// Deprovisions the GPU resources associated with the [program].
  ///
  /// Frees all resources associated with the [program]. Returns `true` if
  /// resources were provisioned for the [program], `false` otherwise.
  bool deprovisionFor(Program program) {
    if (areProvisionedFor(program)) {
      final glProgramInfo = _programGLProgram[program];

      _context.deleteProgram(glProgramInfo.glProgramObject);
      _context.deleteShader(glProgramInfo.glVertexShaderObject);
      _context.deleteShader(glProgramInfo.glFragmentShaderObject);

      _programGLProgram[program] = null;

      return true;
    } else {
      return false;
    }
  }

  /// Returns the [_GLProgram] handle for the resources associated with the
  /// program.
  ///
  /// Returns the [_GLProgram] handle for the resources associated with the
  /// program if resources have been provisioned for the, or `null` if no
  /// resources have been provisioned yet.
  _GLProgram _getGLProgram(Program program) => _programGLProgram[program];

  WebGL.Shader _compileShader(int type, String source) {
    final shader = _context.createShader(type);

    _context.shaderSource(shader, source);
    _context.compileShader(shader);

    final success = _context.getShaderParameter(shader, WebGL.COMPILE_STATUS);

    if (!success) {
      throw new ShaderCompilationError(
          type, source, _context.getShaderInfoLog(shader));
    }

    return shader;
  }
}

/// Describes a rendering program for a certain [RenderingContext].
class _GLProgram {
  /// The [RenderingContext] with which this [_GLProgram] is associated.
  final RenderingContext context;

  /// The [Program] definition from which this [_GLProgram] was created.
  final Program program;

  /// The GL object for this [_GLProgram].
  final WebGL.Program glProgramObject;

  /// The GL object for this [_GLProgram]'s vertex shader.
  final WebGL.Shader glVertexShaderObject;

  /// The GL object for this [_GLProgram]'s fragment shader.
  final WebGL.Shader glFragmentShaderObject;

  /// Information about each of the program's active attributes variables, keyed
  /// by the attribute variable's name.
  List<_GLAttributeInfo> attributes;

  /// Information about each of the program's active uniform variables, keyed
  /// by the uniform variable's name.
  List<_GLUniform> uniforms;

  final Expando<WebGL.VertexArrayObjectOes> geometryVAOs = new Expando();

  /// Returns a new [_GLProgram].
  _GLProgram(this.context, this.program, this.glProgramObject,
      this.glVertexShaderObject, this.glFragmentShaderObject) {
    final glContext = context._context;

    // Set up attribute info
    final activeAttributes =
    glContext.getProgramParameter(glProgramObject, WebGL.ACTIVE_ATTRIBUTES);
    attributes = new List<_GLAttributeInfo>(activeAttributes);

    for (var i = 0; i < activeAttributes; i++) {
      final info = glContext.getActiveAttrib(glProgramObject, i);
      final name = info.name;
      final location = glContext.getAttribLocation(glProgramObject, name);

      if (location != -1) {
        attributes[i] = new _GLAttributeInfo(this, location, info);
      }
    }

    // Set up uniform info
    final activeUniforms =
    glContext.getProgramParameter(glProgramObject, WebGL.ACTIVE_UNIFORMS);
    final structs = <String, _StructUniform>{};
    final structArrays = <String, _StructArrayUniform>{};

    uniforms = new List<_GLUniform>();

    for (var i = 0; i < activeUniforms; i++) {
      final info = glContext.getActiveUniform(glProgramObject, i);
      final name = info.name.endsWith('[0]')
          ? info.name.substring(0, info.name.length - 3)
          : info.name;
      final location = glContext.getUniformLocation(glProgramObject, name);

      if (location != null) {
        final dotPosition = name.indexOf('.');

        if (dotPosition > 0) {
          // Uniform is a field on a struct or nested struct

          final fullName = name.substring(0, dotPosition);

          if (fullName.endsWith(']')) {
            // We're dealing with a struct array

            final arrayName = fullName.substring(0, fullName.indexOf('['));

            final existing = structs[fullName];

            if (existing != null) {
              existing.addComponent(info, location);
            } else {
              final struct =
              new _StructUniform(context, this, fullName, fullName);

              struct.addComponent(info, location);
              structs[fullName] = struct;

              final existingArray = structArrays[arrayName];

              if (existingArray != null) {
                existingArray.elements.add(struct);
              } else {
                final structArray = new _StructArrayUniform(arrayName);

                structArray.elements.add(struct);
                structArrays[arrayName] = structArray;
                uniforms.add(structArray);
              }
            }
          } else {
            // We're dealing with a singular struct

            final existing = structs[fullName];

            if (existing != null) {
              existing.addComponent(info, location);
            } else {
              final struct =
              new _StructUniform(context, this, fullName, fullName);

              struct.addComponent(info, location);
              structs[fullName] = struct;
              uniforms.add(struct);
            }
          }
        } else {
          final type = info.type;

          if (info.size == 1) {
            // We're dealing with a singular basic uniform

            if (type == WebGL.BOOL) {
              uniforms
                  .add(new _BoolUniform(context, this, location, info, name));
            } else if (type == WebGL.INT) {
              uniforms
                  .add(new _Int32Uniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT) {
              uniforms
                  .add(new _FloatUniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT_VEC2) {
              uniforms.add(
                  new _Vector2Uniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT_VEC3) {
              uniforms.add(
                  new _Vector3Uniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT_VEC4) {
              uniforms.add(
                  new _Vector4Uniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT_MAT2) {
              uniforms.add(
                  new _Matrix2Uniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT_MAT3) {
              uniforms.add(
                  new _Matrix3Uniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT_MAT4) {
              uniforms.add(
                  new _Matrix4Uniform(context, this, location, info, name));
            } else if (type == WebGL.SAMPLER_2D) {
              uniforms.add(
                  new _Sampler2DUniform(context, this, location, info, name));
            } else {
              throw new ArgumentError('Unsupported uniform type in program for '
                  'uniform "${info.name}". Currently supported types are: '
                  '`bool`, `int`, `float`, `vec2`, `vec3`, `vec4`, `mat2`, '
                  '`mat3`, `mat4`, `sampled2D`, `int[]`, `float[]`, `vec2[]`, '
                  '`vec3[]`, `vec4[]`, `mat2[]`, `mat3[]`, `mat4[]`, '
                  '`sampled2D[]`.');
            }
          } else {
            // We're dealing with a basic array uniform

            if (type == WebGL.INT) {
              uniforms.add(
                  new _Int32ArrayUniform(context, this, location, info, name));
            } else if (type == WebGL.FLOAT) {
              uniforms.add(new _Float32ArrayUniform(
                  context, this, location, info, name));
            } else if (type == WebGL.FLOAT_VEC2) {
              uniforms.add(new _Vector2ArrayUniform(
                  context, this, location, info, name));
            } else if (type == WebGL.FLOAT_VEC3) {
              uniforms.add(new _Vector3ArrayUniform(
                  context, this, location, info, name));
            } else if (type == WebGL.FLOAT_VEC4) {
              uniforms.add(new _Vector4ArrayUniform(
                  context, this, location, info, name));
            } else if (type == WebGL.FLOAT_MAT2) {
              uniforms.add(new _Matrix2ArrayUniform(
                  context, this, location, info, name));
            } else if (type == WebGL.FLOAT_MAT3) {
              uniforms.add(new _Matrix3ArrayUniform(
                  context, this, location, info, name));
            } else if (type == WebGL.FLOAT_MAT4) {
              uniforms.add(new _Matrix4ArrayUniform(
                  context, this, location, info, name));
            } else if (type == WebGL.SAMPLER_2D) {
              uniforms.add(new _Sampler2DArrayUniform(
                  context, this, location, info, name));
            } else {
              throw new ArgumentError('Unsupported uniform type in program for '
                  'uniform "${info.name}". Currently supported types are: '
                  '`bool`, `int`, `float`, `vec2`, `vec3`, `vec4`, `mat2`, '
                  '`mat3`, `mat4`, `sampled2D`, `int[]`, `float[]`, `vec2[]`, '
                  '`vec3[]`, `vec4[]`, `mat2[]`, `mat3[]`, `mat4[]`, '
                  '`sampled2D[]`.');
            }
          }
        }
      }
    }
  }
}

/// Information about an active rendering program attribute variable.
class _GLAttributeInfo {
  /// The [_GLProgram] with which this [_GLAttributeInfo] is associated.
  final _GLProgram glProgram;

  /// The location of the attribute in the [glProgram].
  final int location;

  /// The attribute's name.
  final String name;

  /// The attribute's type.
  final int type;

  /// The attribute's size in term of the [type].
  final int size;

  _GLAttributeInfo(this.glProgram, this.location, WebGL.ActiveInfo activeInfo)
      : name = activeInfo.name, type = activeInfo.type, size = activeInfo.size;
}

/// Information about an active rendering program uniform variable.
abstract class _GLUniform {
  /// The uniform's name.
  String get name;

  /// Attempts to bind the [value] to this uniform.
  ///
  /// Throws an [ArgumentError] if the type of the value does not match this
  /// uniforms [type].
  void bindValue(Object value, bool autoProvisioning);
}

abstract class _BasicUniform extends _GLUniform {
  final RenderingContext context;

  final WebGL.RenderingContext glContext;

  /// The [_GLProgram] with which this [_BasicUniform] is associated.
  final _GLProgram glProgram;

  /// The location of the uniform in the [glProgram].
  final WebGL.UniformLocation location;

  final String name;

  final WebGL.ActiveInfo info;

  _BasicUniform(
      this.context, this.glProgram, this.location, this.info, this.name)
      : glContext = context._context;

  void bindValue(Object value, bool autoProvisioning);
}

class _BoolUniform extends _BasicUniform {
  bool _currentValue;

  _BoolUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is bool) {
      if (value != _currentValue) {
        glContext.uniform1i(location, value ? 1 : 0);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `bool`.');
    }
  }
}

class _Int32Uniform extends _BasicUniform {
  int _currentValue;

  _Int32Uniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is int) {
      if (value != _currentValue) {
        glContext.uniform1i(location, value);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `int`.');
    }
  }
}

class _FloatUniform extends _BasicUniform {
  double _currentValue;

  _FloatUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is double) {
      if (value != _currentValue) {
        glContext.uniform1f(location, value);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `float32`.');
    }
  }
}

class _Vector2Uniform extends _BasicUniform {
  Vector2 _currentValue;

  _Vector2Uniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Vector2) {
      if (value != _currentValue) {
        glContext.uniform2f(location, value.x, value.y);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `vec2`.');
    }
  }
}

class _Vector3Uniform extends _BasicUniform {
  Vector3 _currentValue;

  _Vector3Uniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Vector3) {
      if (value != _currentValue) {
        glContext.uniform3f(location, value.x, value.y, value.z);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `vec3`.');
    }
  }
}

class _Vector4Uniform extends _BasicUniform {
  Vector4 _currentValue;

  _Vector4Uniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Vector4) {
      if (value != _currentValue) {
        glContext.uniform4f(location, value.x, value.y, value.z, value.w);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `vec4`.');
    }
  }
}

class _Matrix2Uniform extends _BasicUniform {
  Matrix2 _currentValue;

  _Matrix2Uniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Matrix2) {
      if (value != _currentValue) {
        glContext.uniformMatrix2fv(location, false, value.valuesColumnPacked);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `mat2`.');
    }
  }
}

class _Matrix3Uniform extends _BasicUniform {
  Matrix3 _currentValue;

  _Matrix3Uniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Matrix3) {
      if (value != _currentValue) {
        glContext.uniformMatrix3fv(location, false, value.valuesColumnPacked);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `mat3`.');
    }
  }
}

class _Matrix4Uniform extends _BasicUniform {
  Matrix4 _currentValue;

  _Matrix4Uniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Matrix4) {
      if (value != _currentValue) {
        glContext.uniformMatrix4fv(location, false, value.valuesColumnPacked);
        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `mat4`.');
    }
  }
}

class _Sampler2DUniform extends _BasicUniform {
  int _currentValue;

  _Sampler2DUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Sampler2D) {
      final texture = value.texture;
      final existingUnit = context._textureUnitsTextures.inverse[texture];

      if (existingUnit != null) {
        if (_currentValue != existingUnit) {
          glContext.uniform1i(location, existingUnit);
          _currentValue = existingUnit;
        }

        context._recentlyUsedTextureUnits
          ..remove(existingUnit)
          ..addFirst(existingUnit);
      } else {
        if (autoProvisioning) {
          context.textureResources.provisionFor(texture);
        } else {
          if (!context.textureResources.areProvisionedFor(texture)) {
            throw new StateError('GPU resources have not yet been '
                'provisioned for sampler `${info.name}` and `autoProvisioning` '
                'was set to `false`. Provision resources with '
                '`context.textureResources.provisionFor(sampler.texture)` or '
                'set `autoProvisioning` to `true`.');
          }
        }

        context._bindTexture2D(texture);

        final unit = context._activeTextureUnit;

        if (_currentValue != unit) {
          glContext.uniform1i(location, unit);
          _currentValue = unit;
        }
      }

      context.textureResources._getGLTexture2D(texture).applySampler(value);
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type '
          '`sampler2D`.');
    }
  }
}

class _Int32ArrayUniform extends _BasicUniform {
  Int32List _currentValue;

  final int _size;

  _Int32ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Int32List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          glContext.uniform1iv(location, value);
        } else {
          throw new ArgumentError('Tried to bind an Int32List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `int[]`.');
    }
  }
}

class _Float32ArrayUniform extends _BasicUniform {
  final int _size;

  Float32List _currentValue;

  _Float32ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Float32List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          glContext.uniform1fv(location, value);
        } else {
          throw new ArgumentError('Tried to bind a Float32List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type '
          '`float[]`.');
    }
  }
}

class _Vector2ArrayUniform extends _BasicUniform {
  final int _size;

  Vector2List _currentValue;

  _Vector2ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Vector2List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          // TODO: refactor to not create new Float32List instance
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 2);

          glContext.uniform2fv(location, view);
        } else {
          throw new ArgumentError('Tried to bind a Vector2List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `vec2[]`.');
    }
  }
}

class _Vector3ArrayUniform extends _BasicUniform {
  final int _size;

  Vector3List _currentValue;

  _Vector3ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Vector3List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          // TODO: refactor to not create new Float32List instance
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 3);

          glContext.uniform3fv(location, view);
        } else {
          throw new ArgumentError('Tried to bind a Vector3List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `vec3[]`.');
    }
  }
}

class _Vector4ArrayUniform extends _BasicUniform {
  final int _size;

  Vector4List _currentValue;

  _Vector4ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Vector4List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          // TODO: refactor to not create new Float32List instance
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 4);

          glContext.uniform4fv(location, view);
        } else {
          throw new ArgumentError('Tried to bind a Vector4List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `vec4[]`.');
    }
  }
}

class _Matrix2ArrayUniform extends _BasicUniform {
  final int _size;

  Matrix2List _currentValue;

  _Matrix2ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Matrix2List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          // TODO: refactor to not create new Float32List instance
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 4);

          glContext.uniformMatrix2fv(location, false, view);
        } else {
          throw new ArgumentError('Tried to bind a Matrix2List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `mat2[]`.');
    }
  }
}

class _Matrix3ArrayUniform extends _BasicUniform {
  final int _size;

  Matrix3List _currentValue;

  _Matrix3ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Matrix3List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          // TODO: refactor to not create new Float32List instance
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 9);

          glContext.uniformMatrix3fv(location, false, view);
        } else {
          throw new ArgumentError('Tried to bind a Matrix3List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `mat3[]`.');
    }
  }
}

class _Matrix4ArrayUniform extends _BasicUniform {
  final int _size;

  Matrix4List _currentValue;

  _Matrix4ArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Matrix4List) {
      if (value != _currentValue) {
        if (value.length == _size) {
          // TODO: refactor to not create new Float32List instance
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 16);

          glContext.uniformMatrix4fv(location, false, view);
        } else {
          throw new ArgumentError('Tried to bind a Matrix4List to uniform '
              '`${info.name}`, but the length of the list (${value.length}) '
              'does not match the size of the uniform ($_size).');
        }

        _currentValue = value;
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type `mat4[]`.');
    }
  }
}

class _Sampler2DArrayUniform extends _BasicUniform {
  final int _size;

  final Int32List _units;

  _Sampler2DArrayUniform(RenderingContext context, _GLProgram program,
      WebGL.UniformLocation location, WebGL.ActiveInfo info, String name)
      : _size = info.size,
        _units = new Int32List(info.size),
        super(context, program, location, info, name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is List<Sampler2D>) {
      final length = value.length;

      if (length != _size) {
        throw new ArgumentError('Tried to bind a Sampler2D List to uniform '
            '`${info.name}`, but the length of the list (${value.length}) '
            'does not match the size of the uniform ($_size).');
      }

      for (var i = 0; i < length; i++) {
        final sampler = value[i];
        final texture = sampler.texture;
        final existingUnit = context._textureUnitsTextures.inverse[texture];

        if (existingUnit != null) {
          _units[i] = existingUnit;

          context._recentlyUsedTextureUnits
            ..remove(existingUnit)
            ..addFirst(existingUnit);
        } else {
          if (autoProvisioning) {
            context.textureResources.provisionFor(texture);
          } else {
            if (!context.textureResources.areProvisionedFor(texture)) {
              throw new StateError('GPU resources have not yet been '
                  'provisioned for sampler `${info.name}` and '
                  '`autoProvisioning` was set to `false`. Provision resources '
                  'with `context.textureResources.provisionFor(sampler.'
                  'texture)` or set `autoProvisioning` to `true`.');
            }
          }

          context._bindTexture2D(texture);

          _units[i] = context._activeTextureUnit;
        }

        context.textureResources._getGLTexture2D(texture).applySampler(sampler);
      }

      glContext.uniform1iv(location, _units);
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `${info.name}` of type '
          '`sampled2D[]`.');
    }
  }
}

class _StructUniform implements _GLUniform {
  final RenderingContext context;

  final _GLProgram glProgram;

  final String name;

  final String fullName;

  List<_GLUniform> components = <_GLUniform>[];

  Map<String, _StructUniform> _structComponentsByName = {};

  Map<String, _StructArrayUniform> _structArrayComponentsByName = {};

  _StructUniform(this.context, this.glProgram, this.name, this.fullName);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is Struct) {
      final componentsLength = components.length;

      for (var i = 0; i < componentsLength; i++) {
        final component = components[i];
        final componentValue = value[component.name];

        if (componentValue == null) {
          throw new ArgumentError('Missing value on struct uniform '
              '`$fullName`: ${component.name}.');
        } else {
          component.bindValue(componentValue, autoProvisioning);
        }
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `$fullName` of type `struct`.');
    }
  }

  void addComponent(WebGL.ActiveInfo info, WebGL.UniformLocation location) {
    final name = info.name;

    // Check if the info matches this struct uniform at all
    if (!name.startsWith(fullName + '.')) {
      throw new ArgumentError('Info does not match struct.');
    } else {
      final relativeRawName = name.substring(fullName.length + 1);
      final relativeName = relativeRawName.endsWith('[0]')
          ? relativeRawName.substring(0, relativeRawName.length - 3)
          : relativeRawName;
      final dotPosition = relativeRawName.indexOf('.');

      if (dotPosition > 0) {
        // Uniform is a field on a struct or nested struct

        final structName = relativeName.substring(0, dotPosition);

        if (structName.endsWith(']')) {
          // We're dealing with a struct array

          final arrayName = structName.substring(0, structName.indexOf('['));

          final existing = _structComponentsByName[structName];

          if (existing != null) {
            existing.addComponent(info, location);
          } else {
            final struct = new _StructUniform(
                context, glProgram, structName, fullName + '.' + structName);

            struct.addComponent(info, location);
            _structComponentsByName[structName] = struct;

            final existingArray = _structArrayComponentsByName[arrayName];

            if (existingArray != null) {
              existingArray.elements.add(struct);
            } else {
              final structArray =
              new _StructArrayUniform(fullName + '.' + arrayName);

              structArray.elements.add(struct);
              _structArrayComponentsByName[arrayName] = structArray;
              components.add(structArray);
            }
          }
        } else {
          // We're dealing with a singular struct

          final existing = _structComponentsByName[structName];

          if (existing != null) {
            existing.addComponent(info, location);
          } else {
            final struct = new _StructUniform(
                context, glProgram, structName, fullName + '.' + structName);

            struct.addComponent(info, location);
            _structComponentsByName[structName] = struct;
            components.add(struct);
          }
        }
      } else {
        final type = info.type;

        if (info.size == 1) {
          // We're dealing with a singular basic uniform

          if (type == WebGL.BOOL) {
            components.add(new _BoolUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.INT) {
            components.add(new _Int32Uniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT) {
            components.add(new _FloatUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_VEC2) {
            components.add(new _Vector2Uniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_VEC3) {
            components.add(new _Vector3Uniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_VEC4) {
            components.add(new _Vector4Uniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_MAT2) {
            components.add(new _Matrix2Uniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_MAT3) {
            components.add(new _Matrix3Uniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_MAT4) {
            components.add(new _Matrix4Uniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.SAMPLER_2D) {
            components.add(new _Sampler2DUniform(
                context, glProgram, location, info, name));
          } else {
            throw new ArgumentError('Unsupported uniform type in program for '
                'uniform "${info.name}". Currently supported types are: '
                '`bool`, `int`, `float`, `vec2`, `vec3`, `vec4`, `mat2`, '
                '`mat3`, `mat4`, `sampled2D`, `int[]`, `float[]`, `vec2[]`, '
                '`vec3[]`, `vec4[]`, `mat2[]`, `mat3[]`, `mat4[]`, '
                '`sampled2D[]`.');
          }
        } else {
          // We're dealing with a basic array uniform

          if (type == WebGL.INT) {
            components.add(new _Int32ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT) {
            components.add(new _Float32ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_VEC2) {
            components.add(new _Vector2ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_VEC3) {
            components.add(new _Vector3ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_VEC4) {
            components.add(new _Vector4ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_MAT2) {
            components.add(new _Matrix2ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_MAT3) {
            components.add(new _Matrix3ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.FLOAT_MAT4) {
            components.add(new _Matrix4ArrayUniform(
                context, glProgram, location, info, relativeName));
          } else if (type == WebGL.SAMPLER_2D) {
            components.add(new _Sampler2DArrayUniform(
                context, glProgram, location, info, relativeName));
          } else {
            throw new ArgumentError('Unsupported uniform type in program for '
                'uniform "${info.name}". Currently supported types are: '
                '`bool`, `int`, `float`, `vec2`, `vec3`, `vec4`, `mat2`, '
                '`mat3`, `mat4`, `sampled2D`, `int[]`, `float[]`, `vec2[]`, '
                '`vec3[]`, `vec4[]`, `mat2[]`, `mat3[]`, `mat4[]`, '
                '`sampled2D[]`.');
          }
        }
      }
    }
  }
}

class _StructArrayUniform implements _GLUniform {
  final String name;

  final List<_StructUniform> elements = [];

  _StructArrayUniform(this.name);

  void bindValue(Object value, bool autoProvisioning) {
    if (value is List<Struct>) {
      final length = elements.length;

      if (length != value.length) {
        throw new ArgumentError('Tried to bind a Struct List to uniform '
            '`${name}`, but the length of the list (${value.length}) does not '
            'match the size of the uniform ($length).');
      } else {
        for (var i = 0; i < length; i++) {
          elements[i].bindValue(value[i], autoProvisioning);
        }
      }
    } else {
      throw new ArgumentError('Cannot bind a value of type '
          '`${value.runtimeType}` to uniform `$name` of type `struct[]`.');
    }
  }
}
