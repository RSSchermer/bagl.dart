part of web_gl;

/// Describes a rectangular region of the canvas.
///
/// Describes a region offset [x] pixels from the left of the canvas and [y]
/// pixels from the top of the canvas, [width] pixels wide and [height] pixels
/// tall.
class Region {
  /// The horizontal offset from the left of the canvas in pixels.
  final int x;

  /// The vertical offset from the top of the canvas in pixels.
  final int y;

  /// The width of this [Region] in pixels.
  final int width;

  /// The height of this [Region] in pixels.
  final int height;

  /// Returns a new [Region] with the given [x] and [y] offset and the given
  /// [width] and [height].
  const Region(this.x, this.y, this.width, this.height);
}
