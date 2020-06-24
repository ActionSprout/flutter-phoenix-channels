class PhoenixMessage<T> {
  const PhoenixMessage({this.event, this.payload, this.ref, this.topic});

  final String event;
  final T payload;
  final String ref;
  final String topic;
}
