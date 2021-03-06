part of bagl.rendering;

/// Manages the provisioning and deprovisioning of texture related GPU resources
/// for a [RendingContext].
class ContextTextureResources {
  /// The [RenderingContext] with which these [ContextTextureResources] are
  /// associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  /// Expands [Texture2D]s with their associated texture objects for all
  /// currently provisioned textures.
  Expando<_GLTexture2D> _texture2DGLTexture2D = new Expando();

  ContextTextureResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [texture].
  bool areProvisionedFor(Texture texture) =>
      _texture2DGLTexture2D[texture] != null;

  /// Provisions GPU resources for the [texture].
  ///
  /// Sets up a texture object for the [texture]. If resources had been
  /// provisioned previously for the [texture] then these resources will be
  /// reused. For dynamic textures this method will update the texture image
  /// data.
  void provisionFor(Texture texture) {
    if (!areProvisionedFor(texture)) {
      final textureObject = _context.createTexture();

      _texture2DGLTexture2D[texture] =
          new _GLTexture2D(context, texture, textureObject);

      if (texture is Texture2D) {
        _updateTexture2DData(texture);

        if (!texture.isReady) {
          texture.asFuture().then((_) {
            _updateTexture2DData(texture);
          });
        }
      } else {
        throw new ArgumentError('Tried to provision resources for a texture of '
            'type "${texture.runtimeType}", but this texture type is not '
            'supported in the current context. Supported texture types are: '
            'Texture2D.');
      }
    } else if (texture.isReady && texture.isDynamic) {
      if (texture is Texture2D) {
        _updateTexture2DData(texture);
      }
    }
  }

  /// Deprovisions the GPU resources associated with the [texture].
  ///
  /// Returns `true` if resources were provisioned for the [texture], `false`
  /// otherwise.
  bool deprovisionFor(Texture texture) {
    if (areProvisionedFor(texture)) {
      _context.deleteTexture(_texture2DGLTexture2D[texture].glTextureObject);
      _texture2DGLTexture2D[texture] = null;

      final unit = context._textureUnitsTextures.inverse[texture];

      if (unit != null) {
        context._updateActiveTextureUnit(unit);

        _context.bindTexture(WebGL.TEXTURE_2D, null);

        context._textureUnitsTextures.remove(unit);
      }

      if (context._boundTexture2D == texture) {
        context._boundTexture2D = null;
      }

      return true;
    } else {
      return false;
    }
  }

  _GLTexture2D _getGLTexture2D(Texture2D texture) =>
      _texture2DGLTexture2D[texture];

  void _updateTexture2DData(Texture2D texture) {
    final image = texture.image;
    final internalFormat = _pixelFormatMap[texture.internalFormat];
    final format = _pixelFormatMap[image.format];
    final type = _pixelTypeMap[image.type];

    context._bindTexture2D(texture);

    if (texture.isReady) {
      if (image is ImageDataImage) {
        _context.texImage2D(
            WebGL.TEXTURE_2D, 0, internalFormat, format, type, image.imageData);
      } else if (image is ImageElementImage) {
        _context.texImage2D(WebGL.TEXTURE_2D, 0, internalFormat, format, type,
            image.imageElement);
      } else if (image is CanvasElementImage) {
        _context.texImage2D(WebGL.TEXTURE_2D, 0, internalFormat, format, type,
            image.canvasElement);
      } else if (image is VideoElementImage) {
        _context.texImage2D(WebGL.TEXTURE_2D, 0, internalFormat, format, type,
            image.videoElement);
      } else {
        _context.texImage2D(WebGL.TEXTURE_2D, 0, internalFormat, image.width,
            image.height, 0, format, type, image.data);
      }
    } else {
      _context.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGB, 1, 1, 0, WebGL.RGB,
          WebGL.UNSIGNED_BYTE, new Uint8List(3));
    }
  }
}

class _GLTexture2D {
  /// The [RenderingContext] with which this [_GLTexture] is associated.
  final RenderingContext context;

  /// The [Texture] definition from which this [_GLTexture] was created.
  final Texture2D texture;

  /// The GL object for this [_GLProgram].
  final WebGL.Texture glTextureObject;

  final WebGL.RenderingContext _context;

  Sampler2D _appliedSampler;

  bool _hasMipMap = false;

  _GLTexture2D(this.context, this.texture, this.glTextureObject)
      : _context = context._context;

  void applySampler(Sampler2D sampler) {
    if (sampler != _appliedSampler) {
      context._bindTexture2D(texture);

      if (_appliedSampler == null) {
        if (sampler.minificationFilter !=
            MinificationFilter.nearestMipmapLinear) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER,
              _minificationFilterMap[sampler.minificationFilter]);
        }

        if (sampler.magnificationFilter != MagnificationFilter.linear) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER,
              _magnificationFilterMap[sampler.magnificationFilter]);
        }

        if (sampler.wrapS != Wrapping.repeat) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S,
              _wrappingMap[sampler.wrapS]);
        }

        if (sampler.wrapT != Wrapping.repeat) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T,
              _wrappingMap[sampler.wrapT]);
        }
      } else {
        if (sampler.minificationFilter != _appliedSampler.minificationFilter) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER,
              _minificationFilterMap[sampler.minificationFilter]);
        }

        if (sampler.magnificationFilter !=
            _appliedSampler.magnificationFilter) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER,
              _magnificationFilterMap[sampler.magnificationFilter]);
        }

        if (sampler.wrapS != _appliedSampler.wrapS) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S,
              _wrappingMap[sampler.wrapS]);
        }

        if (sampler.wrapT != _appliedSampler.wrapT) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T,
              _wrappingMap[sampler.wrapT]);
        }
      }

      final minFilter = sampler.minificationFilter;

      if (!_hasMipMap &&
          (minFilter == MinificationFilter.linearMipmapLinear ||
              minFilter == MinificationFilter.linearMipMapNearest ||
              minFilter == MinificationFilter.nearestMipmapLinear ||
              minFilter == MinificationFilter.nearestMipmapNearest)) {
        _context.generateMipmap(WebGL.TEXTURE_2D);
        _hasMipMap = true;
      }

      _appliedSampler = sampler;
    }
  }
}
