//Clase para contener todas las peliculas que se obtengan
class Peliculas {
  //Array de peliculas
  List<Pelicula> items = [];

  //Creamos el Constructor
  Peliculas();

  //Creamos otro Constructor que recibe el array de peliculas y los transforma
  // en base al modelo
  Peliculas.fromJsonList(List<dynamic> list) {
    //si la lista esta vacia no hacemos nada
    if (list.isEmpty) return;

    //recorremos la lista y por cada posicion convertimos el json en el modelo Pelicula
    // y lo añadimos a la lista de Peliculas llamado "items"
    for (var json in list) {
      final pelicula = Pelicula.fromJsonMap(json);
      items.add(pelicula);
    }
  }
}

//Modelo de peliculas con los datos que llegan
class Pelicula {
  //se define este parametro para user el Hero en ambos swiper
  //porque cuando el id se repite se explota la app
  late String uniqueId;

  late bool adult;
  late String backdropPath;
  late List<int> genreIds;
  late int id;
  late String originalLanguage;
  late String originalTitle;
  late String overview;
  late double popularity;
  late String posterPath;
  late String releaseDate;
  late String title;
  late bool video;
  late double voteAverage;
  late int voteCount;

  //Constructor
  Pelicula({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  //Creamos otro constructor para cuando se quiera generar una instancia de
  //peliculas que viene de un json
  Pelicula.fromJsonMap(Map<String, dynamic> json) {
    adult = json["adult"];
    backdropPath = json["backdrop_path"].toString();
    //genreIds llega como una lista dinamica "List<dynamic>" entonces la casteamos a int
    //para evitar errores
    genreIds = json["genre_ids"].cast<int>();
    id = json["id"];
    originalLanguage = json["original_language"];
    originalTitle = json["original_title"];
    overview = json["overview"];
    //Divimos entre 1 para cuando llegue como entero convertirlo a double
    popularity = json["popularity"] / 1;
    posterPath = json["poster_path"].toString();
    releaseDate = json["release_date"];
    title = json["title"];
    video = json["video"];
    voteAverage = json["vote_average"] / 1;
    voteCount = json["vote_count"];
  }

  //Funcion que retorna la foto de portada en caso de ser null
  //retorna una por defecto

  getImage() {
    if (posterPath == "null") {
      const url =
          'https://rhaizaespinoza.com/wp-content/themes/realestate-7/images/no-image.png';
      return url;
    } else {
      final urlPosterPath = "https://image.tmdb.org/t/p/w500$posterPath";
      return urlPosterPath;
    }
  }

  getPoster() {
    if (backdropPath == "null") {
      const url =
          'https://rhaizaespinoza.com/wp-content/themes/realestate-7/images/no-image.png';
      return url;
    } else {
      final urlPosterPath = "https://image.tmdb.org/t/p/w500$backdropPath";
      return urlPosterPath;
    }
  }
}
