import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import 'ui/views/pages/unknown.dart';

Widget Function(BuildContext, AsyncSnapshot<T>) futureBuilderHandler<T>(
        {required Widget Function(BuildContext, AsyncSnapshot<T>) builder,
        Logger? logger}) =>
    (context, AsyncSnapshot<T> snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const CircularProgressIndicator();
      } else {
        if (snapshot.hasError) {
          logger?.e(snapshot.error.toString());
          return Unknown(errorMSG: snapshot.error.toString());
        } else {
          return builder(context, snapshot);
        }
      }
    };
