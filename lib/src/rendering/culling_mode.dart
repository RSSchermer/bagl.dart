part of rendering;

/// Enumerates the possible face-culling modes available.
///
/// A triangle is considered to have 2 sides or 'faces': a front-face and a
/// back-face. Which face is considered to be the front-face and which face is
/// considered to be the back-face, is determined by the [WindingOrder].
///
/// Triangles may be discarded based on their facing in a process known as
/// face-culling. A triangle is considered front-facing if it is oriented such
/// that the front-face is facing the 'camera'. A triangle is considered
/// back-facing if it is oriented such that the back-face is facing the camera.
/// There are 3 possible culling modes:
///
/// - [frontFaces]: front-facing triangles will be culled.
/// - [backFaces]: back-facing triangles will be culled.
/// - [frontAndBackFaces]: all triangles will be culled, regardless of their
///   facing.
///
/// Face culling is an optimization typically used when rendering closed
/// surfaces. It allows the back-end to discard triangles that would not have
/// been visible anyway, before the expensive rasterization and fragment shader
/// operations are performed. Consider a cube: it is made up of 12 triangles.
/// We orient all 12 triangles such that the front-face is facing outwards.
/// Note that by the definition of a closed surfaces, the back-faces of these
/// triangles will never be visible, unless the camera is placed inside the
/// cube. This means that all back-facing triangles can be safely culled to
/// improve rendering performance without altering the result.
enum CullingMode { frontFaces, backFaces, frontAndBackFaces }
