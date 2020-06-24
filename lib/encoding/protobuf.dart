import '../message.dart';
import '../proto/google/protobuf/any.pb.dart';
import '../proto/socket_message.pb.dart';
import '../socket.dart';

class PhoenixProtobufEncoding extends PhoenixSocketEncoding {
  const PhoenixProtobufEncoding();

  @override
  PhoenixMessage decode(List<int> buffer) {
    final message = PhoenixSocketMessage.fromBuffer(buffer);

    return PhoenixMessage<dynamic>(
      event: message.event,
      payload: message.payload.value,
      ref: message.ref,
      topic: message.topic,
    );
  }

  @override
  List<int> encode(PhoenixMessage message) {
    final protobuf = PhoenixSocketMessage.create()
      ..event = message.event
      ..payload = Any()
      ..topic = message.topic;

    if (message.ref != null) {
      protobuf.ref = message.ref;
    }

    if (message.payload != null) {
      protobuf.payload.typeUrl = message.payload.runtimeType.toString();
      // TODO(schoon): Replace with type parameter.
      protobuf.payload.value = message.payload as List<int>;
    }

    return protobuf.writeToBuffer();
  }
}
