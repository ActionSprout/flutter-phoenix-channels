import 'dart:async';
import 'dart:io';

Function(dynamic) makeLogger(String label) => (dynamic event) {
      print('$label: $event');
    };

class PhoenixSocket {
  PhoenixSocket._({this.ws});

  WebSocket ws;

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

  void _sendHeartbeat() => send(
        event: 'heartbeat',
        topic: 'phoenix',
      );

  void send({String event, String payload, String ref, String topic}) {
    ws.add(
      '''{"topic": "$topic", "event": "$event", "payload": ${payload ?? '{}'}, "ref": $ref}''',
    );
  }

  void sendJoin({String topic}) => send(
        event: 'phx_join',
        topic: topic,
      );
}
