import 'package:drift/drift.dart';

/// 计划表定义
/// 
/// 存储用户的计划任务，包括标题、描述、时间、状态等信息
class PlansTable extends Table {
  /// 计划ID（主键）
  IntColumn get id => integer().autoIncrement()();
  
  /// 计划标题
  TextColumn get title => text().withLength(min: 1, max: 200)();
  
  /// 计划描述
  TextColumn get description => text().nullable()();
  
  /// 计划类型（study:学习，work:工作，life:生活，other:其他）
  TextColumn get type => text().withDefault(const Constant('study'))();
  
  /// 优先级（1:低，2:中，3:高）
  IntColumn get priority => integer().withDefault(const Constant(2))();
  
  /// 计划状态（pending:待处理，in_progress:进行中，completed:已完成，cancelled:已取消）
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  /// 计划日期
  DateTimeColumn get planDate => dateTime()();
  
  /// 开始时间
  DateTimeColumn get startTime => dateTime().nullable()();
  
  /// 结束时间
  DateTimeColumn get endTime => dateTime().nullable()();
  
  /// 提醒时间
  DateTimeColumn get reminderTime => dateTime().nullable()();
  
  /// 标签（用逗号分隔）
  TextColumn get tags => text().nullable()();
  
  /// 关联的课程ID（如果与课程相关）
  IntColumn get courseId => integer().nullable()();
  
  /// 完成进度（0-100）
  IntColumn get progress => integer().withDefault(const Constant(0))();
  
  /// 备注
  TextColumn get notes => text().nullable()();
  
  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 完成时间
  DateTimeColumn get completedAt => dateTime().nullable()();
}