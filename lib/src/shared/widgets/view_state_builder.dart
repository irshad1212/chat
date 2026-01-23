import 'package:chat/utils/helpers/loader_state.dart';
import 'package:flutter/material.dart';
import 'package:remote_client/remote_client.dart';

class ViewStateBuilder<T> extends StatelessWidget {
  const ViewStateBuilder({
    super.key,
    required this.loaderState,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    this.onInitial,
  });

  final LoaderState<T> loaderState;

  final Widget onLoading;

  final Widget Function(T data) onSuccess;

  final Widget? onInitial;

  final Widget Function(Failure failure) onError;

  @override
  Widget build(BuildContext context) {
    switch (loaderState) {
      case Initial():
        return onInitial ?? const SizedBox.shrink();
      case Loading():
        return onLoading;
      case Success(data: final data):
        return onSuccess(data as T);
      case LoadError(failure: final failure):
        return onError(failure);
      default:
        return onLoading;
    }
  }
}
