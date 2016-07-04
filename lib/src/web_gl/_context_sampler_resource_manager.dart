part of web_gl;

class _ContextSamplerResourceManager {
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  Set<Sampler> _provisionedSamplers = new Set();

  Map<Sampler, WebGL.Texture> _samplerTOs = new Map();

  _ContextSamplerResourceManager(RenderingContext context)
      : context = context,
        _context = context._context;

  void provision(Sampler sampler) {
    if (!_provisionedSamplers.contains(sampler)) {
      final textureObject = _context.createTexture();
      _samplerTOs[sampler] = textureObject;

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

      _provisionedSamplers.add(sampler);
    } else if (sampler.texture.isReady && sampler.texture.isDynamic) {
      if (sampler is Sampler2D) {
        _updateTexture2DData(sampler);
      }
    }
  }

  bool deprovision(Sampler sampler) {
    if (_provisionedSamplers.contains(sampler)) {
      _context.deleteTexture(_samplerTOs[sampler]);
      _provisionedSamplers.remove(sampler);
      _samplerTOs.remove(sampler);

      if (sampler == context._boundSampler2D) {
        context._bindSampler2D(null);
      }

      return true;
    } else {
      return false;
    }
  }

  WebGL.Texture getTO(Sampler sampler) => _samplerTOs[sampler];

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
