part of rendering;

/// Manages the provisioning and deprovisioning of geometry related GPU
/// resources for a [RendingContext].
///
/// Manages the creation and deletion of vertex attribute data buffer objects
/// and index data buffer objects for [IndexGeometry] instances.
class ContextGeometryResources {
  /// The [RenderingContext] with which these [ContextGeometryResources] are
  /// associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  Expando<bool> _isProvisionedGeometry = new Expando();

  /// Expands index lists with their associated index buffer objects (IBOs).
  Expando<WebGL.Buffer> _indexListIBO = new Expando();

  /// Expands attribute data tables with their associated vertex buffer objects
  /// (VBOs).
  Expando<WebGL.Buffer> _attributeDataTableVBO = new Expando();

  /// Expands index lists with their reference counts.
  ///
  /// An [IndexList] may be used by multiple geometries attached to this
  /// context. If 3 different geometries use the same [IndexList], then the
  /// reference count for that [IndexList] will be 3.
  Expando<int> _indexListReferenceCount = new Expando();

  /// Expands attribute data tables with their reference counts.
  ///
  /// An [AttributeDataTable] may be used by multiple geometries attached to
  /// this context. If 3 different geometries use the same [AttributeDataTable],
  /// then the reference count for that [AttributeDataTable] will be 3.
  Expando<int> _attributeDataTableReferenceCount = new Expando();

  ContextGeometryResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [geometry].
  bool areProvisionedFor(IndexGeometry geometry) =>
      _isProvisionedGeometry[geometry] ?? false;

  /// Provisions GPU resources for the [geometry].
  ///
  /// Sets up data buffers for the [geometry]'s index and attribute data. If the
  /// [geometry] shares data with other geometries for which resources have been
  /// previously provisioned, then these resources will be reused.
  void provisionFor(IndexGeometry geometry) {
    if (!areProvisionedFor(geometry)) {
      final indexList = geometry.indices;

      if ((_indexListReferenceCount[indexList] ?? 0) >= 1) {
        _indexListReferenceCount[indexList] += 1;
      } else {
        final IBO = _context.createBuffer();
        final usage =
            indexList.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

        _indexListIBO[indexList] = IBO;
        _indexListReferenceCount[indexList] = 1;

        context._bindIndexList(indexList);
        _context.bufferData(
            WebGL.ELEMENT_ARRAY_BUFFER, indexList.buffer, usage);
      }

      geometry.vertices.attributeDataTables.forEach((table) {
        if ((_attributeDataTableReferenceCount[table] ?? 0) >= 1) {
          _attributeDataTableReferenceCount[table] += 1;
        } else {
          var VBO = _context.createBuffer();
          var usage = table.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

          _attributeDataTableVBO[table] = VBO;
          _attributeDataTableReferenceCount[table] = 1;

          context._bindAttributeDataTable(table);
          _context.bufferData(WebGL.ARRAY_BUFFER, table.buffer, usage);
        }
      });

      _isProvisionedGeometry[geometry] = true;
    }
  }

  /// Deprovisions the GPU resources associated with the [geometry].
  ///
  /// Frees each resource associated with the [geometry], unless the [geometry]
  /// shares the resource with another currently provisioned geometry. Returns
  /// `true` if resources were provisioned for the [geometry], `false`
  /// otherwise.
  bool deprovisionFor(IndexGeometry geometry) {
    if (areProvisionedFor(geometry)) {
      final indexList = geometry.indices;

      // When index geometry is deprovisioned but its index list is still used
      // by another index geometry, then the index list's index buffer object
      // (IBO) should not yet be deleted. The IBO is only deleted when the
      // reference count drops to 0.
      if ((_indexListReferenceCount[indexList] ?? 0) > 1) {
        _indexListReferenceCount[indexList] -= 1;
      } else {
        _context.deleteBuffer(_indexListIBO[indexList]);
        _indexListIBO[indexList] = null;
        _indexListReferenceCount[indexList] = null;

        if (indexList == context._boundIndexList) {
          context._bindIndexList(null);
        }
      }

      geometry.vertices.attributeDataTables.forEach((table) {
        // When geometry is deprovisioned but an attribute data table is still
        // used by another geometry, then the attribute data table's vertex
        // buffer object (VBO) should not yet be deleted. The VBO is only
        // deleted when the reference count drops to 0.
        if ((_attributeDataTableReferenceCount[table] ?? 0) > 1) {
          _attributeDataTableReferenceCount[table] -= 1;
        } else {
          _context.deleteBuffer(_attributeDataTableVBO[table]);
          _attributeDataTableVBO[table] = null;
          _attributeDataTableReferenceCount[table] = null;

          if (table == context._boundAttributeDataTable) {
            context._bindAttributeDataTable(null);
          }
        }
      });

      _isProvisionedGeometry[geometry] = null;

      return true;
    } else {
      return false;
    }
  }

  /// Returns the Index Buffer Object (IBO) associated with the [indexList].
  ///
  /// Returns `null` if no resources are provisioned for the [indexList].
  WebGL.Buffer _getIBO(IndexList indexList) => _indexListIBO[indexList];

  /// Returns the Vertex Buffer Object (IBO) associated with the
  /// [attributeDataTable].
  ///
  /// Returns `null` if no resources are provisioned for the
  /// [attributeDataTable].
  WebGL.Buffer _getVBO(AttributeDataTable attributeDataTable) =>
      _attributeDataTableVBO[attributeDataTable];
}
