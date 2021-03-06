import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_leitor/app/shared/interfaces/repository_assistir.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../../shared/interfaces/repository_unique.dart';
import '../../../shared/models/capitulo_episodio_model.dart';
import '../../../shared/models/titulo_model.dart';
import '../../../shared/utils/constants.dart';

class AnimeRepository extends IRepositoryUnique with IRepositoryAssistir {
  @override
  Future<List<CapEpModel>> listarTitulo(
    TituloModel anime, {
    bool refresh = false,
    CancelToken cancel,
  }) async {
    String data;
    try {
      data = await dio.getLink(anime.link,
          contextError: 'Titulos Não Carregaram',
          refresh: refresh,
          cancelToken: cancel);
    } on DioError catch (e) {
      anime.descricao = 'Erro ao Carregar';
      if (e.response == null) return [];
    }
    Document soup = parse(data), soupOriginal = parse(data);
    anime.descricao = soup.querySelector('p#sinopse').text.replaceAll('\n', '');
    String idCategoria = soup
        .querySelectorAll("div")
        .where((e) => e.attributes['data-id-cat'] != null)
        .toList()
        .map((e) => e.attributes['data-id-cat'])
        .toList()[0];
    int inicio = 1, fim = 20;
    Map<String, dynamic> pagina;
    List<CapEpModel> episodios = List();
    while (inicio <= fim) {
      Map<String, dynamic> data = {
        'id_cat': idCategoria.toString(),
        'page': inicio.toString(),
        'limit': 100.toString(),
        'total_page': fim.toString(),
        'order_video': 'asc',
      };
      try {
        pagina = await dio
            .postLink(ANIMEPOST,
                data: FormData.fromMap(data),
                contextError: "Falha ao Listar Episodios",
                refresh: true,
                cancelToken: cancel)
            .then(
          (data) {
            return json.decode(data);
          },
        );
      } on DioError catch (e) {
        if (e.response == null) return [];
      }
      fim = pagina['total_page'];
      inicio++;
      if (fim > 0) {
        for (String item in pagina['body']) {
          soup = parse(item);
          String tempoEp =
              soup.querySelector('div.epsBoxImg > div.tempoEps').innerHtml;
          Element ep = soup.querySelector('div.epsBoxSobre');
          String imagem = ep.parent
              .querySelector('div.epsBoxImg')
              .querySelector('img')
              .attributes['src'];
          List<String> info = ep
              .querySelectorAll('img')
              .where((d) => d.attributes['alt']?.isNotEmpty ?? false)
              .map((e) => e.attributes['alt'])
              .toList()
              .reversed
              .toList();
          episodios.add(
            CapEpModel(
              titulo: ep.querySelector('a').text,
              link: ep.querySelector('a').attributes['href'],
              info:
                  'Idioma: ${info[0]} Legenda: ${info.length > 1 ? info[1] : 'Sem Legenda'} Duração: $tempoEp',
              imagem: imagem,
            ),
          );
        }
      }
    }
    List<Element> box = soupOriginal.querySelectorAll(
      "div.conteudoBox > div.js_dropDownView",
    );
    if (box.isNotEmpty) {
      for (Element elemento in box) {
        Element parent = elemento.parent;
        List<Element> ova = parent.querySelectorAll('div.epsBox');
        if (ova.isNotEmpty) {
          for (Element ep in ova) {
            String tempoEp = ep.querySelector('div.tempoEps').innerHtml;
            String imagem = ep
                .querySelector('div.epsBoxImg')
                .querySelector('img')
                .attributes['data-src'];
            List<String> info = ep
                .querySelectorAll('img')
                .where((d) => d.attributes['alt']?.isNotEmpty ?? false)
                .map((e) => e.attributes['alt'])
                .toList()
                .reversed
                .toList();
            episodios.add(
              CapEpModel(
                titulo:
                    "OVA: ${ep.querySelector('div.epsBoxSobre').querySelector('a').text}",
                link: ep.querySelector('a').attributes['href'],
                info:
                    'Idioma: ${info[0]} Legenda: ${info.length > 1 ? info[1] : 'Sem Legenda'} Duração: $tempoEp',
                imagem: imagem,
              ),
            );
          }
        }
      }
    }
    return episodios;
  }

  /// Função Não Necessaria Neste Modulo
  @override
  @deprecated
  Future<List<String>> imagens(
    String link, {
    bool refresh,
    CancelToken cancel,
  }) {
    return null;
  }

  @override
  void dispose() {}
}
