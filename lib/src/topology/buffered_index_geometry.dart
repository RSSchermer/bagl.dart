part of topology;

/// Abstract base class for geometry described by a [BufferedVertexCollection]
/// and an index buffer.
///
/// The buffered index collection defines how the vertices in the buffered
/// vertex collection are combined into a sequence of geometry primitives
/// (points, lines or triangles).
///
/// See [Lines], [LineStrip] and [LineLoop] for concrete implementations of
/// [BufferedIndexGeometry] for describing [Line] geometry.
///
/// See [Triangles], [TriangleStrip] and [TriangleFan] for concrete
/// implementations of [BufferedIndexGeometry] for describing [Triangle]
/// geometry.
///
/// See [Points] for a concrete implementation of [BufferedIndexGeometry] for
/// describing [Point] geometry.
abstract class BufferedIndexGeometry {
  /// The vertices on which this buffered index geometry is defined.
  BufferedVertexCollection get vertices;

  /// The indices describing how the [vertices] are combined into geometry
  /// primitives.
  Uint16List get indexBuffer;

  /// Whether or not the index geometry is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that the index geometry
  /// is intended to be modified regularly, allowing the rendering back-end to
  /// optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the index data for geometry that is
  /// not marked as dynamic can still be modified.
  bool get isDynamic;
}
