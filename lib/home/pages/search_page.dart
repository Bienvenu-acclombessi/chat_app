import 'package:chatapp/commun/widgets/error_page.dart';
import 'package:chatapp/home/widgets/contact_listile.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/userModel.dart';

class SearchPage extends StatefulWidget {
  final List<UserModel>? data;

  const SearchPage({super.key, this.data});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<UserModel>? _filteredData;

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_left,
                color: dark,
              )),
          title: Form(
              key: formKey,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
        _filteredData = widget.data!
            .where((user) => user.nom.toLowerCase().contains(value.toLowerCase()) ||
                user.prenom.toLowerCase().contains(value.toLowerCase()) ||
                user.email.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
                },
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Rechercher"),
              )),
          elevation: 1.0,
        ),
        body: SafeArea(
          child: _filteredData!.length>0 ? Container(
            margin: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              itemCount: _filteredData!.length,
              itemBuilder: (context, index) {
                UserModel user = _filteredData![index];
                return ContactListile(user: user);
              },
            ),

          ): ErrorPage(url_image:'assets/images/search_no_found.png',texte:'Aucun element trouvé '),
           
        ));
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.size,
  }) : super(key: key); 

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: size.width / 1.4,
          child: const ListTile(
            leading: CircleAvatar(
              backgroundColor: all,
              foregroundColor: white,
              backgroundImage: AssetImage("assets/images/full_screen.png"),
              radius: 25,
            ),
            title: Text("Henrich"),
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.call,
                  size: 18,
                  color: all,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.videocam,
                  size: 18,
                  color: all,
                ))
          ],
        )
      ],
    );
  }
}
