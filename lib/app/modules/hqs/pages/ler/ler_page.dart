import 'package:flutter/material.dart';
import 'package:flutter_leitor/app/modules/hqs/hqs_module.dart';
import 'package:flutter_leitor/app/modules/hqs/pages/ler/ler_bloc.dart';
import 'package:flutter_leitor/app/modules/hqs/widgets/pagina_hq/pagina_hq_widget.dart';
import 'package:flutter_leitor/app/shared/models/capitulo_model.dart';
import 'package:preload_page_view/preload_page_view.dart';

class LerPage extends StatelessWidget {
  final Capitulo capitulo;
  final LerBloc bloc = HqsModule.to.get<LerBloc>();
  LerPage({Key key, this.capitulo}) : super(key: key);

  @override
  StatelessElement createElement() {
    bloc.capitulo = capitulo;
    bloc.listarImagens();
    return super.createElement();
  }

  Widget mostrarPaginas() {
    return StreamBuilder(
      stream: bloc.pagina,
      builder: (_, snapshot) {
        return snapshot.hasData
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  snapshot.data,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitulo.titulo),
        actions: <Widget>[
          Center(
            child: mostrarPaginas(),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: bloc.dados,
            builder: (_, AsyncSnapshot<List<PaginaHqWidget>> snapshot) {
              return snapshot.hasData
                  ? PreloadPageView(
                      onPageChanged: bloc.mudar,
                      children: snapshot.data,
                      preloadPagesCount: 5,
                    )
                  : CircularProgressIndicator();
            }),
      ),
    );
  }
}