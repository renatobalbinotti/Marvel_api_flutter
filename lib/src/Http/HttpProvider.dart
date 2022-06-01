import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_api_flutter/src/Constaints/APIConsts.dart';
import 'package:marvel_api_flutter/src/models/models.dart';

class HttpProvider{


  Future<CharacterDataWrapper> get({String? textoPesquisa}) async {
    final ts = DateTime.now().microsecondsSinceEpoch;
    final hash =
        md5.convert(utf8.encode('$ts$privateKey$publicKey')).toString();

    final uri = textoPesquisa != null && textoPesquisa.isNotEmpty
        ? Uri.parse('$domain/characters?ts=$ts&apikey=$publicKey&hash=$hash&name=$textoPesquisa')
        : Uri.parse('$domain/characters?ts=$ts&apikey=$publicKey&hash=$hash');
            
    final response = await http.get(uri);
    final dados = jsonDecode(response.body);
    return CharacterDataWrapper.fromJson(dados);
  }


}