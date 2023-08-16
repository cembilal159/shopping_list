import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';

const categories = {
  Categories.vegetables: Categoryy(
    'Vegetables',
    Color.fromARGB(255, 94, 231, 162),
  ),
  Categories.fruit: Categoryy(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: Categoryy(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Categoryy(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Categoryy(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Categoryy(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Categoryy(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Categoryy(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: Categoryy(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: Categoryy(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};