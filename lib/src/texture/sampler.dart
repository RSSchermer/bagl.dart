part of bagl.texture;

/// Obtains texture values for texture coordinates.
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
