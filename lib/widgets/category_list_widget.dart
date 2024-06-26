import 'package:artist_community_admin/firebase_services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  Widget categoryWidget(data) {
    //print("Image URL: ${data['image']}");
    return Card(
      color: Colors.grey.shade400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(
                data['image'],
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) {
                  //print("Error loading image: $error");
                  return const Icon(Icons.error); // Placeholder for failed image
                },
              ),
            ),
            Text(data['catName']),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseService services = FirebaseService();
    return StreamBuilder<QuerySnapshot>(
      stream: services.categories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.data!.size == 0) {
          return const Text('No Categories Added');
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, crossAxisSpacing: 3, mainAxisSpacing: 3),
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];
            return categoryWidget(data);
          },
        );
      },
    );
  }
}
