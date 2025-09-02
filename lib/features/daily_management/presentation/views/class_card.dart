// 从traintime_pda复制的课程卡片组件
import 'package:flutter/material.dart';
import 'class_organized_data.dart';

class ClassCard extends StatelessWidget {
  final ClassOrgainzedData detail;

  const ClassCard({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据容器大小动态调整字体大小
        double titleFontSize = constraints.maxHeight > 80 ? 14 : 
                              constraints.maxHeight > 60 ? 12 : 
                              constraints.maxHeight > 40 ? 11 : 10;
        double placeFontSize = titleFontSize - 2;
        double padding = constraints.maxHeight > 60 ? 8 : 
                        constraints.maxHeight > 40 ? 6 : 4;
        
        return Container(
          margin: const EdgeInsets.all(1), // 减小外边距以充分利用空间
          padding: EdgeInsets.all(padding), // 动态内边距
          decoration: BoxDecoration(
            color: detail.color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
            crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
            children: [
              Flexible(
                flex: 3, // 给课程名称更多空间
                child: Text(
                  detail.name,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: constraints.maxHeight > 80 ? 4 : 
                           constraints.maxHeight > 60 ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (detail.place != null && detail.place!.isNotEmpty && constraints.maxHeight > 40) ...[
                const SizedBox(height: 2),
                Flexible(
                  flex: 1, // 给教室信息较少空间
                  child: Text(
                    detail.place!,
                    style: TextStyle(
                      fontSize: placeFontSize,
                      color: Colors.white70,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}