import 'socket.dart';

class PhoenixChannel {
  PhoenixChannel({this.socket, this.topic}) {
    socket.sendJoin(topic: topic);
  }

  final PhoenixSocket socket;
  final String topic;
}
