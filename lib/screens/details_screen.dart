import 'dart:math';

import 'package:banka/db.dart';
import 'package:banka/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:banka/main.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

class DetailsScreen extends StatefulWidget {
  final isar; 
  const DetailsScreen({super.key, required this.isar});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

List veri = [];

veriler() async{
  if(veri.isNotEmpty){
    veri = [];
  }
  final allRecipes = await isar.hesapVerileris.where().findAll();
  allRecipes.forEach((element){
   veri.add(ValueLine(name: element.title, price: element.price, date: element.tarih ?? DateTime.now(), id: element.id, type: element.type,));
  });
}

class _DetailsScreenState extends State<DetailsScreen> {

  void initState(){
    veriler();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            GoRouter.of(context).go('/');
          },
        ),
        title: Text("Hesap Detayları"),
      ),
      body: Column(children: [
        Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(var i=0; i<veri.length; i++)
                        veri[i]
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("${veri.length} adet sonuç bulundu",),
                ),
                IconButton(onPressed: (){
                  setState(() {

                  });
                }, icon: Icon(Icons.refresh))
      ]),
    );
  }
}

class ValueLine extends StatelessWidget {
  final name;
  final price; 
  final DateTime date;
  final id;
  final type;

  const ValueLine({
    super.key, required this.name, required this.price, required this.date, required this.id, required this.type,
  });



  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.green; 
    if(type == false){
      textColor = Colors.red;
    }


    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Color.fromARGB(255, 230, 230, 230))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${name}", style: TextStyle(
                fontSize: 20
              ),),
              Text("${price} ${para_birimi}", style: TextStyle(
                color: textColor
                
              ),)
            ],
          ),
        ),
        
        Expanded(child: Text(DateFormat("d/M/yyyy").format(date), textAlign: TextAlign.center,),),
        Expanded(child: ElevatedButton(onPressed: (){
          
          GoRouter.of(context).go("/process?id=${id}");
        }, child: Text("İşlemler", style: TextStyle(
          color: Colors.black
        ),),
         style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),))
      ]),
    );
  }
}