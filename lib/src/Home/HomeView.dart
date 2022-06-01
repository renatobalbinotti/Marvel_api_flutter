import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marvel_api_flutter/src/Http/HttpProvider.dart';
import 'package:marvel_api_flutter/src/models/models.dart';

class Home extends StatefulWidget {
  
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _httpProvider = HttpProvider();
  final controllerBuscaHeroi = TextEditingController();
  List<Character> _herois = [];
  bool _carregando = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _buscaHerois('');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogos Marvel'),
      ),
      body: Column(
        children: [
          _criaBusca(),
          _geraMarvel(),
        ],
      ),
    );
  }

  Widget _criaBusca(){
    return Column( 
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: TextField(
            controller: controllerBuscaHeroi,
            decoration:
              const InputDecoration(
                hintText: 'Procura Herói',
                border: UnderlineInputBorder(),
                icon: Icon(Icons.search)
              ),
            onChanged: (value) {
              if (_timer != null){
                _timer!.cancel();
              }
              _timer = Timer(const Duration(
                milliseconds: 700), () {
                  _buscaHerois(
                    controllerBuscaHeroi.text != ''
                    ? controllerBuscaHeroi.text
                    : ''
                  );
                }
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _geraMarvel(){
    return  _carregando 
           ? const Center(child: CircularProgressIndicator())
           : _constroiListaHerois();
  }

  Widget _constroiListaHerois() {
    return Expanded(
      child: ListView.builder(
        itemCount: _herois.length,
        itemBuilder: (context, index) => _criaItemLista(index),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      ),
    );
  }

  Widget _criaItemLista(int index){
    final heroi = _herois[index];
    return ListTile(
      leading: _controiImageHeroi(heroi.thumbnail),
      title: Text(heroi.name!),
      subtitle: Text(heroi.description != null ? heroi.description! : 'Sem descrição'),
    );
  }
  
  Widget _controiImageHeroi(Thumbnail? thumbnail) {
    if (thumbnail != null) {
      return Image.network(
        "${thumbnail.path}.${thumbnail.extension}",
        width: 50,
        fit: BoxFit.fill,
      );
    }
    return const Icon(Icons.portable_wifi_off);
  }

  void _alteraCarregando(bool carregando){
    setState(() {
      _carregando = carregando;
    });
  }

  void _buscaHerois(String buscaHeroi) async {
    _alteraCarregando(true);
    final result = await _httpProvider.get(textoPesquisa: buscaHeroi.toLowerCase());
    setState(() {
      _herois = result.data!.results!;
    });
    _alteraCarregando(false);
  }
}                     