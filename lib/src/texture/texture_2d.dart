part of bagl.texture;

/// Texture for which the image is 2 dimensional.
class Texture2D implements Texture {
  /// The base image for this [Texture2D].
  final TextureImage image;

  final PixelFormat internalFormat;

  /// Instantiates a new [Texture2D] from the [image].
  Texture2D(TextureImage image)
      : image = image,
        internalFormat = image.format;

  /// Instantiates a new [Texture2D] from the given image [url].
  ///
  /// Optionally an [internalFormat] may be specified for the rendering backend.
  /// The [internalFormat] defaults to [PixelFormat.RGBA].
  factory Texture2D.fromImageURL(String url,
          {internalFormat: PixelFormat.RGBA}) =>
      new Texture2D.fromImageElement(new ImageElement(src: url),
          internalFormat: internalFormat);

  /// Instantiates a new [Texture2D] from the given video [url].
  ///
  /// Optionally an [internalFormat] may be specified for the rendering backend.
  /// The [internalFormat] defaults to [PixelFormat.RGBA].
  factory Texture2D.fromVideoURL(String url,
          {internalFormat: PixelFormat.RGBA}) =>
      new Texture2D.fromVideoElement(new VideoElement()..src = url,
          internalFormat: internalFormat);

  /// Instantiates a new [Texture2D] from the given [imageData].
  ///
  /// Optionally an [internalFormat] may be specified for the rendering backend.
  /// The [internalFormat] defaults to [PixelFormat.RGBA].
  Texture2D.fromImageData(ImageData imageData,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new ImageDataImage(imageData);

  /// Instantiates a new [Texture2D] from the given [imageElement].
  ///
  /// Optionally an [internalFormat] may be specified for the rendering backend.
  /// The [internalFormat] defaults to [PixelFormat.RGBA].
  Texture2D.fromImageElement(ImageElement imageElement,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new ImageElementImage(imageElement);

  /// Instantiates a new [Texture2D] from the given [canvasElement].
  ///
  /// Optionally an [internalFormat] may be specified for the rendering backend.
  /// The [internalFormat] defaults to [PixelFormat.RGBA].
  Texture2D.fromCanvasElement(CanvasElement canvasElement,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new CanvasElementImage(canvasElement);

  /// Instantiates a new [Texture2D] from the given [videoElement].
  ///
  /// Optionally an [internalFormat] may be specified for the rendering backend.
  /// The [internalFormat] defaults to [PixelFormat.RGBA].
  Texture2D.fromVideoElement(VideoElement videoElement,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new VideoElementImage(videoElement);

  int get width => image.width;

  int get height => image.height;

  bool get isReady => image.isReady;

  bool get isDynamic => image.isDynamic;

  Future<Texture2D> asFuture() => image.asFuture().then((_) => this);
}
