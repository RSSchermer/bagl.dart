part of rendering;

/// Specifies for each color components whether or not it can be written to the
/// color buffer.
///
/// Color consists of 4 individual components: a red component, a blue
/// component, a green component, and an alpha (opacity) component. Whether or
/// not these components can be written to the color buffer is controlled for
/// each component individually by [writeRed], [writeGreen], [writeBlue] and
/// [writeAlpha] respectively.
class ColorMask {
  /// Whether or not the red color component can be written to the color buffer.
  final bool writeRed;

  /// Whether or not the green color component can be written to the color
  /// buffer.
  final bool writeGreen;

  /// Whether or not the blue color component can be written to the color
  /// buffer.
  final bool writeBlue;

  /// Whether or not the alpha component can be written to the color buffer.
  final bool writeAlpha;

  /// Returns a new [ColorMask].
  const ColorMask(
      this.writeRed, this.writeGreen, this.writeBlue, this.writeAlpha);

  bool operator ==(other) =>
      identical(other, this) ||
      other is ColorMask &&
          other.writeRed == writeRed &&
          other.writeGreen == writeGreen &&
          other.writeBlue == writeBlue &&
          other.writeAlpha == writeAlpha;

  int get hashCode => hash4(writeRed.hashCode, writeGreen.hashCode,
      writeBlue.hashCode, writeAlpha.hashCode);
}
