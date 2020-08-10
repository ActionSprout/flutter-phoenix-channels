import 'dart:async';
import 'dart:io';

import 'encoding/encoding.dart';

typedef DataCallback<T> = void Function({
  String event,
  T payload,
});

class PhoenixChannelSubscription {
  const PhoenixChannelSubscription._({
    int key,
    PhoenixSocket socket,
    String topic,
  })  : _key = key,
        _topic = topic,
        _socket = socket;

  final int _key;
  final PhoenixSocket _socket;
  final String _topic;

  void cancel() {
    _socket._removeSubscription(_topic, _key);
  }
}

class PhoenixSocket<T> {
  PhoenixSocket._({
    this.encoding,
    this.ws,
  });

  final WebSocket ws;
  final PhoenixSocketEncoding<T> encoding;

  final Map<String, Map<int, DataCallback<T>>> _callbacks = {};
  Timer _heartbeatTimer;
  int _nextKey = 0;

  static Future<PhoenixSocket<T>> connect<T>({
    Uri url,
    String address,
    String channel,
    Map<String, String> parameters,
    PhoenixSocketEncoding<T> encoding,
    Function onError,
  }) async {
    final webSocketUrl = url ?? Uri(
      host: address,
      path: '/$channel/websocket',
      queryParameters: parameters,
    );

    return PhoenixSocket<T>._(
      encoding: encoding,
      ws: await WebSocket.connect(webSocketUrl.toString()),
    )
      .._attachListeners(onError: onError)
      .._startHeartbeats();
  }

  void close() {
    _heartbeatTimer.cancel();

    ws.close();
  }

  PhoenixChannelSubscription join({DataCallback<T> onData, String topic}) {
    final key = _nextKey++;

    _callbacks.putIfAbsent(topic, () => {});

    if (_callbacks[topic].isEmpty) {
      send(event: 'phx_join', topic: topic);
    }

    _callbacks[topic][key] = onData;

    return PhoenixChannelSubscription._(
      key: key,
      socket: this,
      topic: topic,
    );
  }

  void send({String event, T payload, String ref, String topic}) {
    ws.add(encoding.encode(PhoenixMessage<T>(
      event: event,
      payload: payload,
      ref: ref,
      topic: topic,
    )));
  }

  void _attachListeners({Function onError}) {
    ws.listen(
      (dynamic buffer) => _onMessage(encoding.decode(buffer as List<int>)),
      onError: onError,
      onDone: close,
    );
  }

  void _onMessage(PhoenixMessage<T> message) {
    // Clone the list to allow handlers to cancel subscriptions
    final entries = _callbacks[message.topic]?.entries?.toList() ?? [];

    for (final entry in entries) {
      entry.value(event: message.event, payload: message.payload);
    }
  }

  void _removeSubscription(String topic, int key) {
    _callbacks[topic].remove(key);

    if (_callbacks[topic].isEmpty) {
      send(event: 'phx_leave', topic: topic);
    }
  }

  void _startHeartbeats() {
    _heartbeatTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _sendHeartbeat());
  }

  void _sendHeartbeat() => send(
        event: 'heartbeat',
        topic: 'phoenix',
      );
}
