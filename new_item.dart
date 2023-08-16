import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import '../data/categories.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  //GLOBAL KEY IS NEEDED TO WORK WITH FORMS
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.fruit];
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https('flutter-prep2-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(url,
          headers: {'content-type': 'application/json'},
          body: json.encode({
            'name': _enteredName,
            ' quantity': _enteredQuantity,
            'category': _selectedCategory!.title
          }));
 


      final Map<String, dynamic> resData=json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(GroceryItem(id: resData['name'], name: _enteredName, quantity: _enteredQuantity, category: _selectedCategory!));
    }
  }

  //VALIDATE IS DONE BY CONSIDERING THE VALIDATOR
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(label: Text('Name')),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length <= 1 ||
                          value.length >= 50) {
                        return 'Please enter a valid name!';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredName = newValue!;
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          label: Text('Quantitiy'),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: '1',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be valid, positive number';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enteredQuantity = int.parse(newValue!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    //USING EXPANDED BECAUSE WE USED TEXTFIELD INSIDE OF THE ROW
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: category.value.color,
                                  ),
                                  SizedBox(width: 6),
                                  Text(category.value.title),
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          //NO NEED TO USE ONSAVED HERE BECAUSE THE VALUE IS UPDATE AND SAVED BELOW
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _isSending ? null : _saveItem,
                      child: _isSending
                          ? SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Add Item'),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
