import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// context.go('/detail/123?name=1234');
class TodoDetail extends StatelessWidget {
  final String id;
  const TodoDetail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 接收参数 '//detail/:id?name=张三&age=20'
    final params = GoRouterState.of(context).uri.queryParameters;
    final name = params['name'];
    return Center(
      child: Column(
        children: [Text('URL路径参数 $id'), Text('查询参数 $name'), Text('查询参数 $name')],
      ),
    );
  }
}
