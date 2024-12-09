import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scryfall_app/api.dart';

class Search extends StatelessWidget {
  Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF242031),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Search Cards', style: TextStyle(color: Colors.white),),
        ),
        body: buildCardsLayout()
        );
  }

  Widget buildCardsLayout() {
    Future<Map> requestCards = Api.searchByName(Get.arguments.toString());

    return Container(
      child: FutureBuilder(
        future: requestCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if (snapshot.hasData) {
            final responseCards = snapshot.data!;
            
            if (responseCards['object'] == 'list') {
              List<dynamic> cards = responseCards['data'];
              List<Widget> rows = [];
              Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
            
              int itensRowCounter = 0;
            
              if (cards.length < 100) {
                rows.add(Text('${cards.length} cards where the name includes'));
                rows.add(Text('"${Get.arguments}"'));
              }
              else {
                rows.add(Text('+100 cards where the name includes "${Get.arguments}"'));
                rows.add(Text('(Maximum shown: 100)'));
              }
            
              for (int i = 0; i < cards.length; i++) {
                if (i == 100) break;
            
                if (cards[i]['image_uris'] != null) {
                  row.children.add(
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: Image.network(cards[i]['image_uris']['small']),
                        onPressed: () => Get.toNamed('/details', arguments: cards[i]),
                      ),
                    )
                  );
                }
                else if (cards[i]['card_faces'] != null) {
                  row.children.add(
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: Image.network(cards[i]['card_faces'][0]['image_uris']['small']),
                        onPressed: () => Get.toNamed('/details', arguments: cards[i]),
                      ),
                    )
                  );
                } 
                else {
                  row.children.add(
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Card Not Available.'),
                    )
                  );
                }
            
                itensRowCounter++;
            
                // Se linha estiver cheia
                if (itensRowCounter == 2) {
                  itensRowCounter = 0;
            
                  rows.add(row);
            
                  row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
                }
              }
            
              // Adiciona itens remanecentes
              if (itensRowCounter < 2) {
                rows.add(row);
              }
            
              return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: rows));
            }
            
            return Center(child: Text('No cards found.'));
          } 
          
          else {
            return Center(child: Text('Not Found.'));
          }
        }),
    );
  }
}
