import 'package:artist_community_admin/firebase_services/firebase_service.dart';
import 'package:artist_community_admin/widgets/category_list_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class CategoryScreen extends StatefulWidget {


  static const String id = 'category';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  final TextEditingController _catName = TextEditingController();
  final FirebaseService _services = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  dynamic image;
  String? fileName;

  PickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, allowMultiple: false
    );
    if(result != null){
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }else{
      print("failed");
    }
  }

  saveImageToDb() async {
    EasyLoading.show();
    var ref = storage.ref('categoryImage/$fileName');
    try{
      await ref.putData(image);
      String downloadURL = await ref .getDownloadURL().then((value) {
        if (value.isNotEmpty){
          _services.saveCategory({
            'catName' : _catName.text,
            'image' : value,
            'active' : true
          }).then((value) {
            clear();
            EasyLoading.dismiss();
          });
        }
        return value;
      });
    } on FirebaseException catch (e) {
      clear();
      EasyLoading.dismiss();
      print(e.toString());
    }
  }

  clear(){
    setState(() {
      _catName.clear();
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            children: [
              const SizedBox(height: 10,),
              Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade800)
                    ),
                    child:  Center(child: image==null ?  const Text("Category Image"):Image.memory(image),),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed:
                      PickImage,
                      child:  const Text('Upload'),
                  )
                ],
              ),
              const SizedBox(width: 20,),
               SizedBox(
                width: 200,
                child:  TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Category Name';
                    }
                  },
                  controller: _catName,
                  decoration: const InputDecoration(
                      label: Text('Enter Category Name'),
                      contentPadding: EdgeInsets.zero
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              OutlinedButton(onPressed: clear,
                  child: const Text('Cancel'),
              ),
              const SizedBox(width: 10,),
              image == null ? Container(): ElevatedButton(onPressed: (){
                if(_formKey.currentState!.validate()){
                  saveImageToDb();
                }
              },
                child: const Text('Save'),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category List',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          const CategoryListWidget()
        ],
      ),
    );
  }
}
