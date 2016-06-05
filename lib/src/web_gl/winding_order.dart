part of web_gl;

/// Enumerates the possible winding orders for triangles.
///
/// A triangle is considered to have 2 sides or 'faces': a front-face and a
/// back-face. The winding order determines which face is considered the
/// front-face, and thus by extension which face is considered the back-face.
///
/// Each triangle is defined by 3 points: a first point (point `a`), a second
/// point (point `b`), and a third point (point `c`):
///
///     //
///     //        a
///     //       /\
///     //      /  \
///     //     /    \
///     //    /      \
///     //   /________\
///     //  c          b
///     //
///
/// In the above example we are looking at just one face of a triangle: the face
/// that is facing toward us. If we trace the outline of this triangle from
/// `a -> b -> c -> a`, we'll notice that we've following a clockwise path.
/// If the winding order is defined to be [clockwise], then we are looking at
/// the front-face of this triangle. If the winding order is defined to be
/// [counterClockwise], then we are looking at the back-face of this triangle.
enum WindingOrder { clockwise, counterClockwise }
