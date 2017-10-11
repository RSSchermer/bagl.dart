part of bagl.rendering;

abstract class Uniforms {
  const factory Uniforms(Map<String, dynamic> map) = _MapUniforms;

  const factory Uniforms.empty() = _EmptyUniforms;

  Object operator [](String uniformName);
}

class _EmptyUniforms implements Uniforms {
  const _EmptyUniforms();

  Object operator [](String uniformName) => null;
}

class _MapUniforms implements Uniforms {
  final Map<String, dynamic> _map;

  const _MapUniforms(this._map);

  Object operator [](String uniformName) => _map[uniformName];
}
