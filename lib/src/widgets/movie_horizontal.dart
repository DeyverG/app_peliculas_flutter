import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';

class MovieHorizontal extends StatelessWidget {
  MovieHorizontal(
      {Key? key, required this.peliculas, required this.siguientePagina})
      : super(key: key);

  //Definimos el listado de peliculas que nos llegan
  final List<Pelicula> peliculas;

  // y una funcion para seguir a la siguiente pagina
  final Function siguientePagina;

  //Definimos el controlador de la pagina donde inicia en la pagina 1
  // y cada pagina ocupara el 0.28% de la vista
  final PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.28);
  @override
  Widget build(BuildContext context) {
    //agregamos un escuchador de evento para cuando nos estemos acercando al final
    //de la pagina cargue la siguiente lista de peliculas
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    //obtenemos el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * 0.3,
      child: PageView.builder(
        controller: _pageController,
        pageSnapping: false,
        itemCount: peliculas.length,
        itemBuilder: (context, i) {
          return _tarjeta(context, peliculas[i], screenSize);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula, Size screenSize) {
    //le asignamos el id unico para cuando se use el Hero
    pelicula.uniqueId = "${pelicula.id}-poster";
    final tarjeta = Container(
      margin: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  height: screenSize.height * 0.22,
                  fit: BoxFit.fill,
                  placeholder: const AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(pelicula.getImage())),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3.0),
            child: Text(pelicula.title,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, "/detalle", arguments: pelicula);
      },
    );
  }
}
