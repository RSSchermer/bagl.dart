part of texture;

/// A collection of pixels of a certain dimensionality.
abstract class TextureImage {
  /// The width of the image in pixels.
  int get width;

  /// The height of the image in pixels.
  int get height;

  /// Whether or not the image is ready for rendering.
  bool get isReady;

  /// Whether or not this [TextureImage]'s pixel data is dynamic.
  ///
  /// If `false`, then the pixel data is expected to remain the same for the
  /// lifetime of the texture. If `true`, then the pixel data may change over
  /// time.
  bool get isDynamic;

  /// The [PixelFormat] in which the [data] stores pixels.
  PixelFormat get format;

  /// The [PixelType] of the [data].
  PixelType get type;

  /// The pixel data for this image.
  TypedData get data;

  /// Returns a [Future] that resolves to this [TextureImage] when it is ready
  /// for rendering.
  Future<TextureImage> asFuture();
}

/// A [TextureImage] for which the data source is [ImageData].
///
/// The [format] of an [ImageDataImage] is always [PixelFormat.RGBA] and the
/// [type] of an [ImageDataImage] is always [PixelType.unsignedByte].
class ImageDataImage implements TextureImage {
  /// The [ImageData] that serves as the source of this [ImageDataImage]'s pixel
  /// data.
  final ImageData imageData;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isReady = true;

  final bool isDynamic = false;

  Uint8ClampedList _data;

  /// Instantiates a new [ImageDataImage].
  ImageDataImage(this.imageData);

  int get width => imageData.width;

  int get height => imageData.height;

  Uint8ClampedList get data {
    _data ??= new Uint8ClampedList.fromList(imageData.data);

    return _data;
  }

  Future<ImageDataImage> asFuture() => new Future.value(this);
}

/// A [TextureImage] for which the data source is an [ImageElement].
///
/// The [format] of an [ImageElementImage] is always [PixelFormat.RGBA] and the
/// [type] of an [ImageElementImage] is always [PixelType.unsignedByte].
class ImageElementImage implements TextureImage {
  /// The [ImageElement] that serves as the source of this [ImageElementImage]'s
  /// pixel data.
  final ImageElement imageElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isDynamic = false;

  Uint8ClampedList _data;

  /// Instantiates a new [ImageElementImage] for the [imageElement].
  ImageElementImage(this.imageElement);

  int get width => imageElement.naturalWidth;

  int get height => imageElement.naturalHeight;

  bool get isReady => imageElement.complete;

  Uint8ClampedList get data {
    if (!isReady) {
      throw new StateError('The image element has not finished loading.');
    }

    if (_data == null) {
      final canvas = new CanvasElement(width: width, height: height);
      final context = canvas.context2D;

      context.drawImage(imageElement, 0, 0);

      final data = context.getImageData(0, 0, width, height).data;

      _data = new Uint8ClampedList.fromList(data);
    }

    return _data;
  }

  Future<ImageElementImage> asFuture() =>
      imageElement.onLoad.first.then((i) => this);
}

/// A [TextureImage] for which the data source is a [CanvasElement].
///
/// The [format] of an [CanvasElementImage] is always [PixelFormat.RGBA] and the
/// [type] of an [CanvasElementImage] is always [PixelType.unsignedByte].
class CanvasElementImage implements TextureImage {
  /// The [CanvasElement] that serves as the source of this
  /// [CanvasElementImage]'s pixel data.
  final CanvasElement canvasElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isDynamic;

  final bool isReady = true;

  Uint8ClampedList _data;

  /// Instantiates a new [CanvasElementImage] for the [canvasElement].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the
  /// [canvasElement]'s image data may change over time. [isDynamic] defaults to
  /// `false`.
  CanvasElementImage(this.canvasElement, {this.isDynamic: false});

  int get width => canvasElement.width;

  int get height => canvasElement.height;

  Uint8ClampedList get data {
    if (isDynamic || _data == null) {
      final context = canvasElement.context2D;
      final data = context.getImageData(0, 0, width, height).data;

      _data = new Uint8ClampedList.fromList(data);
    }

    return _data;
  }

  Future<CanvasElementImage> asFuture() => new Future.value(this);
}

