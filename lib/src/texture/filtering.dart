part of texture;

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
