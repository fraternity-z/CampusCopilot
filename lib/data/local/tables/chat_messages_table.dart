import 'package:drift/drift.dart';

/// 聊天消息表
///
/// 存储聊天会话中的所有消息
@DataClassName('ChatMessagesTableData')
class ChatMessagesTable extends Table {
  /// 消息唯一标识符
  TextColumn get id => text()();

  /// 消息内容
  TextColumn get content => text()();

  /// 是否来自用户（false表示来自AI）
  BoolColumn get isFromUser => boolean()();

  /// 消息创建时间
  DateTimeColumn get timestamp => dateTime()();

  /// 关联的聊天会话ID
  TextColumn get chatSessionId => text()();

  /// 消息类型 (text, image, file, system, error)
  TextColumn get type => text().withDefault(const Constant('text'))();

  /// 消息状态 (sending, sent, failed, read)
  TextColumn get status => text().withDefault(const Constant('sent'))();

  /// 消息元数据（JSON格式）
  TextColumn get metadata => text().nullable()();

  /// 父消息ID（用于回复功能）
  TextColumn get parentMessageId => text().nullable()();

  /// 消息使用的token数量
  IntColumn get tokenCount => integer().nullable()();

  /// 思考链内容（AI思考过程）
  TextColumn get thinkingContent => text().nullable()();

  /// 思考链是否完整
  BoolColumn get thinkingComplete =>
      boolean().withDefault(const Constant(false))();

  /// 使用的模型名称（用于特殊处理）
  TextColumn get modelName => text().nullable()();

  /// 图片URL列表（JSON格式存储）
  TextColumn get imageUrls => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}
