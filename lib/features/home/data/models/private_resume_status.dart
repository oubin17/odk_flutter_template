// enum PrivateResumeStatus {
//   inTouch,
//   noIntention,
//   intention,
//   notAttendInterview,
//   failedButIntention,
//   interviewPass,
// }

// Map<PrivateResumeStatus, String> privateResumeOriginStatus = {
//   PrivateResumeStatus.inTouch: 'IN_TOUCH',
//   PrivateResumeStatus.noIntention: 'NO_INTENTION',
//   PrivateResumeStatus.intention: 'INTENTION',
//   PrivateResumeStatus.notAttendInterview: 'NOT_ATTEND_INTERVIEW',
//   PrivateResumeStatus.failedButIntention: 'FAILED_BUT_INTENTION',
//   PrivateResumeStatus.interviewPass: 'INTERVIEW_PASS',
// };

class PrivateResumeStatus {
  static Map<String, String> privateResumeStatusMap = {
    'IN_TOUCH': '待联系',
    'NO_INTENTION': '无意向',
    'INTENTION': '有意向',
    'NOT_ATTEND_INTERVIEW': '未面试',
    'FAILED_BUT_INTENTION': '失败但有意向',
    'INTERVIEW_PASS': '面试通过',
  };
}

// extension PrivateResumeStatusExtension on PrivateResumeStatus {
//   // 1. 获取数字 (枚举 -> 数字)
//   int get value => index;

//   // 2. 根据数字获取枚举 (数字 -> 枚举)
//   static PrivateResumeStatus? fromValue(String? value) {
//     // 安全检查：防止数组越界
//     if (value == null) {
//       return null;
//     }
//     String? originValue = privateResumeStatusMap[value] ?? value;
//     if (originValue == null) {
//       return null;
//     }
//     // 转换为枚举值

//   }
// }
