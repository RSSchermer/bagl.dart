part of bagl.rendering;

/// Manages the provisioning and deprovisioning of geometry related GPU
/// resources for a [RendingContext].
///
/// Manages the creation and deletion of vertex attribute data buffer objects
/// and index data buffer objects for [PrimitiveSequence] instances.
class ContextGeometryResources {
  /// The [RenderingContext] with which these [ContextGeometryResources] are
  /// associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  Expando<_GLIndexList> _indexListGLIndexList = new Expando();

  Expando<_GLAttributeDataTable> _tableGLTable = new Expando();

  Expando<_GLPrimitiveSequence> _primitivesGLPrimitives = new Expando();

  ContextGeometryResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [primitives].
  bool areProvisionedFor(PrimitiveSequence primitives) =>
      _primitivesGLPrimitives[primitives] != null;

  /// Provisions GPU resources for the [primitives].
  ///
  /// Sets up data buffers for the [primitives]'s index and attribute data. If
  /// the [primitives] share data with other [PrimitiveSequence]s for which
  /// resources have been previously provisioned, then these resources will be
  /// reused.
  void provisionFor(PrimitiveSequence primitives) {
    if (!areProvisionedFor(primitives)) {
      final indexList = primitives.indexList;
      var glIndexList;
      final glTables = <_GLAttributeDataTable>[];

      if (indexList != null) {
        glIndexList = _indexListGLIndexList[indexList];

        if (glIndexList != null) {
          glIndexList.referenceCount += 1;
        } else {
          final IBO = _context.createBuffer();
          final usage =
              indexList.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

          glIndexList = new _GLIndexList(context, indexList, IBO);

          _indexListGLIndexList[indexList] = glIndexList;

          context._bindIndexList(glIndexList);
          _context.bufferData(
              WebGL.ELEMENT_ARRAY_BUFFER, indexList.buffer, usage);
        }
      }

      primitives.vertexArray.attributeDataTables.forEach((table) {
        final existing = _tableGLTable[table];

        if (existing != null) {
          existing.referenceCount += 1;

          glTables.add(existing);
        } else {
          var VBO = _context.createBuffer();
          var usage = table.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;
          final glTable = new _GLAttributeDataTable(context, table, VBO);

          _tableGLTable[table] = glTable;
          glTables.add(glTable);

          context._bindAttributeDataTable(glTable);
          _context.bufferData(WebGL.ARRAY_BUFFER, table.buffer, usage);
        }
      });

      _primitivesGLPrimitives[primitives] =
          new _GLPrimitiveSequence(primitives, glIndexList, glTables);
    }
  }

  /// Deprovisions the GPU resources associated with the [primitives].
  ///
  /// Frees each resource associated with the [primitives], unless the
  /// [primitives] share the resource with another currently provisioned
  /// [PrimitiveSequence]. Returns `true` if resources were provisioned for the
  /// [primitives], `false` otherwise.
  bool deprovisionFor(PrimitiveSequence primitives) {
    if (areProvisionedFor(primitives)) {
      final glIndexList = _indexListGLIndexList[primitives.indexList];

      if (glIndexList != null) {
        // When primitives are deprovisioned but their index list is still used
        // by another primitive sequence, then the index list's index buffer
        // object (IBO) should not yet be deleted. The IBO is only deleted when
        // the reference count drops to 0.
        if (glIndexList.referenceCount > 1) {
          glIndexList.referenceCount -= 1;
        } else {
          _context.deleteBuffer(glIndexList.IBO);

          _indexListGLIndexList[primitives.indexList] = null;

          if (glIndexList == context._boundIndexList) {
            context._bindIndexList(null);
          }
        }
      }

      primitives.vertexArray.attributeDataTables.forEach((table) {
        final glTable = _tableGLTable[table];

        if (glTable != null) {
          // When geometry is deprovisioned but an attribute data table is still
          // used by another geometry, then the attribute data table's vertex
          // buffer object (VBO) should not yet be deleted. The VBO is only
          // deleted when the reference count drops to 0.
          if (glTable.referenceCount > 1) {
            glTable.referenceCount -= 1;
          } else {
            _context.deleteBuffer(glTable.VBO);

            _tableGLTable[table] = null;

            if (glTable == context._boundAttributeDataTable) {
              context._bindAttributeDataTable(null);
            }
          }
        }
      });

      _primitivesGLPrimitives[primitives] = null;

      return true;
    } else {
      return false;
    }
  }

  _GLPrimitiveSequence _getGlPrimitiveSequence(PrimitiveSequence primitives) =>
      _primitivesGLPrimitives[primitives];

  _GLAttributeDataTable _getGlAttributeDataTable(
          AttributeDataTable attributeDataTable) =>
      _tableGLTable[attributeDataTable];
}

class _GLPrimitiveSequence {
  final PrimitiveSequence primitiveSequence;

  final _GLIndexList indexList;

  final List<_GLAttributeDataTable> tables;

  WebGL.VertexArrayObjectOes vao;

  _GLPrimitiveSequence(this.primitiveSequence, this.indexList, this.tables);

  void updateBuffers() {
    if (indexList != null) {
      indexList.updateBuffer();
    }

    final tableCount = tables.length;

    for (var i = 0; i < tableCount; i++) {
      tables[i].updateBuffer();
    }
  }
}

class _GLIndexList {
  final RenderingContext context;

  final IndexList indexList;

  final WebGL.Buffer IBO;

  int currentIBOVersion;

  int referenceCount = 1;

  _GLIndexList(this.context, this.indexList, this.IBO)
      : currentIBOVersion = indexList.version;

  void updateBuffer() {
    if (indexList.version != currentIBOVersion) {
      context._bindIndexList(this);
      context._context
          .bufferSubData(WebGL.ELEMENT_ARRAY_BUFFER, 0, indexList.buffer);

      currentIBOVersion = indexList.version;
    }
  }
}

class _GLAttributeDataTable {
  final RenderingContext context;

  final AttributeDataTable table;

  final WebGL.Buffer VBO;

  int currentVBOVersion;

  int referenceCount = 1;

  _GLAttributeDataTable(this.context, this.table, this.VBO)
      : currentVBOVersion = table.version;

  void updateBuffer() {
    if (table.version != currentVBOVersion) {
      context._bindAttributeDataTable(this);
      context._context.bufferSubData(WebGL.ARRAY_BUFFER, 0, table.buffer);

      currentVBOVersion = table.version;
    }
  }
}
