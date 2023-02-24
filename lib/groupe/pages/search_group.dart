import 'package:chatapp/commun/models/groupModel.dart';
import 'package:chatapp/groupe/widgets/group_search_tile.dart';
import 'package:chatapp/home/widgets/contact_listile.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/commun/colors/colors.dart';
import 'package:chatapp/commun/models/userModel.dart';

class SearchGroupPage extends StatefulWidget {
  final List<GroupModel>? data;

  const SearchGroupPage({super.key, this.data});

  @override
  State<SearchGroupPage> createState() => _SearchGroupPageState();
}

class _SearchGroupPageState extends State<SearchGroupPage> {
  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<GroupModel>? _filteredData;

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
            .where((group) => group.groupName.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
                },
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Rechercher par le nom du groupe"),
              )),
          elevation: 1.0,
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              itemCount: _filteredData!.length,
              itemBuilder: (context, index) {
                GroupModel group = _filteredData![index];
                return GroupSearchTile(group: group);
              },
            ),

          ),
        ));
  }
}