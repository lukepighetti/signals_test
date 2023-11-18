import 'package:flutter/foundation.dart';
import 'package:solidart/solidart.dart';

void loginAlice() {
  $userId.value = 'user-alice';
}

void loginBob() {
  $userId.value = 'user-bob';
}

void logout() {
  $userId.value = null;
}

final $userId = Signal<String?>(null);

final $userLoggedIn = Computed(() => $userId.value != null);

final $userProfile = Resource<({String userId, String name})?>(
  fetcher: () async {
    final uid = $userId.value;

    debugPrint('Fake fetching profile for uid: $uid');
    await Future.delayed(const Duration(milliseconds: 500)); // false delay

    return switch (uid) {
      null => null,
      'user-alice' => (userId: uid, name: "Alice"),
      'user-bob' => (userId: uid, name: "Bob"),
      _ => null,
    };
  },
  source: $userId,
);

final $selectedChannelId = Signal<String?>(null);

final _$chatStreamDependencies = Computed(() {
  return (selectedChannelId: $selectedChannelId.value, userId: $userId.value);
});

final $chatStream = Resource<List<({String username, String message})>>(
  source: _$chatStreamDependencies, // can we eliminate this source argument?
  stream: () async* {
    final messages = <({String username, String message})>[];
    final username = _$chatStreamDependencies.value
        .userId; // not sure how to fetch the user profile from a cached query

    var active = true;
    while (active) {
      if (username == null) {
        messages.clear();
      } else {
        messages.add((username: username, message: "It's a message!"));
      }
      yield messages;
      await Future.delayed(const Duration(seconds: 5));
    }
  },
);
