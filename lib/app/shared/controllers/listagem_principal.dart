import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';

import '../interfaces/repository_principal.dart';
import '../models/titulo_model.dart';

part 'listagem_principal.g.dart';

abstract class ListagemPrincipal extends _ListagemPrincipalBase
    with _$ListagemPrincipal {
  @override
  @mustCallSuper
  void dispose() {
    scroll.dispose();
    if (!_cancel.isCancelled) _cancel.cancel();
  }
}

abstract class _ListagemPrincipalBase extends Disposable with Store {
  final IRepositoryPrincipal _repo = Modular.get<IRepositoryPrincipal>();
  final ScrollController scroll = ScrollController();
  final CancelToken _cancel = CancelToken();

  Future<Box<TituloModel>> _box;

  @observable
  ObservableFuture<List<TituloModel>> titulos;

  @protected
  Future<Box<TituloModel>> get box => _box;
  @protected
  set box(Future<Box<TituloModel>> value) => _box = value;

  _ListagemPrincipalBase() {
    listar();
  }

  @action
  void listar({bool refresh = false}) {
    titulos = null;
    titulos = this
        ._repo
        .pegarListagem(refresh: refresh, cancel: _cancel)
        .asObservable();
    iniciaBox();
  }

  @action
  void iniciaBox() {
    titulos.then((List<TituloModel> data) async {
      Box<TituloModel> boxHive = (await _box);
      int i = 0;
      for (TituloModel t in data) {
        if (boxHive.containsKey(t.nomeFormatado)) {
          t.favorito = boxHive.get(t.nomeFormatado).favorito ?? false;
          if (t.favorito) {
            data.remove(t);
            data.insert(i++, t);
          }
        }
      }
      return data;
    });
  }

  @action
  List<TituloModel> pesquisar(res) {
    if (titulos.value?.length == null) return [];
    List pesquisa = titulos.value is List
        ? titulos.value
            .where((t) => t.nome.toLowerCase().contains(res.toLowerCase()))
            .toList()
        : [];
    if (pesquisa == null || pesquisa?.length == null) return [];
    return pesquisa?.length != null && pesquisa.length > 0
        ? pesquisa
        : titulos.value;
  }

  @action
  Future<void> addFavorito(TituloModel titulo) async {
    titulo.setFavorito(!titulo.favorito);
    (await box).put(titulo.nomeFormatado, titulo);
  }
}
