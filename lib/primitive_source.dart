/// This library defines the [PrimitiveSource] interface: the minimal interface
/// that a data structure must implement to be renderable by BaGL.
library bagl.primitive_source;

import 'dart:typed_data';

/// Enumerates the ways in which a sequence of vertices connected into a
/// sequence of drawable primitives.
///
/// See the corresponding [PrimitiveSequence] implementations for details on
/// how each of these topologies connect vertices:
///
/// - [points]: [Points].
/// - [lines]: [Lines].
/// - [lineStrip]: [LineStrip].
/// - [lineLoop]: [LineLoop].
/// - [triangles]: [Triangles].
/// - [triangleStrip]: [TriangleStrip].
/// - [triangleFan]: [TriangleFan].
///
enum Topology {
  points,
  lines,
  lineStrip,
  lineLoop,
  triangles,
  triangleStrip,
  triangleFan
}

/// Enumerates the available data types for attribute data.
enum AttributeDataType { byte, short, unsignedByte, unsignedShort, float }

/// Enumerates the available data types for index data.
enum IndexDataType { unsignedByte, unsignedShort, unsignedInt }

/// A source of render primitives that can be drawn by a rendering back-end.
abstract class PrimitiveSource {
  /// The [Topology] for this [PrimitiveSequence].
  ///
  /// Determines how the [vertices] are to be connected into render primitives.
  Topology get topology;

  /// The [VertexDataSource] that provides the vertices on which this
  /// [PrimitiveSource] is defined.
  VertexDataSource get vertices;

  /// A source for indices that describes which of the [vertices], and in which
  /// order, are to be used to compose the primitives.
  ///
  /// May be `null`, in which case an implicit sequence of indices is used that
  /// ranges from `0` to `vertices.length - 1`:
  /// `0, 1, 2, .., vertices.length - 1`.
  IndexData get indices;

  /// The number of [vertices] that are skipped before the vertices that are to
  /// be used to compose the primitives begin.
  ///
  /// If [indices] are specified, then this value represents the number of
  /// indices that are skipped before the indices used by this [PrimitiveSource]
  /// begin.
  int get offset;

  /// The number of vertices used by this [PrimitiveSource].
  int get count;
}

/// A source of vertex data as a set of [VertexAttributePointer]s defined on
/// [AttributeData].
abstract class VertexDataSource {
  /// The version of this [VertexDataSource].
  ///
  /// Should change to a new version whenever any property of the individual
  /// [VertexAttributePointer]s that make up these [VertexAttributePointers]
  /// changes.
  int get version;

  /// Returns the [VertexAttributePointer] for the given [attribute] or `null`
  /// if no such attribute exists for this [VertexDataSource].
  VertexAttributePointer attributePointer(String attribute);
}

/// Defines a typed array of data for 1 vertex attribute.
class VertexAttributePointer {
  /// The [AttributeData] this [VertexAttributePointer] points to.
  final AttributeData data;

  /// The number of columns used by this attribute.
  ///
  /// Corresponds to the number of attribute locations occupied by an attribute
  /// of this type in a GLSL shader program.
  final int columnCount;

  /// The number of elements per column for an attribute of this type.
  final int columnSize;

  /// The number of bytes that are to be skipped at the start of the [data]
  /// before the sequence of bytes for the first attribute value starts.
  final int offsetInBytes;

  /// The offset in bytes between the beginning of consecutive vertex
  /// attributes.
  final int strideInBytes;

  /// Whether integer data values should be normalized when being casted to a
  /// float.
  ///
  /// If the [data] is of type [AttributeDataType.unsignedByte] or
  /// [AttributeDataType.short], then elements are normalized to the range
  /// `[-1.0, 1.0]`.
  ///
  /// If the [data] is of type [AttributeDataType.byte] or
  /// [AttributeDataType.unsignedShort], then elements are normalized to the
  /// range `[0.0, 1.0]`.
  ///
  /// If the [data] is of type [AttributeDataType.float], then [normalize] is
  /// ignored.
  final bool normalize;

  /// Instantiates a new [VertexAttributePointer].
  VertexAttributePointer(this.data, this.columnCount, this.columnSize,
      this.offsetInBytes, this.strideInBytes, this.normalize);
}

/// Attribute data stored in contiguous memory.
abstract class AttributeData extends TypedData {
  /// The type of the attribute data.
  AttributeDataType get type;

  /// Whether or not this [AttributeData] is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that the data is intended
  /// to be modified regularly, allowing the rendering back-end to optimize for
  /// this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: [AttributeData] that is not marked as
  /// dynamic can still be modified.
  bool get isDynamic;

  /// Returns a version number for the data.
  ///
  /// May be used by a rendering backend that buffers a copy of the data to
  /// determine if the copy is out of date.
  int get version;
}

/// Index data stored in contiguous memory.
abstract class IndexData extends TypedData {
  /// The type of the index data.
  IndexDataType get type;

  /// Whether or not this [IndexData] is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that the data is intended
  /// to be modified regularly, allowing the rendering back-end to optimize for
  /// this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: [IndexData] that is not marked as
  /// dynamic can still be modified.
  bool get isDynamic;

  /// Returns a version number for the data.
  ///
  /// May be used by a rendering backend that buffers a copy of the data to
  /// determine if the copy is out of date.
  int get version;
}
