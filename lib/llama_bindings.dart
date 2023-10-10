// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int llamamaid_start(
    ffi.Pointer<ffi.Char> model_path,
    ffi.Pointer<ffi.Char> _prompt,
    ffi.Pointer<ffi.Char> _antiprompt,
    ffi.Pointer<show_output_cb> show_output,
  ) {
    return _llamamaid_start(
      model_path,
      _prompt,
      _antiprompt,
      show_output,
    );
  }

  late final _llamamaid_startPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<ffi.Char>,
              ffi.Pointer<show_output_cb>)>>('llamamaid_start');
  late final _llamamaid_start = _llamamaid_startPtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>,
          ffi.Pointer<ffi.Char>, ffi.Pointer<show_output_cb>)>();

  int llamamaid_continue(
    ffi.Pointer<ffi.Char> input,
    ffi.Pointer<show_output_cb> show_output,
  ) {
    return _llamamaid_continue(
      input,
      show_output,
    );
  }

  late final _llamamaid_continuePtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<ffi.Char>,
              ffi.Pointer<show_output_cb>)>>('llamamaid_continue');
  late final _llamamaid_continue = _llamamaid_continuePtr.asFunction<
      int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<show_output_cb>)>();

  void llamamaid_stop() {
    return _llamamaid_stop();
  }

  late final _llamamaid_stopPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('llamamaid_stop');
  late final _llamamaid_stop = _llamamaid_stopPtr.asFunction<void Function()>();

  void llamamaid_exit() {
    return _llamamaid_exit();
  }

  late final _llamamaid_exitPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>('llamamaid_exit');
  late final _llamamaid_exit = _llamamaid_exitPtr.asFunction<void Function()>();
}

typedef show_output_cb
    = ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Char>)>;