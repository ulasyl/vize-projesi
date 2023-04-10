import 'package:banka/db.dart';
import 'package:banka/screens/details_screen.dart';
import 'package:banka/screens/main_screen.dart';
import 'package:banka/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';

import '../widgets/text_field.dart';

class ProcessScreen extends StatefulWidget {
  final Isar isar; 
  final id;
  const ProcessScreen({super.key, required this.isar, required this.id});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

final titleController = TextEditingController();
final priceController = TextEditingController();
final descriptionController = TextEditingController();
late DateTime tarih;
late String category;


class _ProcessScreenState extends State<ProcessScreen> {

  veriler(id) async{
  isar.writeTxn(() async{
      final veri = await isar.hesapVerileris.get(id);
      titleController.text = veri!.title.toString();
      priceController.text = veri.price.toString();
      descriptionController.text = veri.description.toString();
      setState(() {
        tarih = veri.tarih ?? DateTime.now();
        category = veri.category ?? "";
      });
   });
}

guncelle(id) async{
  isar.writeTxn(() async{
    final veri = await isar.hesapVerileris.get(id);
    veri!.title = titleController.text;
    veri.price = int.parse(priceController.text);
    veri.description = descriptionController.text;
    isar.hesapVerileris.put(veri);
  });
}

sil(id) async{
  await isar.writeTxn(() async {
  await isar.hesapVerileris.delete(id);
});
}

  void initState(){
    setState(() {
      veriler(int.parse(widget.id));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Detaylar ve İşlemler", router: "/details"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          InputArea(title: "Ad", controller: titleController,),
          InputArea(title: "Ücreti", controller: priceController,),
          InputArea(title: "Açıklama", controller: descriptionController,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:10.0),
            child: Text("Harcama Türü: ${category}"),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red,
            ),
            child: Text("Tarih: ${DateFormat("d/M/yyyy").format(tarih)}", style: TextStyle(
              color: Colors.white
            ),)
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(onPressed: (){
                      guncelle(int.parse(widget.id));
                      showDialog(context: context, builder: (builder) => AlertDialog(
                           icon: Icon(Icons.info),
                           title: Text("Başarılı"),
                           content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            Text("Başarılı bir şekilde güncellenmiştir", textAlign: TextAlign.center,),
                            Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: ElevatedButton(onPressed: (){
                               context.go("/details");
                            }, child: Text("Tamam")),
                          )
                        ],
                     ),
                  ));
                  }, child: Text("Güncelle"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  ),),
                ),
              
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(onPressed: (){
                    sil(int.parse(widget.id));
                    showDialog(context: context, builder: (builder) => AlertDialog(
                           icon: Icon(Icons.info),
                           title: Text("Başarılı"),
                           content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            Text("Başarılı bir şekilde silinmiştir", textAlign: TextAlign.center,),
                            Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: ElevatedButton(onPressed: (){
                               context.go("/details");
                            }, child: Text("Tamam")),
                          )
                        ],
                     ),
                  ));
                  }, child: Text("Sil"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 141, 133)
                  ),),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
