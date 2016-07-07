part of rendering;

/// Manages the provisioning and deprovisioning of geometry related resources
/// for a [RendingContext].
class _ContextGeometryResourceManager {
  /// The [RenderingContext] managed by this [_ContextGeometryResourceManager].
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  /// The geometries for which resources are currently provisioned.
  Set<IndexGeometry> _provisionedGeometries = new Set();

  /// Map from index lists to their associated index buffer objects (IBOs).
  Map<IndexList, WebGL.Buffer> _indexListIBOs = new Map();

  /// Map from attribute data tables to their associated vertex buffer objects
  /// (VBOs).
  Map<AttributeDataTable, WebGL.Buffer> _attributeDataTableVBOs = new Map();

  /// Map to keep track of reference counts for index lists.
  ///
  /// An [IndexList] may be used by multiple geometries attached to this
  /// context. If 3 different geometries use the same [IndexList], then the
  /// reference count for that [IndexList] will be 3.
  Map<IndexList, int> _indexListReferenceCounts = new Map();

  /// Map to keep track of reference counts for attribute data tables.
  ///
  /// An [AttributeDataTable] may be used by multiple geometries attached to
  /// this context. If 3 different geometries use the same [AttributeDataTable],
  /// then the reference count for that [AttributeDataTable] will be 3.
  Map<AttributeDataTable, int> _attributeDataTableReferenceCounts = new Map();

  /// Instantiates a new [_ContextGeometryResourceManager] for the [context].
  _ContextGeometryResourceManager(RenderingContext context)
      : context = context,
        _context = context._context;

  /// The geometries for which resources are currently provisioned.
  Iterable<IndexGeometry> get provisionedGeometries =>
      new UnmodifiableSetView(_provisionedGeometries);

  /// Provisions resources for the [geometry].
  ///
  /// Sets up data buffers for the [geometry]'s index and attribute data. If the
  /// [geometry] shares data with other geometries for which resources have been
  /// previously provisioned, then these resources will be reused.
  void provision(IndexGeometry geometry) {
    if (!_provisionedGeometries.contains(geometry)) {
      final indices = geometry.indices;

      if ((_indexListReferenceCounts[indices] ?? 0) >= 1) {
        _indexListReferenceCounts[indices] += 1;
      } else {
        final indexDataVBO = _context.createBuffer();
        final usage =
            indices.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

        _indexListIBOs[indices] = indexDataVBO;
        _indexListReferenceCounts[indices] = 1;

        context._bindIndexList(indices);
        _context.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices.buffer, usage);
      }

      geometry.vertices.attributeDataTables.forEach((table) {
        if ((_attributeDataTableReferenceCounts[table] ?? 0) >= 1) {
          _attributeDataTableReferenceCounts[table] += 1;
        } else {
          var frameVBO = _context.createBuffer();
          var usage = table.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

          _attributeDataTableVBOs[table] = frameVBO;
          _attributeDataTableReferenceCounts[table] = 1;

          context._bindAttributeDataTable(table);
          _context.bufferData(WebGL.ARRAY_BUFFER, table.buffer, usage);
        }
      });

      _provisionedGeometries.add(geometry);
    }
  }

  /// Deprovisions the resources associated with the [geometry].
  ///
  /// Frees each resource associated with the [geometry], unless the [geometry]
  /// shares the resource with another currently provisioned geometry. Returns
  /// `true` if resources were provisioned for the [geometry], `false`
  /// otherwise.
  bool deprovision(IndexGeometry geometry) {
    if (_provisionedGeometries.contains(geometry)) {
      final indexList = geometry.indices;

      // When index geometry is deprovisioned but its index list is still used
      // by another index geometry, then the index list's index buffer object
      // (IBO) should not yet be deleted. The IBO is only deleted when the
      // reference count drops to 0.
      if (_indexListReferenceCounts[indexList] > 1) {
        _indexListReferenceCounts[indexList] -= 1;
      } else {
        _context.deleteBuffer(_indexListIBOs[indexList]);
        _indexListIBOs.remove(geometry);
        _indexListReferenceCounts.remove(indexList);

        if (indexList == context._boundIndexList) {
          context._bindIndexList(null);
        }
      }

      geometry.vertices.attributeDataTables.forEach((table) {
        // When geometry is deprovisioned but an attribute data table is still
        // used by another geometry, then the attribute data table's vertex
        // buffer object (VBO) should not yet be deleted. The VBO is only
        // deleted when the reference count drops to 0.
        if (_attributeDataTableReferenceCounts[table] > 1) {
          _attributeDataTableReferenceCounts[table] -= 1;
        } else {
          _context.deleteBuffer(_attributeDataTableVBOs[table]);
          _attributeDataTableVBOs.remove(table);
          _attributeDataTableReferenceCounts.remove(table);

          if (table == context._boundAttributeDataTable) {
            context._bindAttributeDataTable(null);
          }
        }
      });

      _provisionedGeometries.remove(geometry);

      return true;
    } else {
      return false;
    }
  }

  /// Returns the Index Buffer Object (IBO) associated with the [indexList].
  ///
  /// Returns `null` if no resources are provisioned for the [indexList].
  WebGL.Buffer getIBO(IndexList indexList) => _indexListIBOs[indexList];

  /// Returns the Vertex Buffer Object (IBO) associated with the
  /// [attributeDataTable].
  ///
  /// Returns `null` if no resources are provisioned for the
  /// [attributeDataTable].
  WebGL.Buffer getVBO(AttributeDataTable attributeDataTable) =>
      _attributeDataTableVBOs[attributeDataTable];
}
