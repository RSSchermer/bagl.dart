part of web_gl;

abstract class Texture {
  PixelFormat get internalFormat;

  int get width;

  int get height;

  bool get isReady;

  Future<Texture> asFuture();
}

class Texture2D implements Texture {
  final TextureImage image;

  final PixelFormat internalFormat;

  Texture2D(TextureImage image)
      : image = image,
        internalFormat = image.format;

  factory Texture2D.fromImageURL(String url,
          {internalFormat: PixelFormat.RGBA}) =>
      new Texture2D.fromImageElement(new ImageElement(src: url),
          internalFormat: internalFormat);

  factory Texture2D.fromVideoURL(String url,
          {internalFormat: PixelFormat.RGBA}) =>
      new Texture2D.fromVideoElement(new VideoElement()..src = url,
          internalFormat: internalFormat);

  Texture2D.fromImageData(ImageData imageData,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new ImageDataImage(imageData);

  Texture2D.fromImageElement(ImageElement imageElement,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new ImageElementImage(imageElement);

  Texture2D.fromCanvasElement(CanvasElement canvasElement,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new CanvasElementImage(canvasElement);

  Texture2D.fromVideoElement(VideoElement videoElement,
      {this.internalFormat: PixelFormat.RGBA})
      : image = new VideoElementImage(videoElement);

  PixelFormat get externalFormat => image.format;

  PixelType get externalType => image.type;

  int get width => image.width;

  int get height => image.height;

  bool get isReady => image.isReady;

  Future<Texture2D> asFuture() => image.asFuture().then((_) => this);
}

abstract class TextureImage {
  int get width;

  int get height;

  bool get isReady;

  bool get isDynamic;

  PixelFormat get format;

  PixelType get type;

  TypedData getPixelData();

  Future<TextureImage> asFuture();
}

class ImageDataImage implements TextureImage {
  final ImageData imageData;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isReady = true;

  final bool isDynamic = false;

  Uint8ClampedList _data;

  ImageDataImage(this.imageData);

  int get width => imageData.width;

  int get height => imageData.height;

  Uint8ClampedList getPixelData() {
    _data ??= new Uint8ClampedList.fromList(imageData.data);

    return _data;
  }

  Future<ImageDataImage> asFuture() => new Future.value(this);
}

class ImageElementImage implements TextureImage {
  final ImageElement imageElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isDynamic = false;

  Uint8ClampedList _data;

  ImageElementImage(this.imageElement);

  int get width => imageElement.naturalWidth;

  int get height => imageElement.naturalHeight;

  bool get isReady => imageElement.complete;

  Uint8ClampedList getPixelData() {
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

  Future<ImageDataImage> asFuture() =>
      imageElement.onLoad.first.then((i) => this);
}

class CanvasElementImage implements TextureImage {
  final CanvasElement canvasElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isDynamic;

  final bool isReady = true;

  Uint8ClampedList _data;

  CanvasElementImage(this.canvasElement, {this.isDynamic: false});

  int get width => canvasElement.width;

  int get height => canvasElement.height;

  Uint8ClampedList getPixelData() {
    if (isDynamic || _data == null) {
      final context = canvasElement.context2D;
      final data = context.getImageData(0, 0, width, height).data;

      _data = new Uint8ClampedList.fromList(data);
    }

    return _data;
  }

  Future<CanvasElementImage> asFuture() => new Future.value(this);
}

class VideoElementImage implements TextureImage {
  final VideoElement videoElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final isDynamic = true;

  VideoElementImage(this.videoElement);

  bool get isReady => videoElement.readyState >= 2;

  int get width => videoElement.videoWidth;

  int get height => videoElement.videoHeight;

  Uint8ClampedList getPixelData() {
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

class Uint8ListImage implements TextureImage {
  final Uint8List data;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  Uint8ListImage.RGB(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedByte;

  Uint8ListImage.RGBA(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedByte;

  Uint8ListImage.luminance(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminance,
        type = PixelType.unsignedByte;

  Uint8ListImage.luminanceAlpha(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminanceAlpha,
        type = PixelType.unsignedByte;

  Uint8ListImage.alpha(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.alpha,
        type = PixelType.unsignedByte;

  Uint8List getPixelData() => data;

  Future<Uint8ListImage> asFuture() => new Future.value(this);
}

class Uint8ClampedListImage implements TextureImage {
  final Uint8ClampedList data;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  Uint8ClampedListImage.RGB(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedByte;

  Uint8ClampedListImage.RGBA(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedByte;

  Uint8ClampedListImage.luminance(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminance,
        type = PixelType.unsignedByte;

  Uint8ClampedListImage.luminanceAlpha(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminanceAlpha,
        type = PixelType.unsignedByte;

  Uint8ClampedListImage.alpha(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.alpha,
        type = PixelType.unsignedByte;

  Uint8ClampedList getPixelData() => data;

  Future<Uint8ClampedListImage> asFuture() => new Future.value(this);
}

class Uint16ListImage implements TextureImage {
  final Uint16List data;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  Uint16ListImage.R5G6B5(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedShort_5_6_5;

  Uint16ListImage.R4G4B4A4(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedShort_4_4_4_4;

  Uint16ListImage.R5G5B5A1(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedShort_5_5_5_1;

  Uint16List getPixelData() => data;

  Future<Uint16ListImage> asFuture() => new Future.value(this);
}

enum PixelFormat { RGB, RGBA, luminance, luminanceAlpha, alpha, _depth }

enum PixelType {
  unsignedByte,
  unsignedShort_5_6_5,
  unsignedShort_4_4_4_4,
  unsignedShort_5_5_5_1,
  _unsignedShort
}
