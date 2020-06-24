import '../proto/google/protobuf/any.pb.dart';
import '../proto/socket_message.pb.dart';
import 'encoding.dart';

export '../proto/google/protobuf/any.pb.dart';

class PhoenixProtobufEncoding extends PhoenixSocketEncoding<Any> {
  const PhoenixProtobufEncoding();

  @override
  PhoenixMessage<Any> decode(List<int> buffer) {
    final message = PhoenixSocketMessage.fromBuffer(buffer);

    return PhoenixMessage(
      event: message.event,
      payload: message.payload,
      ref: message.ref,
      topic: message.topic,
    );
  }

  @override
  List<int> encode(PhoenixMessage<Any> message) {
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
