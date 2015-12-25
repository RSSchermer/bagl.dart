part of vertex_data;

class VertexAttributePointer {
  final ByteBuffer buffer;

  final int offsetInBytes;

  final int sizeInBytes;

  final int strideInBytes;

  VertexAttributePointer(this.buffer,
      [this.sizeInBytes = 4, this.strideInBytes = 0, this.offsetInBytes = 0]);
}
