import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/guest/guest_home_screen.dart';
import '../screens/guest/guest_item_detail_screen.dart';
import '../screens/student/student_shell.dart';
import '../screens/student/item_detail_screen.dart';
import '../screens/student/report_lost_screen.dart';
import '../screens/student/report_found_screen.dart';
import '../screens/student/report_detail_screen.dart';
import '../screens/student/chat_screen.dart';
import '../screens/admin/admin_shell.dart';
import '../screens/admin/admin_report_detail_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const guestHome = '/guest';
  static const guestItemDetail = '/guest/item/:id';
  static const studentHome = '/student';
  static const studentItemDetail = '/student/item/:id';
  static const reportLost = '/student/report-lost';
  static const reportFound = '/student/report-found';
  static const reportDetail = '/student/report/:id';
  static const chat = '/student/chat/:reportId';
  static const adminHome = '/admin';
  static const adminReportDetail = '/admin/report/:id';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterScreen()),
    GoRoute(path: AppRoutes.forgotPassword, builder: (_, _) => const ForgotPasswordScreen()),
    GoRoute(path: AppRoutes.guestHome, builder: (_, _) => const GuestHomeScreen()),
    GoRoute(
      path: '/guest/item/:id',
      builder: (_, state) => GuestItemDetailScreen(reportId: state.pathParameters['id']!),
    ),
    GoRoute(path: AppRoutes.studentHome, builder: (_, _) => const StudentShell()),
    GoRoute(
      path: '/student/item/:id',
      builder: (_, state) => ItemDetailScreen(reportId: state.pathParameters['id']!),
    ),
    GoRoute(path: AppRoutes.reportLost, builder: (_, _) => const ReportLostScreen()),
    GoRoute(path: AppRoutes.reportFound, builder: (_, _) => const ReportFoundScreen()),
    GoRoute(
      path: '/student/report/:id',
      builder: (_, state) => ReportDetailScreen(reportId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/student/chat/:reportId',
      builder: (_, state) => ChatScreen(reportId: state.pathParameters['reportId']!),
    ),
    GoRoute(path: AppRoutes.adminHome, builder: (_, _) => const AdminShell()),
    GoRoute(
      path: '/admin/report/:id',
      builder: (_, state) => AdminReportDetailScreen(reportId: state.pathParameters['id']!),
    ),
  ],
);
