part of web_gl;

class Blend {
  final sourceColorFactor;

  final sourceAlphaFactor;

  final destColorFactor;

  final destAlphaFactor;

  final colorFunction;

  final alphaFunction;

  const Blend(
      {this.sourceColorFactor: BlendFactor.one,
      this.sourceAlphaFactor: BlendFactor.one,
      this.destColorFactor: BlendFactor.one,
      this.destAlphaFactor: BlendFactor.one,
      this.colorFunction: BlendFunction.addition,
      this.alphaFunction: BlendFunction.addition});
}

/// Enumerates the possible blending factors that can be applied
enum BlendFactor {
  zero,
  one,
  sourceColor,
  oneMinusSourceColor,
  destinationColor,
  oneMinusDestinationColor,
  sourceAlpha,
  oneMinusSourceAlpha,
  destinationAlpha,
  oneMinusDestinationAlpha
}

enum BlendFunction { addition, subtraction, reverseSubtraction }
