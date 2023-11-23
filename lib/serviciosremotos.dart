import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{

  static Future<List> mostrarTodos(String coleccion) async{
    List temporal = [];
    var query = await baseRemota.collection(coleccion).get();

    query.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      data.addAll({
        'id': element.id
      });
      temporal.add(data);
    });
    return temporal;
  }

  static Future<Map<String, dynamic>?> mostrarElemento(String coleccion, String id) async {
    try {
      var document = await baseRemota.collection(coleccion).doc(id).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data()!;
        data.addAll({
          'id': document.id,
        });
        return data;
      } else {
        // El documento con el ID especificado no existe
        return null;
      }
    } catch (e) {
      print('Error al obtener el elemento: $e');
      return null;
    }
  }


  static Future insertar(Map<String, dynamic> superheroe) async {
    return await baseRemota.collection("superHeroes").add(superheroe);
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("superHeroes").doc(id).delete();
  }

  static Future actualizar(String id, Map<String, dynamic> nuevosDatos) async{
    return await baseRemota.collection("superHeroes").doc(id).update(nuevosDatos);

  }
}