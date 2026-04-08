import 'package:flutter/material.dart';
import 'package:odk_flutter_template/providers/count_model/data/model/counter_model.dart';
import 'package:provider/provider.dart';

class ProviderTest2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        return Text(counter.count.toString());
      },
    );
  }
}
