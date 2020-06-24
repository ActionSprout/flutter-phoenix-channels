import 'dart:async';
import 'dart:io';

import 'encoding/json.dart';

import 'message.dart';

Function(dynamic) makeLogger(String label) => (dynamic event) {
      print('$label: $event');
    };

abstract class PhoenixSocketEncoding {
  const PhoenixSocketEncoding();

  String encode(PhoenixMessage message);
  PhoenixMessage decode(String buffer);
}

class PhoenixSocket {
  PhoenixSocket._({
    this.encoding = const PhoenixJsonEncoding(),
    this.ws,
  });

  final WebSocket ws;
  final PhoenixSocketEncoding encoding;

  static Future<PhoenixSocket> connect(String address) async {
    final socket = PhoenixSocket._(
      ws: await WebSocket.connect('$address/websocket'),
    );

    try {
      socket.ws.listen(
        makeLogger('Data'),
        onError: makeLogger('Error'),
        onDone: () => print('Done.'),
      );
    } on Object catch (e) {
      print('Exception: $e');
    }

    socket._startHeartbeats();

    return socket;
  }

  void _startHeartbeats() {
    Timer.periodic(const Duration(seconds: 30), (_) => _sendHeartbeat());
  }

  void _sendHeartbeat() => send<void>(
        event: 'heartbeat',
        topic: 'phoenix',
      );

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
