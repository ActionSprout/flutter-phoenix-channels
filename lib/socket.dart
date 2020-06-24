import 'dart:async';
import 'dart:io';

import 'channel.dart';
import 'encoding/encoding.dart';

class PhoenixSocket<T> {
  PhoenixSocket._({
    this.encoding,
    this.ws,
  });

  final WebSocket ws;
  final PhoenixSocketEncoding<T> encoding;

  Timer _heartbeatTimer;

  static Future<PhoenixSocket<T>> connect<T>({
    String address,
    PhoenixSocketEncoding<T> encoding,
  }) async =>
      PhoenixSocket<T>._(
        encoding: encoding,
        ws: await WebSocket.connect('$address/websocket'),
      )
        .._attachListeners()
        .._startHeartbeats();

  void close() {
    _heartbeatTimer.cancel();

    ws.close();
  }

  PhoenixChannel<T> join({String topic}) =>
      PhoenixChannel<T>(socket: this, topic: topic);

  void send({String event, T payload, String ref, String topic}) {
    ws.add(encoding.encode(PhoenixMessage<T>(
      event: event,
      payload: payload,
      ref: ref,
      topic: topic,
    )));
  }

  void _attachListeners() {
    ws.listen(
      (dynamic buffer) => _onMessage(encoding.decode(buffer as List<int>)),
      onError: _onError,
      onDone: close,
    );
  }

  void _onError(dynamic error) => print('Error: $error');
  void _onMessage(PhoenixMessage message) => print('Data: $message');

  void _startHeartbeats() {
    _heartbeatTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _sendHeartbeat());
  }

  void _sendHeartbeat() => send(
        event: 'heartbeat',
        topic: 'phoenix',
      );
}
