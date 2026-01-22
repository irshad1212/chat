import 'dart:async';

import 'package:chat/generated/assets.dart';
import 'package:chat/src/shared/widgets/smooth_container.dart';
import 'package:chat/utils/helpers/extensions.dart';
import 'package:chat/utils/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

ToastNavigatorObserver toastNavigatorObserver = ToastNavigatorObserver();

class ToastNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _dismissActiveToast();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _dismissActiveToast();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _dismissActiveToast();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _dismissActiveToast();
  }

  void _dismissActiveToast() {
    FToast().removeCustomToast();
  }
}

enum ToastGravity { snackbar }

typedef PositionedToastBuilder = Widget Function(BuildContext context, Widget child);

class FToast {
  BuildContext? context;

  static final FToast _instance = FToast._internal();

  factory FToast() {
    return _instance;
  }

  FToast init(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  FToast._internal();

  OverlayEntry? _entry;
  final List<_ToastEntry> _overlayQueue = [];
  Timer? _timer;
  Timer? _fadeTimer;

  void _showOverlay() {
    if (_overlayQueue.isEmpty) {
      _entry = null;
      return;
    }
    if (context == null) {
      removeQueuedCustomToasts();
      throw "Error: Context is null, Please call init(context) before showing toast.";
    }

    OverlayState? overlay;
    try {
      overlay = Overlay.of(context!);
    } catch (err) {
      removeQueuedCustomToasts();
      throw """Error: Overlay is null. 
      Please don't use top of the widget tree context (such as Navigator or MaterialApp) or 
      create overlay manually in MaterialApp builder.
      """;
    }

    /// Create entry only after all checks
    _ToastEntry toastEntry = _overlayQueue.removeAt(0);
    _entry = toastEntry.entry;
    overlay.insert(_entry!);

    _timer = Timer(toastEntry.duration, () {
      _fadeTimer = Timer(toastEntry.fadeDuration, () {
        removeCustomToast();
      });
    });
  }

  void removeCustomToast() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _entry?.remove();
    _entry = null;
    _showOverlay();
  }

  void removeQueuedCustomToasts() {
    _timer?.cancel();
    _fadeTimer?.cancel();
    _timer = null;
    _fadeTimer = null;
    _overlayQueue.clear();
    _entry?.remove();
    _entry = null;
  }

  double _bottom = 0.h;
  void showToast({
    required Widget child,
    PositionedToastBuilder? positionedToastBuilder,
    Duration toastDuration = const Duration(seconds: 2),
    ToastGravity? gravity,
    Duration fadeDuration = const Duration(milliseconds: 350),
    bool ignorePointer = false,
    bool isDismissable = false,
    double? bottom,
  }) {
    if (context == null) {
      throw "Error: Context is null, Please call init(context) before showing toast.";
    }

    // If there's already a toast showing or queued, don't show another one
    if (_entry != null || _overlayQueue.isNotEmpty) {
      return;
    }

    if (bottom != null) {
      _bottom = bottom;
    }
    Widget newChild = _ToastStateFul(
      child,
      toastDuration,
      fadeDuration,
      ignorePointer,
      !isDismissable
          ? null
          : () {
              removeCustomToast();
            },
    );

    OverlayEntry newEntry = OverlayEntry(
      builder: (context) {
        if (positionedToastBuilder != null) {
          return positionedToastBuilder(context, newChild);
        }
        return _getPostionWidgetBasedOnGravity(newChild, gravity, _bottom);
      },
    );
    _overlayQueue.add(
      _ToastEntry(entry: newEntry, duration: toastDuration, fadeDuration: fadeDuration),
    );
    if (_timer == null) _showOverlay();
  }

  Positioned _getPostionWidgetBasedOnGravity(Widget child, ToastGravity? gravity, double bottom) {
    switch (gravity) {
      case ToastGravity.snackbar:
        return Positioned(
          bottom: MediaQuery.of(context!).viewInsets.bottom + bottom,
          left: 16.w,
          right: 16.w,
          child: child,
        );
      default:
        return Positioned(
          bottom: MediaQuery.of(context!).viewInsets.bottom + bottom,
          left: 16.w,
          right: 16.w,
          child: child,
        );
    }
  }
}

TransitionBuilder fTostBuilder() {
  return (context, child) {
    return _FToastHolder(child: child!);
  };
}

class _FToastHolder extends StatelessWidget {
  const _FToastHolder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Overlay overlay = Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            return child;
          },
        ),
      ],
    );

    return Directionality(textDirection: TextDirection.ltr, child: overlay);
  }
}

class _ToastEntry {
  final OverlayEntry entry;
  final Duration duration;
  final Duration fadeDuration;

  _ToastEntry({required this.entry, required this.duration, required this.fadeDuration});
}

class _ToastStateFul extends StatefulWidget {
  const _ToastStateFul(
    this.child,
    this.duration,
    this.fadeDuration,
    this.ignorePointer,
    this.onDismiss,
  );

  final Widget child;
  final Duration duration;
  final Duration fadeDuration;
  final bool ignorePointer;
  final VoidCallback? onDismiss;

  @override
  ToastStateFulState createState() => ToastStateFulState();
}

class ToastStateFulState extends State<_ToastStateFul> with SingleTickerProviderStateMixin {
  void showIt() {
    _animationController!.forward();
  }

  void hideIt() {
    _animationController!.reverse();
    _timer?.cancel();
  }

  AnimationController? _animationController;
  late Animation _fadeAnimation;

  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: widget.fadeDuration);
    _fadeAnimation = CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    super.initState();

    showIt();
    _timer = Timer(widget.duration, () {
      hideIt();
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _animationController!.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss == null ? null : () => widget.onDismiss!(),
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: widget.ignorePointer,
        child: FadeTransition(
          opacity: _fadeAnimation as Animation<double>,
          child: Center(
            child: Material(color: Colors.transparent, child: widget.child),
          ),
        ),
      ),
    );
  }
}

class Toast {
  BuildContext? context = navigatorKey.currentContext;
  FToast fToast = FToast();
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final double? bottom;
  final String icon;
  final bool closeButton;
  final int duration;

  Toast._({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    this.bottom,
    this.closeButton = false,
    this.duration = 2,
  });

  static Toast success({
    required String message,
    double? bottom,
    bool closeButton = false,
    int duration = 2,
  }) {
    return Toast._(
      message: message,
      backgroundColor: const Color(0xffD7F4E5),
      textColor: Colors.white,
      bottom: bottom,
      icon: Assets.svgToastSuccess,
      closeButton: closeButton,
      duration: duration,
    );
  }

  static Toast error({
    required String message,
    double? bottom,
    bool closeButton = false,
    int duration = 2,
  }) {
    return Toast._(
      message: message,
      backgroundColor: const Color(0xffFFE5E9),
      textColor: Colors.white,
      bottom: bottom,
      icon: Assets.svgToastError,
      closeButton: closeButton,
      duration: duration,
    );
  }

  void show({bool cancel = false}) {
    if (context == null) return;
    if (!context!.mounted) return;
    if (cancel) {
      fToast.removeCustomToast();
      return;
    }
    fToast.init(context!);
    fToast.showToast(
      gravity: ToastGravity.snackbar,
      bottom: bottom,
      toastDuration: Duration(seconds: duration),
      isDismissable: closeButton,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 40.h),
        child: SmoothContainer(
          width: context!.sw(),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            children: [
              SvgPicture.asset(icon),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Color(0xffF7F7F7), fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (closeButton) ...[
                8.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    fToast.removeCustomToast();
                  },
                  child: Icon(Icons.close, color: const Color(0xffF7F7F7), size: 20.sp),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
