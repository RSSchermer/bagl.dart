import 'package:test/test.dart';

/// Returns a matcher which matches [Iterable]s of numbers that have the same
/// length and for which the pairwise difference between elements is smaller
/// than [delta].
orderedCloseTo(List<num> values, num delta) {
  return pairwiseCompare(
      values, (a, b) => (a - b).abs() < delta, 'Pair-wise difference < $delta');
}
