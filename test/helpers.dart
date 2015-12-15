import 'package:test/test.dart';

pairWiseDifferenceLessThan(List<num> values, num delta) {
  return pairwiseCompare(values, (a, b) => (a - b).abs() < delta, 'Pair-wise difference < $delta');
}