/// A [TextureImage] for which the data source is a [VideoElement].
///
/// The [format] of an [VideoElementImage] is always [PixelFormat.RGBA] and the
/// [type] of an [VideoElementImage] is always [PixelType.unsignedByte].
/// [isDynamic] is always `true` for a [VideoElementImage].
class VideoElementImage implements TextureImage {
  /// The [VideoElement] that serves as the source of this
  /// [VideoElementImage]'s pixel data.
  final VideoElement videoElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final isDynamic = true;

  /// Instantiates a new [ImageElementImage] for the [videoElement].
  VideoElementImage(this.videoElement);

  bool get isReady => videoElement.readyState >= 2;

  int get width => videoElement.videoWidth;

  int get height => videoElement.videoHeight;

  Uint8ClampedList get data {
    if (!isReady) {
      throw new StateError(
          'The video element has not yet loaded sufficient data.');
    }

    final canvas = new CanvasElement(width: width, height: height);
    final context = canvas.context2D;

    context.drawImage(videoElement, 0, 0);

    final data = context.getImageData(0, 0, width, height).data;

    return new Uint8ClampedList.fromList(data);
  }

  Future<VideoElementImage> asFuture() =>
      videoElement.onLoadedData.first.then((_) => this);
}

/// A [TextureImage] for which the data source is a [Uint8List].
///
/// The [type] of a [Uint8ListImage] is always [PixelType.unsignedByte]. Each
/// pixel channel in a [Uint8ListImage] is stored as a separate byte.
class Uint8ListImage implements TextureImage {
  /// The [Uint8List] that serves as this [Uint8ListImage]'s pixel data.
  final Uint8List uint8List;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  /// Instantiates a new RGB [Uint8ListImage] from the [uint8List].
  ///
  /// The [Uint8ListImage]'s format will be [PixelFormat.RGB]. The image's
  /// dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ListImage.RGB(this.width, this.height, this.uint8List,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedByte;

  /// Instantiates a new RGBA [Uint8ListImage] from the [uint8List].
  ///
  /// The [Uint8ListImage]'s format will be [PixelFormat.RGBA]. The image's
  /// dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ListImage.RGBA(this.width, this.height, this.uint8List,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedByte;

  /// Instantiates a new luminance [Uint8ListImage] from the [uint8List].
  ///
  /// The [Uint8ListImage]'s format will be [PixelFormat.luminance]. The image's
  /// dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ListImage.luminance(this.width, this.height, this.uint8List,
      {this.isDynamic: false})
      : format = PixelFormat.luminance,
        type = PixelType.unsignedByte;

  /// Instantiates a new luminanceAlpha [Uint8ListImage] from the [uint8List].
  ///
  /// The [Uint8ListImage]'s format will be [PixelFormat.luminanceAlpha]. The
  /// image's dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ListImage.luminanceAlpha(this.width, this.height, this.uint8List,
      {this.isDynamic: false})
      : format = PixelFormat.luminanceAlpha,
        type = PixelType.unsignedByte;

  /// Instantiates a new alpha [Uint8ListImage] from the [uint8List].
  ///
  /// The [Uint8ListImage]'s format will be [PixelFormat.alpha]. The image's
  /// dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ListImage.alpha(this.width, this.height, this.uint8List,
      {this.isDynamic: false})
      : format = PixelFormat.alpha,
        type = PixelType.unsignedByte;

  Uint8List get data => uint8List;

  Future<Uint8ListImage> asFuture() => new Future.value(this);
}

/// A [TextureImage] for which the data source is a [Uint8ClampedList].
///
/// The [type] of a [Uint8ClampedListImage] is always [PixelType.unsignedByte].
/// Each pixel channel in a [Uint8ClampedListImage] is stored as a separate
/// byte.
class Uint8ClampedListImage implements TextureImage {
  /// The [Uint8ClampedList] that serves as this [Uint8ClampedListImage]'s pixel
  /// data.
  final Uint8ClampedList uint8ClampedList;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  /// Instantiates a new RGB [Uint8ClampedListImage] from the
  /// [uint8ClampedList].
  ///
  /// The [Uint8ClampedListImage]'s format will be [PixelFormat.RGB]. The
  /// image's dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ClampedListImage.RGB(this.width, this.height, this.uint8ClampedList,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedByte;

