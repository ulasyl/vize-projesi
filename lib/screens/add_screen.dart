import 'package:banka/db.dart';
import 'package:banka/screens/main_screen.dart';
import 'package:banka/widgets/app_bar.dart';
import 'package:banka/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';


class AddScreen extends StatefulWidget {
  final isar;
  const AddScreen({super.key, this.isar,});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

final titleController = TextEditingController();
final priceController = TextEditingController();
final descriptionController = TextEditingController();

final kategoriler = ["Giyim","Elektronik","Yemek/İçmek","Eğlence","Diğer"];
String kategoriValue = kategoriler.first;

String groupValue = "";

ekle() async{
  bool tip = true;

  switch(groupValue){
    case "gider":
    tip = false;
    break;

    case "gelir":
    tip = true;
    break;
  }

  final data = HesapVerileri()..title = titleController.text
  ..price = int.parse(priceController.text)
  ..description = descriptionController.text
  ..category = kategoriValue
  ..type = tip
  ..tarih = DateTime.now();

  isar.writeTxn(() => isar.hesapVerileris.put(data));
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Yeni Gider/Gelir Bildirimi", router: "/",),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          InputArea(title: "Ad", controller: titleController),
          InputArea(title: "Fiyat", controller: priceController),
          InputArea(title: "Açıklama", controller: descriptionController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Gider"),
                        tileColor: const Color.fromARGB(255, 255, 185, 180),
                        value: "gider", 
                        groupValue: groupValue, 
                        onChanged: (value){
                          setState(() {
                            groupValue = value.toString();
                          });
                      }),
                    ),
                    Expanded(child: 
                    RadioListTile(
                       title: const Text("Gelir"),
                       tileColor: const Color.fromARGB(255, 141, 227, 143),
                       value: "gelir", 
                       groupValue: groupValue, 
                    onChanged: (value){
                    setState(() {
                      groupValue = value.toString();
                     });
                })
                 )
                  ],
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DropdownButton<String>(
                    value: kategoriValue,
                    dropdownColor: Color.fromARGB(255, 255, 255, 255),
                    items: kategoriler.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                               value: value,
                               child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width - 64,
                                child: Text(value, textAlign: TextAlign.center,),
                               ),
                         );
                     }).toList(), 
                     onChanged: (String? value) {  
                      setState(() {
                        kategoriValue = value.toString();
                      });
                     },
                  ),
          ),
              ElevatedButton(onPressed: (){
                ekle();
                titleController.text = "";
                priceController.text = "";
                descriptionController.text = "";
                showDialog(context: context, builder: (builder) => AlertDialog(
                  icon: Icon(Icons.info),
                  title: Text("Başarılı"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Başarılı bir şekilde eklenmiştir", textAlign: TextAlign.center,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(onPressed: (){
                          context.go("/");
                        }, child: Text("Tamam")),
                      )
                    ],
                  ),
                ));
              }
              , child: Text("Ekle", style: TextStyle(
                color: Colors.green,
              ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),)
        ]),
      ),
    );
  }
}