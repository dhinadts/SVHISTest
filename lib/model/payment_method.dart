import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String title;
  final String icon;
  final String description;
  final bool isAsset;

  PaymentMethod(
      {@required this.id,
      @required this.title,
      @required this.icon,
      @required this.description,
      @required this.isAsset});

  @override
  List<Object> get props => [id, title, icon, description, isAsset];
}
