class Setting {
  final String code;
  final String desc;
  final String value;

  const Setting({
    required this.code,
    required this.desc,
    required this.value,
  });
  String getCode() {
    return code;
  }

  Map<String, Object?> toMap() {
    return {
      'code': code,
      'desc': desc,
      'value': value,
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) => Setting(
    code: map['code'],
    desc: map['desc'],
    value: map['value'],
  );

  @override
  String toString() {
    return 'Setting{code: $code, desc: $desc, age: $value}';
  }
}