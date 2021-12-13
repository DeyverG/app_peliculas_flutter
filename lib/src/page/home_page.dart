import 'package:app_peliculas/src/providers/peliculas_provider.dart';
import 'package:app_peliculas/src/search/search_delegate.dart';
import 'package:app_peliculas/src/widgets/card_swiper_widget.dart';
import 'package:app_peliculas/src/widgets/movie_horizontal.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = PeliculasProvider();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Obtenemos el tamaño de la pantalla
    final screenSize = MediaQuery.of(context).size;

    //se Ejecuta por primera vez y se trae la primera pagina
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Películas en cines"),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_swiperTarjetas(screenSize), _footer(context, screenSize)],
      ),
    );
  }

  //Diseño de las tarjetas, recibe como parametro el tamaño del dispositivo
  Widget _swiperTarjetas(Size screenSize) {
    return FutureBuilder(
      //en Future asignamos el provider y llamamos la funcion
      future: PeliculasProvider().getEnCines(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //validamos que snapshot no este vacio
        if (snapshot.hasData) {
          //retornamos la lista que esta en la data de snapshot
          return CardSwiperWidget(peliculas: snapshot.data);
        } else {
          //Si esta vacio significa que esta esperando la peticion
          // por eso mostraremos un loading
          return SizedBox(
              height: screenSize.height * 0.5,
              child: const Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context, Size screenSize) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, bottom: 8.0, top: 10.0),
            child: Text(
              "Populares",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return SizedBox(
                    height: screenSize.height * 0.2,
                    child: const Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ],
      ),
    );
  }
}
