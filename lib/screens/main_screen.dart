import 'package:banka/db.dart';
import 'package:banka/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_file.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

late Isar isar;
late List gelirler;


List tablo = []; 

final mainPadding = 20.0;
final para_birimi = "TL";

int toplamGelir = 0;
int toplamGider = 0;


class _MainScreenState extends State<MainScreen> {

  veriCek() async{
  final allRecipes = await isar.hesapVerileris.where().findAll();
  gelirler = []; 
  tablo = [];
  toplamGelir = 0;
  toplamGider = 0;

  setState(() {
   allRecipes.forEach((element){
    if(element.type == false){
      toplamGider += element.price ?? 0;
      tablo.add(_PieData(element.title ?? "bos",element.price ?? 0 , "${element.price} ${para_birimi} (${element.category})"));
    }else if(element.type == true){
      toplamGelir += element.price ?? 0;
    }
     });
  });
}

baglanti() async{
  isar = await Isar.open([HesapVerileriSchema]);
  if(isar.isOpen){
    setState(() {
      veriCek();
    });
  }
}
  @override
  void initState(){
    super.initState();
    baglanti();
  }

  void despose(){
    isar.close();
  }

  @override
  Widget build(BuildContext context) {  
    baglanti();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
          Text("ABC", style: TextStyle(
            fontWeight: FontWeight.w200
          ),),
          Text("Bankası")
        ]),
      ),
      body: Column(children: [
        Container( // ana ekran kırmızı alan
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(mainPadding),
          decoration: const BoxDecoration(
            color: Colors.red
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( // kişi ve tarih bilgisi
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hoşgeldin", textAlign: TextAlign.left, style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 25,
                    color: Colors.white
                  ),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SfCircularChart(
                  backgroundColor: Color.fromARGB(57, 0, 0, 0),
                  margin: EdgeInsets.only(top: 20),
                  title: ChartTitle(text: "Toplam Harcamalarım", textStyle: TextStyle(
                    color: Colors.white
                  )),
                   series: <DoughnutSeries<_PieData, String>>[
                    DoughnutSeries<_PieData, String>(
                      strokeColor: Colors.white,
                      dataSource: [
                         for(var i=0; i<tablo.length; i++)
                            tablo[i]
                       ],
                       xValueMapper: (_PieData data, _) => data.xData,
                       yValueMapper: (_PieData data, _) => data.yData,
                       dataLabelMapper: (_PieData data, _) => data.text,
                       dataLabelSettings: DataLabelSettings(isVisible: true)),
                       ]
                  ),
              ),

              IconButton(
                onPressed: (){
                  setState(() {
                    veriCek();
                  });
                  
              }, icon: Icon(Icons.refresh))
              
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.all(mainPadding),
          padding: EdgeInsets.all(mainPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(199, 224, 224, 224),
            border: Border.all(width: 1, color: Colors.black12)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text("Hesabım", style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w200
            ),),
            Text("${toplamGelir - toplamGider}")
            ],),

            TextButton(onPressed: (){
              context.go('/details');
            }, child: Text("Detaylar", style: TextStyle(
              color: Colors.red
            ),),)
          ],)
        ),
        ElevatedButton(onPressed: (){
          
          context.go('/add');
          
        }, 
        child: Text("Yeni Gider/Gelir Bildirimi"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 55, 203, 127)
        ),)
      ]),

    );
  }
}



class _PieData {
 _PieData(this.xData, this.yData, this.text);
 final String xData;
 final num yData;
 final String text;
}