import 'package:flutter/material.dart';
import 'package:odk_flutter_template/providers/count_model/data/model/counter_model.dart';
import 'package:odk_flutter_template/providers/count_model/presentation/provider_test2.dart';
import 'package:provider/provider.dart';

class ProviderTest extends StatefulWidget {
  ProviderTest({super.key});

  @override
  _ProviderTestState createState() => _ProviderTestState();
}

class _ProviderTestState extends State<ProviderTest> {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Center(child: Text('Provider Test')),
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          context.read<CounterModel>().increment();
        },
      ),
      ProviderTest2(),
    ],
  );
}
