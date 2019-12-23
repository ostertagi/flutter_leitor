import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_leitor/app/modules/mangas/mangas_bloc.dart';
import 'package:flutter_leitor/app/modules/mangas/mangas_module.dart';
import 'package:flutter_leitor/app/shared/models/titulo_model.dart';
import 'package:flutter_leitor/app/shared/widgets/pesquisar/pesquisar_widget.dart';

class PesquisarManga extends Pesquisar {
  MangasBloc bloc = MangasModule.to.get<MangasBloc>();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          bloc.listar();
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // close(context, query);
    bloc.pesquisar(query);
    return StreamBuilder(
      stream: bloc.dados,
      builder: (_, AsyncSnapshot<List<Titulo>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          itemCount: snapshot.data.length,
          itemBuilder: (_, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              leading: Container(
                height: 100,
                width: 50,
                child: ExtendedImage.network(snapshot.data[index].imagem,
                        cache: true, fit: BoxFit.fill),
              ),
              title: Text(snapshot.data[index].nome),
              onTap: () {
                Navigator.pushNamed(context, '/mangas/manga',
                    arguments: snapshot.data[index]);
              },
            );
          },
          separatorBuilder: (_, index) => Divider(),
        );
      },
    );
  }
}