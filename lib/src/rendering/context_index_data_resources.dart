part of bagl.rendering;

/// Manages the creation and deletion of index data buffer objects for a
/// [RenderingContext].
class ContextIndexDataResources {
  /// The [RenderingContext] with which these [ContextAttributeDataResources]
  /// are associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  Expando<_GLIndexData> _indexDataGLIndexData = new Expando();

  ContextIndexDataResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [indexData].
  bool areProvisionedFor(IndexData indexData) =>
      _indexDataGLIndexData[indexData] != null;

  /// Provisions GPU resources for the [attributeData].
  ///
  /// Sets up a data buffer for the [attributeData].
  void provisionFor(IndexData indexData) {
    if (!areProvisionedFor(indexData)) {
      final IBO = _context.createBuffer();
      final usage =
          indexData.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;
      final glIndexData = new _GLIndexData(context, indexData, IBO);

      _indexDataGLIndexData[indexData] = glIndexData;

      if (context._boundVertexArrayObject != null) {
        context._bindVertexArrayObject(null);
      }

      context._bindIndexData(glIndexData);
      _context.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indexData.buffer, usage);
    }
  }

  /// Deprovisions the GPU resources associated with the [attributeData].
  ///
  /// Returns `true` if resources were provisioned for the [attributeData],
  /// `false` otherwise.
  bool deprovisionFor(IndexData indexData) {
    final glIndexData = _indexDataGLIndexData[indexData];

    if (glIndexData != null) {
      _context.deleteBuffer(glIndexData.IBO);

      _indexDataGLIndexData[indexData] = null;

      if (glIndexData == context._boundIndexData) {
        if (context._boundVertexArrayObject != null) {
          context._bindVertexArrayObject(null);
        }

        context._bindIndexData(null);
      }

      return true;
    } else {
      return false;
    }
  }

  _GLIndexData _getGlIndexData(IndexData indexData) =>
      _indexDataGLIndexData[indexData];
}

class _GLIndexData {
  final RenderingContext context;

  final IndexData indexData;

  final WebGL.Buffer IBO;

  int currentIBOVersion;

  int currentLengthInBytes;

  int referenceCount = 1;

  _GLIndexData(this.context, this.indexData, this.IBO)
      : currentIBOVersion = indexData.version,
        currentLengthInBytes = indexData.lengthInBytes;

  void updateBuffer() {
    if (indexData.version != currentIBOVersion) {
      context._bindIndexData(this);

      if (currentLengthInBytes == indexData.lengthInBytes) {
        context._context
            .bufferSubData(WebGL.ELEMENT_ARRAY_BUFFER, 0, indexData.buffer);
      } else {
        final usage =
            indexData.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

        context._context
            .bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indexData.buffer, usage);

        currentLengthInBytes = indexData.lengthInBytes;
      }

      currentIBOVersion = indexData.version;
    }
  }
}
