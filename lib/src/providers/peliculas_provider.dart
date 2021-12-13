import 'dart:async';
import 'dart:convert';
import 'package:app_peliculas/src/models/actor_model.dart';
import 'package:app_peliculas/src/models/pelicula_model.dart';

//Instalamos el Paquete de "flutter http" y lo importamos
import 'package:http/http.dart' as http;

class PeliculasProvider {
  //Se definen los parametros que se usaran
  final String _apiKey = "fff1fef08db79ac637d0a4f912a470a3";
  final String _url = "api.themoviedb.org";
  final String _language = "es-ES";
  //Variable que maneja la paginacion
  int _popularesPage = 0;

  //Variable que funciona coom bandera para que no haga varias peticiones en
  // populares
  bool _cargando = false;

  //Definimos la lista de peliculas
  final List<Pelicula> _populares = [];

  //Definimos el StreamController
  final _popularesStream = StreamController<List<Pelicula>>.broadcast();

  //Definimos la funcion para agregar informacion al Stream
  //en este caso le definimos el tipo List<Pelicula>
  Function(List<Pelicula>) get popularesSink => _popularesStream.sink.add;

  //Ahora definimos el stream para poder escuchar cualquier cambio que se genere
  Stream<List<Pelicula>> get popularesStream => _popularesStream.stream;

  //Siempre que usemos un Stream se debe cerrar luego de que se destruye la vista
  void streamDispose() {
    _popularesStream.close();
  }

  //Funcion para traer las peliculas que estan "En Cines"
  //la cual es un Future que retorna una lista de peliculas
  Future<List<Pelicula>> getEnCines() async {
    //Armamos la url con los parametros
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    // llamamos la funcion y le pasamos la url armada
    return await _procesarRespuesta(url);
  }

  //Funcion que obtiene las peliculas populares
  Future<List<Pelicula>> getPopulares() async {
    //si cargando es true retornaremos un array vacio
    // porque ya se esta procesando una solicitud
    if (_cargando) return [];

    //colocamos el true en cargando para no permitir varias peticiones
    _cargando = true;
    //aumentamos en 1 la pagina
    _popularesPage++;

    //Armamos la url con los parametros
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    // llamamos la funcion y le pasamos la url armada
    final response = await _procesarRespuesta(url);

    //Agregamos el listado de peliculas a _populares
    _populares.addAll(response);

    //y tambien lo agregamos al Sink
    popularesSink(_populares);

    //la devolvemos a false luego de obtener todo los valores
    _cargando = false;
    //retornamos la lista
    return response;
  }

  //Funcion que recibe la url y procesa la respuesta
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    //Realizamos la peticion y esperamos la respuesta
    final response = await http.get(url);

    //Decodificamos la data que llega
    final decodedData = jsonDecode(response.body);

    //Ahora los transformamos al listado de peliculas
    final peliculas = Peliculas.fromJsonList(decodedData['results']);

    //Retornamos "items" el cual es el nombre del listado en la clase "Peliculas"
    return peliculas.items;
  }

  //Funcion que recibe el Id de la pelicula y retorna los actores
  Future<List<Actor>> getActores(String peliID) async {
    // Se arma la url
    final url = Uri.https(_url, '3/movie/$peliID/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    //Se realiza la peticion http
    final response = await http.get(url);

    //se decodifica la data que llega
    final decodedData = jsonDecode(response.body);

    // se le da la estructura de actor a la informacion
    final data = Actores.fromJsonList(decodedData["cast"]);

    //se retornan los actores
    return data.actores;
  }

  //Funcion para buscar las pelicuas
  //la cual es un Future que retorna una lista de peliculas
  Future<List<Pelicula>> buscarPelicula(String query) async {
    //Armamos la url con los parametros
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    // llamamos la funcion y le pasamos la url armada
    return await _procesarRespuesta(url);
  }
}
