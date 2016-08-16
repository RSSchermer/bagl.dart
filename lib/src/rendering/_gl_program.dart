part of rendering;

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

  /// Information about this [_GLProgram]'s active attribute variables, keyed by
  /// the attribute variable's name.
  Map<String, _GLAttributeInfo> _attributeInfoByName;

  /// Information about this [_GLProgram]'s active uniform variables, keyed by
  /// the uniform variable's name.
  Map<String, _GLUniformInfo> _uniformInfoByName;

  /// The values currently bound to each of this [_GLProgram]'s uniform
  /// variables, keyed by the uniform variable's name.
  Map<String, dynamic> _uniformValues = {};

  /// Returns a new [_GLProgram].
  _GLProgram(this.context, this.program, this.glProgramObject,
      this.glVertexShaderObject, this.glFragmentShaderObject) {
    final glContext = context._context;

    // Create attribute name -> attribute location map
    final attributeInfoByName = <String, _GLAttributeInfo>{};
    final activeAttributes =
        glContext.getProgramParameter(glProgramObject, WebGL.ACTIVE_ATTRIBUTES);

    for (var i = 0; i < activeAttributes; i++) {
      final info = glContext.getActiveAttrib(glProgramObject, i);
      final name = info.name;
      final location = glContext.getAttribLocation(glProgramObject, name);

      if (location != -1) {
        attributeInfoByName[name] = new _GLAttributeInfo(this, location, info);
      }
    }

    _attributeInfoByName = new UnmodifiableMapView(attributeInfoByName);

    // Create uniform name -> uniform location map
    final uniformInfoByName = <String, _GLUniformInfo>{};
    final activeUniforms =
        glContext.getProgramParameter(glProgramObject, WebGL.ACTIVE_UNIFORMS);

    for (var i = 0; i < activeUniforms; i++) {
      final info = glContext.getActiveUniform(glProgramObject, i);
      final name = info.name.endsWith('[0]')
          ? info.name.substring(0, info.name.length - 3)
          : info.name;
      final location = glContext.getUniformLocation(glProgramObject, name);

      if (location != null) {
        uniformInfoByName[name] = new _GLUniformInfo(this, location, info);
      }
    }

    _uniformInfoByName = new UnmodifiableMapView(uniformInfoByName);
  }

  /// Information about each of the program's active attributes variables, keyed
  /// by the attribute variable's name.
  Map<String, _GLAttributeInfo> get attributeInfoByName => _attributeInfoByName;

  /// Information about each of the program's active uniform variables, keyed
  /// by the uniform variable's name.
  Map<String, _GLUniformInfo> get uniformInfoByName => _uniformInfoByName;

  /// Returns the value currently bound the the uniform variable with the given
  /// [uniformName].
  dynamic boundUniformValue(String uniformName) => _uniformValues[uniformName];

  /// Binds the [value] to the uniform variable with the given [uniformName].
  ///
  /// Does nothing if a value equal to the [value] is already bound to this
  /// uniform variable (as determined by the [value]'s `==` operator).
  ///
  /// Throws an [ArgumentError] if the value is not of a valid type. Valid types
  /// for uniform variables are: [bool], [int], [double], [Vector2], [Vector3],
  /// [Vector4], [Matrix2], [Matrix3], [Matrix4], [Sampler2D], [Int32List],
  /// [Float32List], [Vector2List], [Vector3List], [Vector4List], [Matrix2List],
  /// [Matrix3List], [Matrix4List], [List<Sampler2D>].
  void bindUniformValue(String uniformName, dynamic value) {
    if (value is Struct) {
      value.forEach((member, value) {
        bindUniformValue("$uniformName.$member", value);
      });
    } else if (value is List<Struct>) {
      for (var i = 0; i < value.length; i++) {
        value[i].forEach((member, value) {
          bindUniformValue("$uniformName[$i].$member", value);
        });
      }
    } else {
      final glContext = context._context;
      final uniformInfo = uniformInfoByName[uniformName];

      if (uniformInfo == null) {
        throw new ArgumentError('Tried to bind a value to a uniform variable '
            'named "$uniformName", but no active uniform with that name was '
            'found for the shader program.');
      }

      final location = uniformInfoByName[uniformName].location;

      if (value is Sampler2D) {
        if (context._textureUnitsSamplers.containsValue(value)) {
          final unit = context._textureUnitsSamplers.inverse[value];

          if (_uniformValues[uniformName] != unit) {
            glContext.uniform1i(location, unit);
            _uniformValues[uniformName] = unit;
          }

          context._recentlyUsedTextureUnits
            ..remove(unit)
            ..addFirst(unit);
        } else {
          final unit = context._recentlyUsedTextureUnits.last;

          context._updateActiveTextureUnit(unit);
          context.samplerResources.provisionFor(value);
          context._bindSampler2D(value);

          if (_uniformValues[uniformName] != unit) {
            glContext.uniform1i(location, unit);
            _uniformValues[uniformName] = unit;
          }

          context._recentlyUsedTextureUnits
            ..removeLast()
            ..addFirst(unit);
        }
      } else if (value is List<Sampler2D>) {
        final length = value.length;
        final units = new Int32List(length);

        for (var i = 0; i < length; i++) {
          final sampler = value[i];

          if (context._textureUnitsSamplers.containsValue(sampler)) {
            final unit = context._textureUnitsSamplers.inverse[sampler];

            context._recentlyUsedTextureUnits
              ..remove(unit)
              ..addFirst(unit);

            units[i] = unit;
          } else {
            final unit = context._recentlyUsedTextureUnits.last;

            context._updateActiveTextureUnit(unit);
            context.samplerResources.provisionFor(sampler);
            context._bindSampler2D(sampler);

            context._recentlyUsedTextureUnits
              ..removeLast()
              ..addFirst(unit);

            units[i] = unit;
          }
        }

        glContext.uniform1iv(location, units);
        _uniformValues[uniformName] = units;
      } else if (_uniformValues[uniformName] != value) {
        if (value is bool) {
          glContext.uniform1i(location, value ? 1 : 0);
        } else if (value is int) {
          glContext.uniform1i(location, value);
        } else if (value is double) {
          glContext.uniform1f(location, value);
        } else if (value is Vector2) {
          glContext.uniform2f(location, value.x, value.y);
        } else if (value is Vector3) {
          glContext.uniform3f(location, value.x, value.y, value.z);
        } else if (value is Vector4) {
          glContext.uniform4f(location, value.x, value.y, value.z, value.w);
        } else if (value is Matrix2) {
          var columnPacked = new Float32List(4);

          columnPacked[0] = value.r0c0;
          columnPacked[1] = value.r1c0;
          columnPacked[2] = value.r0c1;
          columnPacked[3] = value.r1c1;

          glContext.uniformMatrix2fv(location, false, columnPacked);
        } else if (value is Matrix3) {
          var columnPacked = new Float32List(9);

          columnPacked[0] = value.r0c0;
          columnPacked[1] = value.r1c0;
          columnPacked[2] = value.r2c0;
          columnPacked[3] = value.r0c1;
          columnPacked[4] = value.r1c1;
          columnPacked[5] = value.r2c1;
          columnPacked[6] = value.r0c2;
          columnPacked[7] = value.r1c2;
          columnPacked[8] = value.r2c2;

          glContext.uniformMatrix3fv(location, false, columnPacked);
        } else if (value is Matrix4) {
          var columnPacked = new Float32List(16);

          columnPacked[0] = value.r0c0;
          columnPacked[1] = value.r1c0;
          columnPacked[2] = value.r2c0;
          columnPacked[3] = value.r3c0;
          columnPacked[4] = value.r0c1;
          columnPacked[5] = value.r1c1;
          columnPacked[6] = value.r2c1;
          columnPacked[7] = value.r3c1;
          columnPacked[8] = value.r0c2;
          columnPacked[9] = value.r1c2;
          columnPacked[10] = value.r2c2;
          columnPacked[11] = value.r3c2;
          columnPacked[12] = value.r0c3;
          columnPacked[13] = value.r1c3;
          columnPacked[14] = value.r2c3;
          columnPacked[15] = value.r3c3;

          glContext.uniformMatrix4fv(location, false, columnPacked);
        } else if (value is Int32List) {
          glContext.uniform1iv(location, value);
        } else if (value is Float32List) {
          glContext.uniform1fv(location, value);
        } else if (value is Vector2List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 2);

          glContext.uniform2fv(location, view);
        } else if (value is Vector3List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 3);

          glContext.uniform3fv(location, view);
        } else if (value is Vector4List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 4);

          glContext.uniform4fv(location, view);
        } else if (value is Matrix2List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 4);

          glContext.uniformMatrix2fv(location, false, view);
        } else if (value is Matrix3List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 9);

          glContext.uniformMatrix3fv(location, false, view);
        } else if (value is Matrix4List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 16);

          glContext.uniformMatrix4fv(location, false, view);
        } else {
          new ArgumentError('Tried to bind a value of type '
              '"${value.runtimeType}" to the uniform variable named '
              '"$uniformName", but this is not a valid uniform type. Supported '
              'types are: bool, int, double, Vector2, Vector3, Vector4, '
              'Matrix2, Matrix3, Matrix4, Sampler2D, Struct, Int32List, '
              'Float32List, Vector2List, Vector3List, Vector4List, '
              'Matrix2List, Matrix3List, Matrix4List, List<Sampler2D>, '
              'List<Struct>.');
        }

        _uniformValues[uniformName] = value;
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

  final WebGL.ActiveInfo _activeInfo;

  _GLAttributeInfo(this.glProgram, this.location, this._activeInfo);

  /// The attribute's name.
  String get name => _activeInfo.name;

  /// The attribute's type.
  int get type => _activeInfo.type;

  /// The attribute's size in term of the [type].
  int get size => _activeInfo.size;
}

/// Information about an active rendering program uniform variable.
class _GLUniformInfo {
  /// The [_GLProgram] with which this [_GLUniformInfo] is associated.
  final _GLProgram glProgram;

  /// The location of the uniform in the [glProgram].
  final WebGL.UniformLocation location;

  final WebGL.ActiveInfo _activeInfo;

  _GLUniformInfo(this.glProgram, this.location, this._activeInfo);

  /// The uniform's name.
  String get name => _activeInfo.name;

  /// The uniform's type.
  int get type => _activeInfo.type;

  /// The uniform's size in term of the [type].
  int get size => _activeInfo.size;
}
