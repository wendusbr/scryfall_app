import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scryfall_app/api.dart';

class Details extends StatelessWidget {
  Details({super.key});

  final Future<Map> rulings = Api.searchRulings(Get.arguments['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF242031),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),

      body: buildCardInfo()
    );
  }

  Widget buildCardInfo(){
    Map<dynamic, dynamic> card = Get.arguments;
    Future<Map> requestRulings = Api.searchRulings(card['id']);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            card['image_uris'] != null 
            ? Image.network(card['image_uris']['normal'])
            : Column(children: [
                Image.network(card['card_faces'][0]['image_uris']['normal']),
                SizedBox(height: 16.0,),
                Image.network(card['card_faces'][1]['image_uris']['normal']),
            ]),

            SizedBox(height: 16.0),
            Divider( color: Colors.black, thickness: 3.0),
            SizedBox(height: 8.0),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        buildLegality(card['legalities']['standard']),
                        SizedBox(width: 8.0,),
                        Text('Standard')
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['pioneer']),
                        SizedBox(width: 8.0,),
                        Text('Pioneer')
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['modern']),
                        SizedBox(width: 8.0,),
                        Text('Modern'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['legacy']),
                        SizedBox(width: 8.0,),
                        Text('Legacy'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['vintage']),
                        SizedBox(width: 8.0,),
                        Text('Vintage'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['commander']),
                        SizedBox(width: 8.0,),
                        Text('Commander'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['oathbreaker']),
                        SizedBox(width: 8.0,),
                        Text('Oathbreaker'),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 6.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        buildLegality(card['legalities']['alchemy']),
                        SizedBox(width: 8.0,),
                        Container(child: Text('Alchemy')),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['explorer']),
                        SizedBox(width: 8.0,),
                        Text('Explorer'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['historic']),
                        SizedBox(width: 8.0,),
                        Text('Historic'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['brawl']),
                        SizedBox(width: 8.0,),
                        Text('Brawl'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['timeless']),
                        SizedBox(width: 8.0,),
                        Text('Timeless'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        buildLegality(card['legalities']['pauper']),
                        SizedBox(width: 8.0,),
                        Text('Pauper'),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Row(
                        children: [
                          buildLegality(card['legalities']['penny']),
                          SizedBox(width: 8.0,),
                          Text('Penny'),
                        ],
                      ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8.0),
            Divider( color: Colors.black, thickness: 3.0),
            SizedBox(height: 16.0),

            FutureBuilder(
              future: requestRulings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } 
                else if (snapshot.hasData) {
                  final responseRulings = snapshot.data!;
                  List<Widget> rules = [];

                  if(responseRulings['data'].isNotEmpty){
                    rules.add(Text('NOTES AND RULES INFORMATION', style: TextStyle(fontWeight: FontWeight.bold)));
                    rules.add(SizedBox(height: 16.0));
                  }

                  responseRulings['data'].forEach((rule) {
                    rules.add(Text('${rule['comment']}'));
                    rules.add(SizedBox(height: 8.0));
                    rules.add(Text('(${rule['published_at']})', style: TextStyle(fontStyle: FontStyle.italic)));
                    rules.add(SizedBox(height: 16.0));
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rules,
                  );
                } 
                else {
                  return Center(child: Text('Not Found.'));
                }
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLegality(String legality) {
    switch (legality) {
      case 'legal':
        return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF75986E),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'LEGAL', 
                  style: TextStyle(
                    color: Colors.white
                    )
                  )
                );

      case 'not_legal':
        return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFaeaeae),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'NOT LEGAL', 
                  style: TextStyle(
                    color: Colors.white
                    )
                  )
                );

      case 'banned':
        return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFcc7d83),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'BANNED', 
                  style: TextStyle(
                    color: Colors.white
                    )
                  )
                );

      case 'restricted':
        return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF80a7b6),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'RESTRICT.', 
                  style: TextStyle(
                    color: Colors.white
                    )
                  )
                );

      default:
        return Text('Not Found.');
            
    }
    
  }
}