import 'dart:async';
import 'dart:io';

import 'channel.dart';
import 'encoding/json.dart';

import 'message.dart';

Function(dynamic) makeLogger(String label) => (dynamic event) {
      print('$label: $event');
    };

abstract class PhoenixSocketEncoding {
  const PhoenixSocketEncoding();

  List<int> encode(PhoenixMessage message);
  PhoenixMessage decode(List<int> buffer);
}

class PhoenixSocket {
  PhoenixSocket._({
    this.encoding,
    this.ws,
  });

  final WebSocket ws;
  final PhoenixSocketEncoding encoding;

  Timer _heartbeatTimer;

  static Future<PhoenixSocket> connect(
    String address, {
    PhoenixSocketEncoding encoding = const PhoenixJsonEncoding(),
  }) async {
    final socket = PhoenixSocket._(
      encoding: encoding,
      ws: await WebSocket.connect('$address/websocket'),
    );

    try {
      socket.ws.listen(
        makeLogger('Data'),
        onError: makeLogger('Error'),
        onDone: () {
          print('Done.');
          socket.close();
        },
      );
    } on Object catch (e) {
      print('Exception: $e');
    }

    socket._startHeartbeats();

    return socket;
  }

  void close() {
    _heartbeatTimer.cancel();

    ws.close();
  }

  void _startHeartbeats() {
    _heartbeatTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _sendHeartbeat());
  }

  void _sendHeartbeat() => send<void>(
        event: 'heartbeat',
        topic: 'phoenix',
      );

  PhoenixChannel join({String topic}) =>
      PhoenixChannel(socket: this, topic: topic);

  void send<T>({String event, T payload, String ref, String topic}) {
    ws.add(encoding.encode(PhoenixMessage<T>(
      event: event,
      payload: payload,
      ref: ref,
      topic: topic,
    )));
  }

  void sendJoin({String topic}) => send<void>(
        event: 'phx_join',
        topic: topic,
      );
}
