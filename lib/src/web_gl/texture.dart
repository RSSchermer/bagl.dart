part of web_gl;

enum PixelFormat { RGB, RGBA, luminance, luminanceAlpha, alpha, _depth }

enum PixelType {
  unsignedByte,
  unsignedShort_5_6_5,
  unsignedShort_4_4_4_4,
  unsignedShort_5_5_5_1,
  _unsignedShort
}

class Texture2D {
  final TextureSource source;

  final PixelFormat internalFormat;

  Texture2D(TextureSource source)
      : source = source,
        internalFormat = source.format;

  factory Texture2D.fromURL(String url, {internalFormat: PixelFormat.RGBA}) =>
      new Texture2D.fromImageElement(new ImageElement(src: url),
          internalFormat: internalFormat);

  Texture2D.fromImageData(ImageData imageData,
      {this.internalFormat: PixelFormat.RGBA})
      : source = new ImageDataTextureSource(imageData);

  Texture2D.fromImageElement(ImageElement imageElement,
      {this.internalFormat: PixelFormat.RGBA})
      : source = new ImageElementTextureSource(imageElement);

  Texture2D.fromCanvasElement(CanvasElement canvasElement,
      {this.internalFormat: PixelFormat.RGBA})
      : source = new CanvasElementTextureSource(canvasElement);

  Texture2D.fromVideoElement(VideoElement videoElement,
      {this.internalFormat: PixelFormat.RGBA})
      : source = new VideoElementTextureSource(videoElement);
}

abstract class TextureSource {
  int get width;

  int get height;

  bool get isReady;

  bool get isDynamic;

  PixelFormat get format;

  PixelType get type;

  TypedData getData();
}

class ImageDataTextureSource implements TextureSource {
  final ImageData imageData;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isReady = true;

  final bool isDynamic = false;

  Uint8ClampedList _data;

  ImageDataTextureSource(this.imageData);

  int get width => imageData.width;

  int get height => imageData.height;

  Uint8ClampedList getData() {
    _data ??= new Uint8ClampedList.fromList(imageData.data);

    return _data;
  }
}

class ImageElementTextureSource implements TextureSource {
  final ImageElement imageElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isDynamic = false;

  Uint8ClampedList _data;

  ImageElementTextureSource(this.imageElement);

  int get width => imageElement.naturalWidth;

  int get height => imageElement.naturalHeight;

  bool get isReady => imageElement.complete;

  Uint8ClampedList getData() {
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
}

class CanvasElementTextureSource implements TextureSource {
  final CanvasElement canvasElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final bool isDynamic;

  final bool isReady = true;

  Uint8ClampedList _data;

  CanvasElementTextureSource(this.canvasElement, {this.isDynamic: false});

  int get width => canvasElement.width;

  int get height => canvasElement.height;

  Uint8ClampedList getData() {
    if (isDynamic || _data == null) {
      final context = canvasElement.context2D;
      final data = context.getImageData(0, 0, width, height).data;

      _data = new Uint8ClampedList.fromList(data);
    }

    return _data;
  }
}

class VideoElementTextureSource implements TextureSource {
  final VideoElement videoElement;

  final PixelFormat format = PixelFormat.RGBA;

  final PixelType type = PixelType.unsignedByte;

  final isDynamic = true;

  VideoElementTextureSource(this.videoElement);

  bool get isReady => videoElement.readyState >= 2;

  int get width => videoElement.videoWidth;

  int get height => videoElement.videoHeight;

  Uint8ClampedList getData() {
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
}

class Uint8ListTextureSource implements TextureSource {
  final Uint8List data;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  Uint8ListTextureSource.RGB(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedByte;

  Uint8ListTextureSource.RGBA(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedByte;

  Uint8ListTextureSource.luminance(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminance,
        type = PixelType.unsignedByte;

  Uint8ListTextureSource.luminanceAlpha(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminanceAlpha,
        type = PixelType.unsignedByte;

  Uint8ListTextureSource.alpha(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.alpha,
        type = PixelType.unsignedByte;

  Uint8List getData() => data;
}

class Uint8ClampedListTextureSource implements TextureSource {
  final Uint8ClampedList data;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  Uint8ClampedListTextureSource.RGB(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedByte;

  Uint8ClampedListTextureSource.RGBA(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedByte;

  Uint8ClampedListTextureSource.luminance(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminance,
        type = PixelType.unsignedByte;

  Uint8ClampedListTextureSource.luminanceAlpha(
      this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.luminanceAlpha,
        type = PixelType.unsignedByte;

  Uint8ClampedListTextureSource.alpha(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.alpha,
        type = PixelType.unsignedByte;

  Uint8ClampedList getData() => data;
}

class Uint16ListTextureSource implements TextureSource {
  final Uint16List data;

  final PixelFormat format;

  final PixelType type;

  final bool isReady = true;

  final bool isDynamic;

  final int width;

  final int height;

  Uint16ListTextureSource.R5G6B5(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGB,
        type = PixelType.unsignedShort_5_6_5;

  Uint16ListTextureSource.R4G4B4A4(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedShort_4_4_4_4;

  Uint16ListTextureSource.R5G5B5A1(this.width, this.height, this.data,
      {this.isDynamic: false})
      : format = PixelFormat.RGBA,
        type = PixelType.unsignedShort_5_5_5_1;

  Uint16List getData() => data;
}
