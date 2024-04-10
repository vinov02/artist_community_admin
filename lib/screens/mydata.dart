import 'package:artist_community_admin/constants/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/mydata.dart';

class MyData extends StatefulWidget {
  const MyData({super.key});

  @override
  State<MyData> createState() => _MyDataState();
}

class _MyDataState extends State<MyData> {
  getPosts() async {
    try{
      Uri url = Uri.parse("$baseURL/admin/products");
      var response = await http.get(url);
      if(response.statusCode == 200){
        print('success');
        var data = productFromJson(response.body);
        return data.product;
      }
      else{
        print('error during connection');
      }
    }catch (e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
          future: getPosts(),
          builder: (context, AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              List<ProductElement> products = snapshot.data;
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context , int index ){
                    final imageUrl = 'http://127.0.0.1:8000${products[index].image}';
                    print('Image URL: ${products[index].image}');
                    return  Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          leading: Image.network(imageUrl),
                          title: Text(products[index].name),
                          subtitle: Row(
                            children: [
                              Expanded(child: Text(products[index].id.toString())),
                              const Padding(padding: EdgeInsets.all(8.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
          }
      ) ,
    );
  }
}
