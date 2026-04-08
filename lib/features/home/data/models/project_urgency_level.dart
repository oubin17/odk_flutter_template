enum ProjectUrgencyLevel {
  level_0,
  level_1,
  level_2,
  level_3,
  level_4,
  level_5,
}

extension ProjectUrgencyLevelExtension on ProjectUrgencyLevel {
  // 1. 获取数字 (枚举 -> 数字)
  int get value => index;

  // 2. 根据数字获取枚举 (数字 -> 枚举)
  static ProjectUrgencyLevel? fromValue(int? value) {
    // 安全检查：防止数组越界
    if (value == null ||
        value < 0 ||
        value >= ProjectUrgencyLevel.values.length) {
      return null;
    }
    return ProjectUrgencyLevel.values[value];
  }
}
