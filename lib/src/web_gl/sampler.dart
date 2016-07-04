part of web_gl;

/// Translates texture coordinates into texture values.
///
/// A [Sampler] attempts to obtain texture values by mapping texture coordinates
/// onto texels (texture pixels). However, a set of texture coordinates rarely
/// corresponds to exactly 1 texel unambiguously. Instead there are often
/// several candidate texels. The [Sampler] then performs texture filtering in
/// order to obtain the most appropriate texture value.
///
/// When sampling a texture value for a fragment, two distinct cases are
/// distinguished. A fragment may be larger than the candidate texels. In this
/// case the [Sampler] will use the filtering method specified by
/// [minificationFilter]. See [MinificationFilter] for details on the methods
/// available for minification filtering. A fragment may also be smaller than
/// the candidate texels. In this case the [Sampler] will use the filtering
/// method specified by [magnificationFilter]. See [MagnificationFilter] for
/// details on the methods available for magnification filtering.
abstract class Sampler {
  /// The [Texture] sampled by this [Sampler].
  Texture get texture;

  /// The filtering method used when sampling for a fragment whose area is
  /// larger than a texel.
  ///
  /// See [MinificationFilter] for details on the methods available.
  MinificationFilter get minificationFilter;

  /// The filtering method used when sampling for a fragment whose area is
  /// smaller than a texel.
  ///
  /// See [MagnificationFilter] for details on the methods available.
  MagnificationFilter get magnificationFilter;

  /// The wrapping method used when the `s` texture coordinate falls outside the
  /// range `[0.0, 1.0]`.
  ///
  /// See [Wrapping] for details on the methods available.
  Wrapping get wrapS;

  /// The wrapping method used when the `t` texture coordinate falls outside the
  /// range `[0.0, 1.0]`.
  ///
  /// See [Wrapping] for details on the methods available.
  Wrapping get wrapT;
}

/// A [Sampler] for a [Texture2D].
class Sampler2D implements Sampler {
  final Texture2D texture;

  final MinificationFilter minificationFilter;

  final MagnificationFilter magnificationFilter;

  final Wrapping wrapS;

  final Wrapping wrapT;

  /// Returns a new [Sampler2D] for the [texture].
  ///
  /// The following optional parameters may be specified:
  ///
  /// - [minificationFilter]: the filtering method used when sampling for a
  ///   fragment whose area is larger than a texel. See [MinificationFilter] for
  ///   details on the methods available.
  /// - [magnificationFilter]: the filtering method used when sampling for a
  ///   fragment whose area is smaller than a texel. See [MagnificationFilter]
  ///   for details on the methods available.
  /// - [wrapS]: the wrapping method used when the `s` texture coordinate falls
  ///   outside the range `[0.0, 1.0]`. See [Wrapping] for details on the
  ///   methods available.
  /// - [wrapT]: the wrapping method used when the `t` texture coordinate falls
  ///   outside the range `[0.0, 1.0]`. See [Wrapping] for details on the
  ///   methods available.
  Sampler2D(this.texture,
      {this.minificationFilter: MinificationFilter.nearestMipmapLinear,
      this.magnificationFilter: MagnificationFilter.linear,
      this.wrapS: Wrapping.repeat,
      this.wrapT: Wrapping.repeat});
}

/// Enumerates the methods available to a [Sampler] for magnification filtering.
///
/// Minification filtering is used when a sampling a texture value for a
/// fragment that is smaller than the candidate texels. For following filtering
/// methods are available:
///
/// - [nearest]: the sampled value is chosen to be the value of the texel whose
///   coordinates are closest to the sampling coordinates.
/// - [linear]: the sampled value is calculated by linearly interpolating
///   between the 4 texels that are closest to the sampling coordinates.
enum MagnificationFilter { nearest, linear }

/// Enumerates the methods available to a [Sampler] for minification filtering.
///
/// Minification filtering is used when a sampling a texture value for a
/// fragment that is larger than the candidate texels. Six filtering methods are
/// available. Two of these methods do not involve mipmapping:
///
/// - [nearest]: the sampled value is chosen to be the value of the texel whose
///   coordinates are closest to the sampling coordinates.
/// - [linear]: the sampled value is calculated by linearly interpolating
///   between the 4 texels that are closest to the sampling coordinates.
///
/// The four other filtering methods involve mipmapping. When a fragment is
/// larger than the candidate texels, the fragment surface might span multiple
/// texels. The most appropriate sample value might then be obtained by
/// interpolating between these texels. However, doing this for each sampling
/// operation can be very expensive.
///
/// This is instead solved by using a mipmap, which produces similar results
/// with much better performance. A mipmap is a pre-calculated sequence of
/// images, starting with the original image. Each subsequent image is half the
/// width and half the height of the previous image. The sequence ends when
/// the width or height reaches 1. Each image in the mipmap sequence is
/// identified by a mipmap level: the base images has a mipmap level of 0,
/// the subsequent image has a mipmap level of 1, etc. For example, a mipmap
/// of a base images of size 256 by 256 has 9 mipmap levels: 256x256, 128x128,
/// 64x64, 32x32, 16x16, 8x8, 4x4, 2x2, 1x1.
///
/// The following four mipmap filtering methods are available:
///
/// - [nearestMipmapNearest]: first selects the mipmap level for which the texel
///   size is closest to the fragment size. The sampled value is then chosen to
///   be the value of the texel whose coordinates are closest to the sampling
///   coordinates.
/// - [nearestMipmapLinear]: first selects the mipmap level for which the texel
///   size is closest to the fragment size. The sampled value is then calculated
///   by linearly interpolating between the 4 texels that are closest to the
///   sampling coordinates.
/// - [linearMipmapNearest]: first selects both the nearest mipmap level for
///   which the texel size is smaller than the fragment, as well as the nearest
///   mipmap level for which the texel size is larger than the fragment. Then
///   samples a value from both mipmap levels by choosing the texel whose
///   coordinates are closest to the sampling coordinates. The final sample
///   value is then calculated by linearly interpolating between these two
///   values.
/// - [linearMipmapLinear]: first selects both the nearest mipmap level for
///   which the texel size is smaller than the fragment, as well as the nearest
///   mipmap level for which the texel size is larger than the fragment. Then
///   samples a value from both mipmap levels by linearly interpolating between
///   the 4 texels that are closest to the sampling coordinates. The final
///   sample value is then calculated by linearly interpolating between these
///   two values.
///
/// The rendering backend may only support mipmaps for textures for which the
/// width and height are both powers of 2 and may fail with a non-power-of-two
/// texture.
enum MinificationFilter {
  nearest,
  linear,
  nearestMipmapNearest,
  nearestMipmapLinear,
  linearMipmapLinear,
  linearMipMapNearest
}

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
