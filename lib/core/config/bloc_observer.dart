import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  // 🟩 يُستدعى عند إنشاء أي Bloc أو Cubit جديد
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print(' onCreate --> ${bloc.runtimeType}');
  }

  // 🟦 يُستدعى عند كل تغيّر في الـ state داخل Bloc أو Cubit (بدون Events)
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print(
      ' onChange --> ${bloc.runtimeType} : ${change.currentState} → ${change.nextState}',
    );
  }

  // 🟠 يُستدعى فقط في Blocs (مش Cubits) عند إضافة Event جديد
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(' onEvent --> ${bloc.runtimeType} : $event');
  }

  // 🟣 يُستدعى لما يصير Transition داخل Bloc (من State إلى State عبر Event)
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('🟣 onTransition --> ${bloc.runtimeType} : $transition');
  }

  // 🔴 يُستدعى عند حدوث أي خطأ داخل Bloc أو Cubit
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(' onError --> ${bloc.runtimeType} : $error');
    super.onError(bloc, error, stackTrace);
  }

  // ⚫ يُستدعى عند إغلاق Bloc أو Cubit (dispose)
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print(' onClose --> ${bloc.runtimeType}');
  }
}
