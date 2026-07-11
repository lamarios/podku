import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/utils/states/simple_cubit.dart';

class SimpleCubitView<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T? value) builder;
  final T? initialValue;
  final Future<T?>? getter;

  const SimpleCubitView({super.key, this.getter, this.initialValue, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimpleCubit<T>(initialValue, getter: getter),
      child: BlocBuilder<SimpleCubit<T>, T?>(builder: builder),
    );
  }
}
