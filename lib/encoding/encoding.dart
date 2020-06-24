abstract class PhoenixSocketEncoding<T> {
  const PhoenixSocketEncoding();

  List<int> encode(PhoenixMessage<T> message);
  PhoenixMessage<T> decode(List<int> buffer);
}

class PhoenixMessage<T> {
  const PhoenixMessage({this.event, this.payload, this.ref, this.topic});

  final String event;
  final T payload;
  final String ref;
  final String topic;

  @override
  String toString() =>
      '<PhoenixMessage event=$event payload=$payload ref=$ref topic=$topic>';
}
