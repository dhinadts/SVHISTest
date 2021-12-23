import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../bloc/bloc.dart';
import '../../../model/base_response.dart';
import '../../../model/subscription_response.dart';
import '../../../model/subscriptions_model.dart';
import '../repo/subscription_repository.dart';
import '../subscription_screen.dart';

class SubscriptionBloc extends Bloc {
  SubscriptionResponse response;
  SubscriptionsModel subscription;
  BaseResponse baseResponse;

  final _repository = SubscriptionRepository();

  final subscriptionListFetcher = PublishSubject<SubscriptionResponse>();
  final subscriptionAddFetcher = PublishSubject<BaseResponse>();
  final subscriptionUserListFetcher = PublishSubject<SubscriptionsModel>();

  SubscriptionBloc(BuildContext context) : super(context);

  Stream<SubscriptionResponse> get list => subscriptionListFetcher.stream;

  Stream<BaseResponse> get base => subscriptionAddFetcher.stream;

  @override
  void init() {}
  bool isAllPagesLoaded;

  Future<void> getSubscriptionList() async {
    response = await _repository.getSubscriptionList();
    subscriptionListFetcher.sink.add(response);
  }

  Future<void> updateSubscription(
      {SubscriptionRequest request,
      String subscriptionName,
      bool status,
      bool isSubscribeCall = true}) async {
    baseResponse = await _repository.updateSubscription(
        request: request,
        subscriptionName: subscriptionName,
        isSubscribeCall: isSubscribeCall,
        status: status);
    subscriptionAddFetcher.sink.add(baseResponse);
  }

  Future<void> getSubscription({String subscriptionName}) async {
    subscription = await _repository.getSubscriptionUserList(subscriptionName);
    subscriptionUserListFetcher.sink.add(subscription);
  }

  @override
  void dispose() {
    subscriptionListFetcher.close();
    subscriptionAddFetcher.close();
    subscriptionUserListFetcher.close();
  }
}
