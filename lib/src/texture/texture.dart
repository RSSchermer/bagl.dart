part of texture;

/// A container for one or more [TextureImage]s of the same type, the same size
/// and the same image format.
abstract class Texture {
  /// The [PixelFormat] used by the rendering backend to store the texture's
  /// images internally.
  PixelFormat get internalFormat;

  /// This [Texture]'s width in pixels.
  int get width;

  /// This [Texture]'s height in pixels.
  int get height;

  /// Whether or not this [Texture] is ready for rendering.
  bool get isReady;

  /// Whether or not this [Texture]'s image data is dynamic.
  ///
  /// If `false`, then the image data is expected to remain the same for the
  /// lifetime of the texture. If `true`, then the image data may change over
  /// time.
  bool get isDynamic;

  /// Returns a [Future] that resolves to this [Texture] when it is ready for
  /// rendering.
  Future<Texture> asFuture();
}
