import 'package:phoenix_channels/phoenix_channels.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    throw Exception('An address is required.');
  }

  final address = args.first;
  final socket = await PhoenixSocket.connect(
    address: address,
    encoding: const PhoenixProtobufEncoding(),
    onError: (dynamic error) => print('Error: $error'),
  );

  socket.join(
    onData: ({String event, List<int> payload}) =>
        print('Data: $event, $payload'),
    topic: 'room:lobby',
  );
}
