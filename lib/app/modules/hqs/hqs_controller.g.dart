// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hqs_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HqsController on _HqsBase, Store {
  final _$titulosAtom = Atom(name: '_HqsBase.titulos');

  @override
  ObservableFuture<List<TituloModel>> get titulos {
    _$titulosAtom.context.enforceReadPolicy(_$titulosAtom);
    _$titulosAtom.reportObserved();
    return super.titulos;
  }

  @override
  set titulos(ObservableFuture<List<TituloModel>> value) {
    _$titulosAtom.context.conditionallyRunInAction(() {
      super.titulos = value;
      _$titulosAtom.reportChanged();
    }, _$titulosAtom, name: '${_$titulosAtom.name}_set');
  }

  final _$_HqsBaseActionController = ActionController(name: '_HqsBase');

  @override
  void listar({bool refresh = false}) {
    final _$actionInfo = _$_HqsBaseActionController.startAction();
    try {
      return super.listar(refresh: refresh);
    } finally {
      _$_HqsBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<TituloModel> pesquisar(dynamic res) {
    final _$actionInfo = _$_HqsBaseActionController.startAction();
    try {
      return super.pesquisar(res);
    } finally {
      _$_HqsBaseActionController.endAction(_$actionInfo);
    }
  }
}
