import 'package:dam_u3_practica2_coleccionsimplefirestore/serviciosremotos.dart';
import 'package:flutter/material.dart';

class practica2 extends StatefulWidget {
  const practica2({super.key});

  @override
  State<practica2> createState() => _practica2State();
}

class _practica2State extends State<practica2> {
  int _indice = 0;
  final nombre = TextEditingController();
  final poder = TextEditingController();
  final edad = TextEditingController();
  int? vuela;
  bool? puedeVolar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Práctica 2"),
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Text("SS"),
                  ),
                  SizedBox(height: 10,),
                  const Text("Santiago Santillán",style: TextStyle(color: Colors.white,fontSize: 25),)
                ],
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            SizedBox(height: 40,),
            _item(Icons.account_box,"Mostrar",0),
            SizedBox(height: 10,),
            _item(Icons.add,"Agregar",1),
          ],
        ),
      ),
    );
  }


  Widget dinamico(){
    switch(_indice){
      case 0:{
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(40),
                  child: Text("Super héroes", style:
                  TextStyle(color: Colors.white, fontSize: 40),),
                  decoration: BoxDecoration(
                      color: Colors.redAccent
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 500,
                  child: FutureBuilder(
                      future: DB.mostrarTodos("superHeroes"),
                      builder: (context, listaJSON) {
                        if (listaJSON.hasData) {
                          return ListView.builder(
                              itemCount: listaJSON.data?.length,
                              itemBuilder: (context, indice) {
                                return ListTile(
                                  title:
                                  Text("Poderes: ${listaJSON.data?[indice]['poder']}"),
                                  subtitle:
                                  Text("Edad: ${listaJSON.data?[indice]['edad']} años. ${listaJSON.data?[indice]['puedeVolar'] ? 'Sí puede volar' : 'No puede volar'}" ),
                                  leading: Text(
                                      (listaJSON.data?[indice]['nombre'])
                                          .toString()),
                                  focusColor: Colors.red,
                                  hoverColor: Colors.green,
                                  autofocus: true,
                                  onTap: () {
                                    nombre.text=listaJSON.data?[indice]['nombre'];
                                    poder.text=listaJSON.data?[indice]['poder'];
                                    edad.text=listaJSON.data?[indice]['edad'].toString() ?? '';
                                    setState((){
                                      print("Editando");
                                      showModalBottomSheet(
                                        elevation: 5,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 15,
                                                left: 30,
                                                right: 30,
                                                bottom: MediaQuery.of(context).viewInsets.bottom+30
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                                children: [
                                                Text("Editar Super Heroe"),
                                                TextField(
                                                  controller: nombre,
                                                  decoration: InputDecoration(labelText: "Nombre"),
                                                ),
                                                  TextField(
                                                    controller: poder,
                                                    decoration: InputDecoration(labelText: "Poder"),
                                                  ),
                                                  TextField(
                                                    controller: edad,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(labelText: "Edad"),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Text("¿Puede volar?"),
                                                  RadioListTile(
                                                      title: Text("Vuela"),
                                                      value: 0,
                                                      groupValue: vuela,
                                                      onChanged: (value){
                                                        setState(() {
                                                          vuela = value;
                                                        });
                                                      }
                                                  ),
                                                  RadioListTile(
                                                      title: Text("No vuela"),
                                                      value: 1,
                                                      groupValue: vuela,
                                                      onChanged: (value){
                                                        setState(() {
                                                          vuela = value;
                                                        });
                                                      }
                                                  ),
                                                  FilledButton(
                                                      onPressed: (){
                                                        if(vuela==0){
                                                          puedeVolar=true;
                                                        }else{
                                                          puedeVolar=false;
                                                        }
                                                        var JSonTemporal = {
                                                          'nombre':nombre.text,
                                                          'poder':poder.text,
                                                          'edad':int.parse(edad.text),
                                                          'puedeVolar':puedeVolar
                                                        };
                                                        setState(() {
                                                          DB.actualizar(listaJSON.data?[indice]['id'],JSonTemporal);
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      child: const Text("Guardar")
                                                  )
                                              ]
                                            )
                                          );
                                        },
                                      );
                                    });
                                  },
                                  trailing: IconButton(
                                    onPressed: (){
                                      DB.eliminar(listaJSON.data?[indice]['id']).then((value){
                                        setState(() {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se ha eliminado")));
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                );
                              }
                          );
                        }
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        );
      }
      case 1:{
        return ListView(
          padding: EdgeInsets.all(40),
          children: [
            Text("Agregar súper heroe",style: TextStyle(fontSize: 36),),
            TextField(
              controller: nombre,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: poder,
              decoration: InputDecoration(labelText: "Poder"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: edad,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Edad"),
            ),
            SizedBox(height: 10),
            Text("¿Puede volar?"),
            RadioListTile(
                title: Text("Vuela"),
                value: 0,
                groupValue: vuela,
                onChanged: (value){
                  setState(() {
                    vuela = value;
                  });
                }
            ),
            RadioListTile(
                title: Text("No vuela"),
                value: 1,
                groupValue: vuela,
                onChanged: (value){
                  setState(() {
                    vuela = value;
                  });
                }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if(vuela==0){
                      puedeVolar=true;
                    }else{
                      puedeVolar=false;
                    }
                    var JSonTemporal = {
                      'nombre':nombre.text,
                      'poder':poder.text,
                      'edad':int.parse(edad.text),
                      'puedeVolar':puedeVolar
                    };

                    DB.insertar(JSonTemporal).then((value){
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se ha insertado")));
                        nombre.text="";
                        poder.text="";
                        edad.text="";
                      });
                    });
                  },
                  child: Text("Insertar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _indice = 0;
                    });
                  },
                  child: Text("Cancelar"),
                ),
              ],
            )
          ],
        );
      }
      default: return Center();
    }
  }

  Widget _item(IconData icono, String titulo, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _indice = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [
          Expanded(child: Icon(icono,size: 30,)),
          Expanded(child: Text(titulo,style: TextStyle(fontSize: 20),), flex: 2,)
        ],
      ),
    );
  }
}

