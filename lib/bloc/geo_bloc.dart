import '../model/geo_response.dart';
import '../repo/geo_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class GeoBloc extends Bloc {
  GoeResponseModel response;

  final _repository = GeoRepository();

  final geoFetcher = PublishSubject<GoeResponseModel>();

  GeoBloc(BuildContext context) : super(context);

  Stream<GoeResponseModel> get list => geoFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> fetchAddress(double lat, double long) async {
    response = await _repository.fetchAddress(lat.toString(), long.toString());
    geoFetcher.sink.add(response);
  }

  @override
  void dispose() {
    geoFetcher.close();
  }
}
