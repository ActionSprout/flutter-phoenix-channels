///
//  Generated code. Do not modify.
//  source: socket_message.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/any.pb.dart' as $0;

class PhoenixSocketMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PhoenixSocketMessage', createEmptyInstance: create)
    ..aOS(1, 'event')
    ..aOS(2, 'topic')
    ..aOM<$0.Any>(3, 'payload', subBuilder: $0.Any.create)
    ..aOS(4, 'joinRef')
    ..aOS(5, 'ref')
    ..hasRequiredFields = false
  ;

  PhoenixSocketMessage._() : super();
  factory PhoenixSocketMessage() => create();
  factory PhoenixSocketMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PhoenixSocketMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PhoenixSocketMessage clone() => PhoenixSocketMessage()..mergeFromMessage(this);
  PhoenixSocketMessage copyWith(void Function(PhoenixSocketMessage) updates) => super.copyWith((message) => updates(message as PhoenixSocketMessage));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PhoenixSocketMessage create() => PhoenixSocketMessage._();
  PhoenixSocketMessage createEmptyInstance() => create();
  static $pb.PbList<PhoenixSocketMessage> createRepeated() => $pb.PbList<PhoenixSocketMessage>();
  @$core.pragma('dart2js:noInline')
  static PhoenixSocketMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PhoenixSocketMessage>(create);
  static PhoenixSocketMessage _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get event => $_getSZ(0);
  @$pb.TagNumber(1)
  set event($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvent() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get topic => $_getSZ(1);
  @$pb.TagNumber(2)
  set topic($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopic() => clearField(2);

  @$pb.TagNumber(3)
  $0.Any get payload => $_getN(2);
  @$pb.TagNumber(3)
  set payload($0.Any v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPayload() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayload() => clearField(3);
  @$pb.TagNumber(3)
  $0.Any ensurePayload() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get joinRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set joinRef($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasJoinRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinRef() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get ref => $_getSZ(4);
  @$pb.TagNumber(5)
  set ref($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearRef() => clearField(5);
}

