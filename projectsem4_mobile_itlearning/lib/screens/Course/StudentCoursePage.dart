import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/StudentCourseProvider.dart';

class StudentCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<StudentCourseProvider>(context).fetchStudentCourses(), // Gọi phương thức fetchStudentCourses() để lấy dữ liệu
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Trạng thái đang kết nối, hiển thị một tiêu đề hoặc tiện ích đợi
            return Center(
              child: CircularProgressIndicator(), // Ví dụ: Hiển thị tiến trình chờ
            );
          } else if (snapshot.hasError) {
            // Có lỗi xảy ra, hiển thị thông báo lỗi
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          } else {
            // Dữ liệu đã sẵn sàng, kiểm tra nếu có dữ liệu hoặc không
            final studentCourses = snapshot.data;

            if (studentCourses!.isEmpty) {
              // Hiển thị thông báo khi không có dữ liệu
              return Center(
                child: Text('Không có khóa học nào.'),
              );
            } else {
              // Hiển thị danh sách khóa học
              return ListView.builder(
                itemCount: studentCourses.length,
                itemBuilder: (context, index) {
                  final course = studentCourses[index];
                  return ListTile(
                    title: Text(course.course.title),
                    subtitle: Text(course.course.status),
                    // Hiển thị thông tin khác về khóa học ở đây
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
