import 'package:flutter_bloc/flutter_bloc.dart';


class SimpleCubit<T> extends Cubit<T?> {
  SimpleCubit(super.initialState, {Future<T?>? getter}) {
    if (getter != null) {
      init(getter);
    }
  }

  Future<void> init(Future<T?> getter) async {
    emit(await getter);
  }

  void set(T? value){
    emit(value);
  }
}