  /// Instantiates a new RGBA [Uint8ClampedListImage] from the
  /// [uint8ClampedList].
  ///
  /// The [Uint8ClampedListImage]'s format will be [PixelFormat.RGBA]. The
  /// image's dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ClampedListImage.RGBA(this.width, this.height, this.uint8ClampedList,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedByte;

  /// Instantiates a new luminance [Uint8ClampedListImage] from the
  /// [uint8ClampedList].
  ///
  /// The [Uint8ClampedListImage]'s format will be [PixelFormat.luminance]. The
  /// image's dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ClampedListImage.luminance(
      this.width, this.height, this.uint8ClampedList,
      {this.isDynamic: false})
      : format = PixelFormat.luminance,
        type = PixelType.unsignedByte;

  /// Instantiates a new luminanceAlpha [Uint8ClampedListImage] from the
  /// [uint8ClampedList].
  ///
  /// The [Uint8ClampedListImage]'s format will be [PixelFormat.luminanceAlpha].
  /// The image's dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ClampedListImage.luminanceAlpha(
      this.width, this.height, this.uint8ClampedList,
      {this.isDynamic: false})
      : format = PixelFormat.luminanceAlpha,
        type = PixelType.unsignedByte;

  /// Instantiates a new alpha [Uint8ClampedListImage] from the
  /// [uint8ClampedList].
  ///
  /// The [Uint8ClampedListImage]'s format will be [PixelFormat.alpha]. The
  /// image's dimensions will be [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint8ClampedListImage.alpha(this.width, this.height, this.uint8ClampedList,
      {this.isDynamic: false})
      : format = PixelFormat.alpha,
        type = PixelType.unsignedByte;

  Uint8ClampedList get data => uint8ClampedList;

  Future<Uint8ClampedListImage> asFuture() => new Future.value(this);
}

/// A [TextureImage] for which the data source is a [Uint16List].
///
/// Each pixel in a [Uint16ListImage] is stored as a single unsigned short. The
/// [type] of a [Uint16ListImage] may be [PixelType.unsignedShort_5_6_5],
/// [PixelType.unsignedShort_4_4_4_4] or [PixelType.unsignedShort_5_5_5_1], see
/// the documentation for [PixelType] for details.
class Uint16ListImage implements TextureImage {
  /// The [Uint16List] that serves as this [Uint16ListImage]'s pixel data.
  final Uint16List uint16List;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  /// Instantiates a new RGB [Uint16ListImage] from the [Uint16List] using 5
  /// bits for Red, 6 bits for Green and 5 bits for Blue.
  ///
  /// The [Uint16ListImage]'s format will be [PixelFormat.RGB] and the type
  /// will be [PixelType.unsignedShort_5_6_5]. The image's dimensions will be
  /// [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint16ListImage.R5G6B5(this.width, this.height, this.uint16List,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedShort_5_6_5;

  /// Instantiates a new RGBA [Uint16ListImage] from the [Uint16List] using 4
  /// bits for Red, 4 bits for Green, 4 bits for Blue and 4 bits for Alpha.
  ///
  /// The [Uint16ListImage]'s format will be [PixelFormat.RGBA] and the type
  /// will be [PixelType.unsignedShort_4_4_4_4]. The image's dimensions will be
  /// [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint16ListImage.R4G4B4A4(this.width, this.height, this.uint16List,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedShort_4_4_4_4;

  /// Instantiates a new RGBA [Uint16ListImage] from the [Uint16List] using 5
  /// bits for Red, 5 bits for Green, 5 bits for Blue and 1 bit for Alpha.
  ///
  /// The [Uint16ListImage]'s format will be [PixelFormat.RGBA] and the type
  /// will be [PixelType.unsignedShort_5_5_5_1]. The image's dimensions will be
  /// [width] by [height].
  ///
  /// Optionally, [isDynamic] may be specified as `true` if the image data may
  /// change over time. [isDynamic] defaults to `false`.
  Uint16ListImage.R5G5B5A1(this.width, this.height, this.uint16List,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedShort_5_5_5_1;

  Uint16List get data => uint16List;

  Future<Uint16ListImage> asFuture() => new Future.value(this);
}
