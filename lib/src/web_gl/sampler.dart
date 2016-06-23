part of web_gl;

abstract class Sampler {
  Texture get texture;

  MinificationFilter get minificationFilter;

  MagnificationFilter get magnificationFilter;

  Wrapping get wrapS;

  Wrapping get wrapT;
}

class Sampler2D implements Sampler {
  final Texture2D texture;

  final MinificationFilter minificationFilter;

  final MagnificationFilter magnificationFilter;

  final Wrapping wrapS;

  final Wrapping wrapT;

  Sampler2D(this.texture,
      {this.minificationFilter: MinificationFilter.nearestMipmapLinear,
      this.magnificationFilter: MagnificationFilter.linear,
      this.wrapS: Wrapping.repeat,
      this.wrapT: Wrapping.repeat});
}

enum MagnificationFilter { nearest, linear }

enum MinificationFilter {
  nearest,
  linear,
  nearestMipmapNearest,
  nearestMipmapLinear,
  linearMipmapLinear,
  linearMipMapNearest
}

enum Wrapping { repeat, mirroredRepeat, clampToEdge }
