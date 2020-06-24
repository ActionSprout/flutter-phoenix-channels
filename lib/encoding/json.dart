import 'dart:convert';

import '../message.dart';
import '../socket.dart';

class PhoenixJsonEncoding extends PhoenixSocketEncoding {
  const PhoenixJsonEncoding();

  @override
  PhoenixMessage decode(List<int> buffer) {
    final parts = json.decode(utf8.decode(buffer)) as Map<String, dynamic>;

    return PhoenixMessage<Map<String, dynamic>>(
      event: parts['event'] as String,
      payload: parts['payload'] as Map<String, dynamic>,
      ref: parts['ref'] as String,
      topic: parts['topic'] as String,
    );
  }

  @override
  List<int> encode(PhoenixMessage message) {
    return utf8.encode(json.encode(<String, dynamic>{
      'event': message.event,
      'payload': message.payload,
      'ref': message.ref,
      'topic': message.topic,
    }));
  }
}
