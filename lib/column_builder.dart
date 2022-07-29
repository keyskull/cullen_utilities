import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ColumnBuilder extends StatelessWidget {
  const ColumnBuilder(
      {Key? key, required this.itemBuilder, required this.itemCount})
      : super(key: key);

  final Widget Function(BuildContext, int) itemBuilder;

  final int itemCount;

  @override
  Widget build(BuildContext context) => Column(
        children:
            List.generate(itemCount, (index) => itemBuilder(context, index))
                .toList(),
      );
}
