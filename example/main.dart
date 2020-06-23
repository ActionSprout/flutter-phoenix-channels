import 'package:phoenix_channels/phoenix_channels.dart';

main(List<String> args) async {
  if (args.length < 1) {
    throw new Exception("An address is required.");
  }

  final address = args.first;
  final socket = await PhoenixSocket.connect(address);

  socket.sendJoin(topic: 'room:lobby');
}
