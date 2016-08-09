/// Struct uniform type.
library struct;

/// Defines a value that can be used as structural uniform variable.
class Struct {
  final Map<String, dynamic> _memberValues;

  /// Instantiates a new [Struct] from the [memberValues].
  ///
  /// For each `(key, value)` pair in the [memberValues] map the struct will
  /// define a member named `key` set to `value`.
  Struct(Map<String, dynamic> memberValues)
      : _memberValues = new Map.from(memberValues);

  /// Returns the names of the this [Struct]'s members.
  Iterable<String> get members => _memberValues.keys;

  /// Whether or not this [Struct] defines a member named [name].
  bool hasMember(String name) => _memberValues.containsKey(name);

  /// For each member defined for this struct, [f] will be called with the
  /// member's name and the member's value.
  void forEach(void f(String name, dynamic value)) => _memberValues.forEach(f);

  /// Returns the value associated with the [member], or `null` if no such
  /// member is defined by this [Struct].
  dynamic operator [](String member) => _memberValues[member];
}
