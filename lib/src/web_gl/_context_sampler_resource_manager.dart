part of web_gl;

class _ContextSamplerResourceManager {
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  Set<Sampler> _provisionedSamplers = new Set();

  ListQueue<Sampler> _recentSamplerQueue = new ListQueue();

  Set<int> _emptySamplerUnits;

  Map<Sampler, int> _samplerUnits = new Map();

  Map<Sampler, WebGL.Texture> _samplerTOs = new Map();

  _ContextSamplerResourceManager(RenderingContext context)
      : context = context,
        _context = context._context {
    _emptySamplerUnits =
        new List.generate(context._maxTextureUnits, (i) => i).toSet();
  }

  void provision(Sampler sampler) {
    if (!_provisionedSamplers.contains(sampler)) {
      final glTextureHandle = _context.createTexture();

      _provisionedSamplers.add(sampler);
    }
  }

  bool deprovision(Sampler sampler) {
    if (_provisionedSamplers.contains(sampler)) {
      _provisionedSamplers.remove(sampler);
      _recentSamplerQueue.remove(sampler);

      return true;
    } else {
      return false;
    }
  }
}
