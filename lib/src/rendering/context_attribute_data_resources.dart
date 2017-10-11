part of bagl.rendering;

/// Manages the creation and deletion of vertex attribute data buffer objects
/// for a [RenderingContext].
class ContextAttributeDataResources {
  /// The [RenderingContext] with which these [ContextAttributeDataResources]
  /// are associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  Expando<_GLAttributeData> _attributeDataGLAttributeData = new Expando();

  ContextAttributeDataResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [attributeData].
  bool areProvisionedFor(AttributeData attributeData) =>
      _attributeDataGLAttributeData[attributeData] != null;

  /// Provisions GPU resources for the [attributeData].
  ///
  /// Sets up a data buffer for the [attributeData].
  void provisionFor(AttributeData attributeData) {
    if (!areProvisionedFor(attributeData)) {
      final VBO = _context.createBuffer();
      final usage =
          attributeData.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;
      final glAttributeData = new _GLAttributeData(context, attributeData, VBO);

      _attributeDataGLAttributeData[attributeData] = glAttributeData;

      context._bindAttributeData(glAttributeData);
      _context.bufferData(WebGL.ARRAY_BUFFER, attributeData.buffer, usage);
    }
  }

  /// Deprovisions the GPU resources associated with the [attributeData].
  ///
  /// Returns `true` if resources were provisioned for the [attributeData],
  /// `false` otherwise.
  bool deprovisionFor(AttributeData attributeData) {
    final glAttributeData = _attributeDataGLAttributeData[attributeData];

    if (glAttributeData != null) {
      _context.deleteBuffer(glAttributeData.VBO);

      _attributeDataGLAttributeData[attributeData] = null;

      if (glAttributeData == context._boundAttributeData) {
        context._bindAttributeData(null);
      }

      _attributeDataGLAttributeData[attributeData] = null;

      return true;
    } else {
      return false;
    }
  }

  _GLAttributeData _getGlAttributeData(AttributeData attributeData) =>
      _attributeDataGLAttributeData[attributeData];
}

class _GLAttributeData {
  final RenderingContext context;

  final AttributeData dataSource;

  final WebGL.Buffer VBO;

  int currentVBOVersion;

  int referenceCount = 1;

  _GLAttributeData(this.context, this.dataSource, this.VBO)
      : currentVBOVersion = dataSource.version;

  void updateBuffer() {
    if (dataSource.version != currentVBOVersion) {
      context._bindAttributeData(this);
      context._context.bufferSubData(WebGL.ARRAY_BUFFER, 0, dataSource.buffer);

      currentVBOVersion = dataSource.version;
    }
  }
}
