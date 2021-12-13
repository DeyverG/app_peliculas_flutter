import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CardSwiperWidget extends StatelessWidget {
  //se añade peliculas en el constructor para inicializarlo
  const CardSwiperWidget({Key? key, required this.peliculas}) : super(key: key);

  final List<Pelicula> peliculas;

  @override
  Widget build(BuildContext context) {
    //Tamaño para volver las card responsive para diferentes pantallas
    final _screenSize = MediaQuery.of(context).size;

    //Diseño de las tarjetas
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Swiper(
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context, int index) {
            //le asignamos el id unico para cuando se use el Hero
            peliculas[index].uniqueId = "${peliculas[index].id}-swiper";
            return Hero(
              tag: peliculas[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    placeholder: const AssetImage("assets/img/no-image.jpg"),
                    image: NetworkImage(peliculas[index].getImage()),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/detalle",
                        arguments: peliculas[index]);
                  },
                ),
              ),
            );
          },
          itemCount: peliculas.length,
          layout: SwiperLayout.STACK),
    );
  }
}
