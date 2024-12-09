import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scryfall_app/api.dart';
import 'package:scryfall_app/models/favorite.dart';
import 'package:scryfall_app/services/database_service.dart';

class Favorites extends StatelessWidget {
  Favorites({super.key});

  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF242031),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Favorites Cards', style: TextStyle(color: Colors.white),),
        ),
      body: Container(
        child: StreamBuilder(
          stream: _databaseService.getFavorites(), 
          builder: (context, snapshot) {
            List favorites = snapshot.data?.docs ?? [];

            if (favorites.isEmpty) {
              return Center(child: Text('Add cards to favorites.'),);
            }

            List<Widget> rows = [];
            Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
            int itensRowCounter = 0;

            favorites.forEach((index) {
              Favorite favorite = index.data();

              row.children.add(
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: Image.network(favorite.card_image),
                        onPressed: () {
                          Api.searchById(favorite.card_id).then((response) {
                            Get.toNamed('/details', arguments: response);
                          });
                        },
                      ),
                    )
                  );

                itensRowCounter++;
            
                // Se linha estiver cheia
                if (itensRowCounter == 2) {
                  itensRowCounter = 0;
            
                  rows.add(row);
            
                  row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
                }
            });

            // Adiciona itens remanecentes
              if (itensRowCounter < 2) {
                rows.add(row);
              }
            
            return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: rows));
          }
          ),
      ),
    );
  }
}