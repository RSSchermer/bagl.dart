part of bagl.geometry;

/// Abstract base class for geometry described by a sequence of geometric
/// primitives.
///
/// Combines its [vertexArray] into a sequence of [Point]s, [Line]s or
/// [Triangle]s. The [indexList] describes which vertices, and in what order,
/// are drawn from the [vertexArray]. The [topology] determines how this vertex
/// sequence is combined into a sequence of geometric primitives.
///
/// See [Lines], [LineStrip] and [LineLoop] for concrete implementations of
/// [PrimitiveSequence] for describing [Line] geometry.
///
/// See [Triangles], [TriangleStrip] and [TriangleFan] for concrete
/// implementations of [PrimitiveSequence] for describing [Triangle] geometry.
///
/// See [Points] for a concrete implementation of [PrimitiveSequence] for
/// describing [Point] geometry.
abstract class PrimitiveSequence<Primitive> extends Iterable<Primitive> {
  /// The [Topology] for this [PrimitiveSequence].
  Topology get topology;

  /// The [VertexArray] on which this [PrimitiveSequence] is defined.
  VertexArray get vertexArray;

  /// A list of indices that describes which of vertices the [vertexArray], and
  /// in which order, are used to compose primitive sequence.
  ///
  /// May be `null`, in which case an implicit index list is used that ranges
  /// from `0` to `vertexArray.length - 1`:
  /// `0, 1, 2, .., vertexArray.length - 1`.
  IndexList get indexList;

  /// The number of vertices that are skipped before the vertices used by these
  /// [PrimitiveSequence] begin.
  ///
  /// If an [indexList] is specified, then this value represents the number of
  /// indices that are skipped before the indices used by this [PrimitiveSequence]
  /// begin.
  int get offset;

  /// The number of vertices used to define this [PrimitiveSequence].
  int get count;
}
