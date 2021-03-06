import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../models/titulo_model.dart';

class CardWidget extends StatelessWidget {
  final TituloModel titulo;

  const CardWidget({
    Key key,
    @required this.titulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ExtendedImage.network(
                  titulo.imagem,
                  height: 300,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.all(5),
          alignment: Alignment.centerLeft,
          child: Text(
            titulo.descricao,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
