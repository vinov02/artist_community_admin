import 'package:artist_community_admin/models/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageGridView extends StatefulWidget {
  const ImageGridView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {

  getPosts() async {
    try{
      Uri url = Uri.parse("https://dummyjson.com/products");
      var response = await http.get(url);
      if(response.statusCode == 200){
        print('success');
        var data = postsModelFromJson(response.body);
        return data.products;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Grid'),
      ),
      body: FutureBuilder(
        future: getPosts(),
        builder: (context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            List<Product> product = snapshot.data;
            return ListView.builder(
              itemCount: product.length,
              itemBuilder: (BuildContext context , int index ){
                return  Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      leading: Image.network(product[index].thumbnail),
                      title: Text(product[index].title),
                      subtitle: Row(
                        children: [
                          Expanded(child: Text(product[index].description)),
                          Padding(padding: const EdgeInsets.all(8.0),
                          child: Text(product[index].price.toString()),
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
      )
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ImageGridView(),
  ));
}
