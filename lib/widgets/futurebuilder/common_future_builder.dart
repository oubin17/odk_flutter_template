import 'package:flutter/material.dart';

class CommonFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) onSuccess;

  const CommonFutureBuilder({
    super.key,
    required this.future,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        // 1. 加载中
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. 加载失败 / 无数据
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              "未获取到用户信息",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        // 3. 数据成功返回
        return onSuccess(snapshot.data as T);
      },
    );
  }
}
