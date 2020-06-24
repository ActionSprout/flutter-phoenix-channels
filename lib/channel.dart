import 'socket.dart';

class PhoenixChannel<T> {
  PhoenixChannel({this.socket, this.topic}) {
    socket.send(
      event: 'phx_join',
      topic: topic,
    );
  }

  final PhoenixSocket socket;
  final String topic;

  void leave() => socket.send(
        event: 'phx_leave',
        topic: topic,
      );

  void send({String event, T payload}) => socket.send(
        event: event,
        payload: payload,
        topic: topic,
      );
}
