import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:app_peliculas/src/providers/peliculas_provider.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final sugerencias = ["Spiderman", "Superman"];

  final busqueda = ["Ironman", "Capitana Marvel", "Venom", "Shazam!"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Acciones de nuestro appBar
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que se muestran
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();
    return FutureBuilder(
      future: PeliculasProvider().buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
              children: peliculas!.map((pelicula) {
            //Editamos el UniqueId para que el hero no explote
            //debido que entramos a los detalles por la busqueda
            pelicula.uniqueId = "";
            return ListTile(
              leading: FadeInImage(
                height: 60,
                width: 70.0,
                fit: BoxFit.cover,
                image: NetworkImage(pelicula.getPoster()),
                placeholder: const AssetImage('assets/img/no-image.jpg'),
              ),
              title: Text(pelicula.title),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Text(pelicula.voteAverage.toString())
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "/detalle", arguments: pelicula);
              },
            );
          }).toList());
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  //Si Los Datos fueran Estaticos
  //
  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Son las sugerencias que aparecen cuando la persona escribe
  //   //si esta vacio mostramos las busquedas anteriores
  //   final data = query.isEmpty
  //       ? sugerencias
  //       : busqueda
  //           .where((element) =>
  //               element.toLowerCase().contains(query.toLowerCase()))
  //           .toList();
  //   return ListView.builder(
  //       itemCount: data.length,
  //       itemBuilder: (BuildContext context, int i) {
  //         return ListTile(
  //           leading: const Icon(Icons.movie),
  //           title: Text(data[i]),
  //         );
  //       });
  // }
}
