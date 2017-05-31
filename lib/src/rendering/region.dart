part of rendering;

/// Describes a rectangular region of a canvas.
///
/// Describes a region offset [x] pixels from the left of the canvas and [y]
/// pixels from the top of the canvas, [width] pixels wide and [height] pixels
/// tall.
class Region {
  /// The horizontal offset of the bottom left corner of this [Region] from the
  /// left of the canvas in pixels.
  final int x;

  /// The vertical offset of the bottom left corner of this [Region] from the
  /// bottom of the canvas in pixels.
  final int y;

  /// The width of this [Region] in pixels.
  final int width;

  /// The height of this [Region] in pixels.
  final int height;

  /// Returns a new [Region] with the given [x] and [y] offset and the given
  /// [width] and [height].
  const Region(this.x, this.y, this.width, this.height);

  bool operator ==(other) =>
      identical(other, this) ||
      other is Region &&
          other.x == x &&
          other.y == y &&
          other.width == width &&
          other.height == height;

  int get hashCode =>
      hash4(x.hashCode, y.hashCode, width.hashCode, height.hashCode);

  String toString() => 'Region($x, $y, $width, $height)';
}
