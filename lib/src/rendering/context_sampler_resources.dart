part of rendering;

/// Manages the provisioning and deprovisioning of sampler related GPU resources
/// for a [RendingContext].
class ContextSamplerResources {
  /// The [RenderingContext] with which these [ContextSamplerResources] are
  /// associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  /// Expands [Sampler]s with their associated texture objects for all currently
  /// provisioned samplers.
  Expando<WebGL.Texture> _samplerTO = new Expando();

  ContextSamplerResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [sampler].
  bool areProvisionedFor(Sampler sampler) => _samplerTO[sampler] != null;

  /// Provisions GPU resources for the [sampler].
  ///
  /// Sets up a texture object for the [sampler]. If resources had been
  /// provisioned previously for the [sampler] then these resources will be
  /// reused. For samplers with dynamic textures this method will update the
  /// texture data.
  void provisionFor(Sampler sampler) {
    if (!areProvisionedFor(sampler)) {
      final textureObject = _context.createTexture();
      _samplerTO[sampler] = textureObject;

      context._bindSampler2D(sampler);

      if (sampler is Sampler2D) {
        if (sampler.magnificationFilter != MagnificationFilter.linear) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER,
              _magnificationFilterMap[sampler.magnificationFilter]);
        }

        if (sampler.minificationFilter !=
            MinificationFilter.nearestMipmapLinear) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER,
              _minificationFilterMap[sampler.minificationFilter]);
        }

        if (sampler.wrapS != Wrapping.repeat) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S,
              _wrappingMap[sampler.wrapS]);
        }

        if (sampler.wrapT != Wrapping.repeat) {
          _context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T,
              _wrappingMap[sampler.wrapT]);
        }

        if (sampler.texture.isReady) {
          _updateTexture2DData(sampler);
        } else {
          sampler.texture.asFuture().then((_) {
            _updateTexture2DData(sampler);
          });
        }
      } else {
        throw new ArgumentError('Tried to provision resources for a sampler of '
            'type "${sampler.runtimeType}", but this sampler type is not '
            'supported in the current context. Supported sampler types are: '
            'Sampler2D.');
      }
    } else if (sampler.texture.isReady && sampler.texture.isDynamic) {
      if (sampler is Sampler2D) {
        _updateTexture2DData(sampler);
      }
    }
  }

  /// Deprovisions the GPU resources associated with the [sampler].
  ///
  /// Returns `true` if resources were provisioned for the [sampler], `false`
  /// otherwise.
  bool deprovisionFor(Sampler sampler) {
    if (areProvisionedFor(sampler)) {
      _context.deleteTexture(_samplerTO[sampler]);
      _samplerTO[sampler] = null;

      if (sampler == context._boundSampler2D) {
        context._bindSampler2D(null);
      }

      return true;
    } else {
      return false;
    }
  }

  WebGL.Texture _getTO(Sampler sampler) => _samplerTO[sampler];

  void _updateTexture2DData(Sampler2D sampler) {
    final texture = sampler.texture;

    if (texture.isReady) {
      context._bindSampler2D(sampler);

      final image = texture.image;
      final internalFormat = _pixelFormatMap[texture.internalFormat];
      final format = _pixelFormatMap[image.format];
      final type = _pixelTypeMap[image.type];

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

      final minFilter = sampler.minificationFilter;

      if (minFilter == MinificationFilter.linearMipmapLinear ||
          minFilter == MinificationFilter.linearMipMapNearest ||
          minFilter == MinificationFilter.nearestMipmapLinear ||
          minFilter == MinificationFilter.nearestMipmapNearest) {
        _context.generateMipmap(WebGL.TEXTURE_2D);
      }
    }
  }
}
