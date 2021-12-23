import '../repository/staticDetails_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class StaticDetailsBloc extends Bloc {
  final _repositorys = ItemsListRepository();

  final itemsListFetcher = PublishSubject<List<String>>();
  final countyListFetcher = PublishSubject<List<String>>();
  final stateListFetcher = PublishSubject<List<String>>();
  final itemRelatedTagListFetcher = PublishSubject<String>();
  final categoryListFetcher = PublishSubject<List<String>>();
  final subCategoryListFetcher = PublishSubject<List<String>>();

  StaticDetailsBloc(BuildContext context) : super(context);

  Stream<List<String>> get list => itemsListFetcher.stream;
  Stream<List<String>> get countyListStream => countyListFetcher.stream;
  Stream<List<String>> get stateListStream => stateListFetcher.stream;
  Stream<String> get itemRelatedTagList => itemRelatedTagListFetcher.stream;
  Stream<List<String>> get categoryListStream => categoryListFetcher.stream;
  Stream<List<String>> get subCategoryListStream =>
      subCategoryListFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchItemsList() async {
    print("Hello Pranay in itemsListFetcher");
    List<String> response = await _repositorys.fetchItemsList();

    itemsListFetcher.sink.add(response);
  }

  Future<void> fetchCountyList() async {
    print("Hello Pranay in fetchCountyList");
    List<String> response = await _repositorys.fetchCountyList();

    countyListFetcher.sink.add(response);
  }

  Future<void> fetchStateList() async {
    print("Hello Pranay in itemsListFetcher");
    List<String> response = await _repositorys.fetchStateList();

    stateListFetcher.sink.add(response);
  }

  Future<void> fetchItemRelatedTagList(String itemName) async {
    print("Hello Pranay in fetchItemRelatedTagList");
    String response = await _repositorys.fetchItemRelatedTagList(itemName);

    itemRelatedTagListFetcher.sink.add(response);
  }

  Future<void> fetchCategoryList() async {
    print("Hello Pranay in fetchCategoryList");
    List<String> response = await _repositorys.fetchCategoryList();

    categoryListFetcher.sink.add(response);
  }

  Future<void> fetchSubCategoryList(String categoryType) async {
    print("Hello Pranay in fetchSubCategoryList");
    List<String> response =
        await _repositorys.fetchSubCategoryList(categoryType);

    subCategoryListFetcher.sink.add(response);
  }

  @override
  void dispose() {
    itemsListFetcher.close();
    countyListFetcher.close();
    stateListFetcher.close();
    itemRelatedTagListFetcher.close();
    categoryListFetcher.close();
    subCategoryListFetcher.close();
  }
}
