import '../proto/socket_message.pb.dart';
import 'encoding.dart';

class PhoenixProtobufEncoding extends PhoenixSocketEncoding<List<int>> {
  const PhoenixProtobufEncoding();

  @override
  PhoenixMessage<List<int>> decode(List<int> buffer) {
    final message = PhoenixSocketMessage.fromBuffer(buffer);

    return PhoenixMessage(
      event: message.event,
      payload: message.payload,
      ref: message.ref,
      topic: message.topic,
    );
  }

  @override
  List<int> encode(PhoenixMessage<List<int>> message) {
    final protobuf = PhoenixSocketMessage.create()
      ..event = message.event
      ..topic = message.topic;

    if (message.payload != null) {
      protobuf.payload = message.payload;
    }

    if (message.ref != null) {
      protobuf.ref = message.ref;
    }

    return protobuf.writeToBuffer();
  }
}
