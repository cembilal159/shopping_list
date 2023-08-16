import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

//IN ORDER TO INITIATE THE FUNCTION BELOW, WHENEVER THE NEW ITEM ADDED TO LOAD THE NEW ADDED
//ITEM TO THE GROCERY LIST AND SHOW IT IN THE UI WE USE THIS FUNCTION IN INIT STATE
  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep2-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      _error = 'Failed to fetch data. Please try again';
    }
    
    if(response.body=='null')
    {
      setState(() {
        _isLoading=false;
      });
      return;
    }

    print(response.body);

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> _loadedItem = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;

      _loadedItem.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value[' quantity'],
          category: category));
    }

    setState(() {
      _groceryItems = _loadedItem;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (context) => const NewItem()));
    final url = Uri.https(
        'flutter-prep2-default-rtdb.firebaseio.com', 'shopping-list.json');
    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
    // if (newItem == null) {
    //   return null;
    // }
    // setState(() {
    //   _groceryItems.add(newItem);
    // });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('flutter-prep2-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    if (_error != null) {
      setState(() {
        content = Center(child: Text(_error!));
      });
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
          ],
          title: const Text('data'),
        ),
        body: content);
  }
}
