import 'package:app_peliculas/src/page/home_page.dart';
import 'package:app_peliculas/src/page/pelicula_detalle.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> obtenerRutas() {
  return <String, WidgetBuilder>{
    "/": (BuildContext context) => HomePage(),
    "/detalle": (BuildContext context) => const PeliculaDetalle(),
  };
}
