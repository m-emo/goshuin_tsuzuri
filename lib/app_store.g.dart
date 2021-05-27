// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  Computed<Color> _$whiteOrNotComputed;

  @override
  Color get whiteOrNot => (_$whiteOrNotComputed ??=
          Computed<Color>(() => super.whiteOrNot, name: '_AppStore.whiteOrNot'))
      .value;

  final _$primaryAtom = Atom(name: '_AppStore.primary');

  @override
  Color get primary {
    _$primaryAtom.reportRead();
    return super.primary;
  }

  @override
  set primary(Color value) {
    _$primaryAtom.reportWrite(value, super.primary, () {
      super.primary = value;
    });
  }

  final _$secondaryAtom = Atom(name: '_AppStore.secondary');

  @override
  Color get secondary {
    _$secondaryAtom.reportRead();
    return super.secondary;
  }

  @override
  set secondary(Color value) {
    _$secondaryAtom.reportWrite(value, super.secondary, () {
      super.secondary = value;
    });
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setPrimary(Color value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setPrimary');
    try {
      return super.setPrimary(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSecondary(Color value) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setSecondary');
    try {
      return super.setSecondary(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
primary: ${primary},
secondary: ${secondary},
whiteOrNot: ${whiteOrNot}
    ''';
  }
}
