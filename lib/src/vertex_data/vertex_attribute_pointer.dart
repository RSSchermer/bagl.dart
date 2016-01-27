part of vertex_data;

/// Data structure which provides the information necessary for iterating over
/// an array attribute values stored in a byte buffer.
class VertexAttributePointer {
  /// The byte buffer which stores the attribute data.
  final ByteBuffer buffer;

  /// The offset in bytes at which the attribute values start, relative to the
  /// start of the byte buffer.
  final int offsetInBytes;

  /// The size of an attribute value in the number of floats.
  final int size;

  /// The stride in bytes between attribute value in the byte buffer.
  final int strideInBytes;

  /// Instantiates a new [VertexAttributePointer] on the given [buffer].
  VertexAttributePointer(this.buffer,
      [this.size = 4, this.strideInBytes = 0, this.offsetInBytes = 0]);
}
