class Setting {
  final String code;
  final String desc;
  final String value;
  final String createDate;

  const Setting({
    required this.code,
    required this.desc,
    required this.value,
    required this.createDate,
  });
  String getCode() {
    return code;
  }

  Map<String, Object?> toMap() {
    return {
      'code': code,
      'desc': desc,
      'value': value,
      'createDate': createDate,
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) => Setting(
    code: map['code'],
    desc: map['desc'],
    value: map['value'],
    createDate: map['createDate'],
  );

  @override
  String toString() {
    return 'Setting{code: $code, desc: $desc, value: $value, createDate:$createDate}';
  }
}