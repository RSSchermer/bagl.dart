part of bagl.texture;

/// Enumerates the methods available to a [Sampler] for texture coordinate
/// wrapping.
///
/// Texture coordinate wrapping concerns texture coordinate values outside of
/// the range `[0.0, 1.0]`. The extremes of this range correspond to the edges
/// of the texture. A texture coordinate value outside of this range therefore
/// has to be mapped to a coordinate value on this range.
///
/// Three wrapping methods are available:
///
/// - [repeat]: the integer part of the coordinate value is ignored. For
///   example, `3.15` maps to `0.15`.
/// - [mirroredRepeat]: similar to [repeat], however, if the integer part is
///   odd, then the decimal part is subtracted from `1`. For example, `2.15`
///   maps to `0.15` and `3.15` maps to `0.85`.
/// - [clampToEdge]: if the coordinate value is smaller than `0.0`, then `0.0`
///   is used as the coordinate value. If the coordinate value is greater than
///   `1.0`, then `1.0` is used as the coordinate value. For example, `-3.15`
///   maps to `0.0` and `2.85` maps to `1.0`.
enum Wrapping { repeat, mirroredRepeat, clampToEdge }
