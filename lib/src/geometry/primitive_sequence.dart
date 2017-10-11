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
abstract class PrimitiveSequence<Primitive>
    implements PrimitiveSource, Iterable<Primitive> {}
