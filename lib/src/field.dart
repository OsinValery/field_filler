import 'dart:ui';

class OneField {
  final Color color;
  final bool free;

  OneField(this.color, this.free);
  static OneField empty() => OneField(const Color.fromARGB(0, 0, 0, 0), true);
  static OneField fromMap(Map<String, dynamic> map) {
    return OneField(
        Color.fromARGB(255, map["r"], map["g"], map["b"]), map['free']);
  }

  Map<String, dynamic> toMap() =>
      {"free": free, "r": color.red, "g": color.green, "b": color.blue};
}
