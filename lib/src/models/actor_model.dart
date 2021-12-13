class Actores {
  List<Actor> actores = [];

  // Recibimos la lista y retornamos por aca objecto
  //Un objecto con las propiedades del actor definidas en el constructor
  Actores.fromJsonList(List<dynamic> list) {
    for (var item in list) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    }
  }
}

class Actor {
  late bool adult;
  late int gender;
  late int id;
  late String name;
  late String originalName;
  late double popularity;
  late String profilePath;
  late String character;
  late int order;

  Actor({
    required this.adult,
    required this.gender,
    required this.id,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.character,
    required this.order,
  });

  //por aca Objeto que llegue se le asigna a la variable creada en el constructor
  Actor.fromJsonMap(Map<String, dynamic> json) {
    adult = json["adult"];
    gender = json["gender"];
    id = json["id"];
    name = json["name"];
    originalName = json["original_name"].toString();
    popularity = json["popularity"];
    profilePath = json["profile_path"].toString();
    character = json["character"];
    order = json["order"];
  }

  getFoto() {
    if (profilePath == "null") {
      const url =
          'https://rhaizaespinoza.com/wp-content/themes/realestate-7/images/no-image.png';
      return url;
    } else {
      final urlPosterPath = "https://image.tmdb.org/t/p/w500$profilePath";
      return urlPosterPath;
    }
  }
}
