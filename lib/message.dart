class PhoenixMessage {
  const PhoenixMessage({this.event, this.payload, this.ref, this.topic});

  final String event;
  final dynamic payload;
  final String ref;
  final String topic;
}
