import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../shared/controllers/ler.dart';
import '../../../../shared/controllers/listagem_titulo.dart';
import '../../../../shared/interfaces/repository_unique.dart';
import '../../../../shared/widgets/pagina_imagem/pagina_imagem_widget.dart';

part 'ler_controller.g.dart';

class LerController = _LerBase with _$LerController;

abstract class _LerBase extends Ler with Store {
  final IRepositoryUnique _repo = Modular.get<IRepositoryUnique>();

  _LerBase(ListagemTitulo controller) : super(controller);

  @override
  @action
  void listarImagens({bool refresh = false}) {
    if (capitulo == null) capitulo = Modular.args.data;
    icone = Icons.pause;
    pagina = '';
    imagens = null;
    paginacao = true;
    imagens = _repo
        .imagens(
      capitulo.link,
      refresh: refresh,
      cancel: cancel,
    )
        .then(
      (data) {
        index = data.length > 0 ? 0 : -1;
        pagina = "${index + 1}/${data.length}";
        if (index == -1) {
          return [
            Center(
              child: RaisedButton(
                child: Text("Recarregar Imagens"),
                onPressed: () => listarImagens(refresh: true),
              ),
            )
          ];
        }
        return data.map((String i) => PaginaImagemWidget(url: i)).toList();
      },
    ).asObservable();
  }
}
