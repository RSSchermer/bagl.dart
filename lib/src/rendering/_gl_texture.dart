part of rendering;

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
