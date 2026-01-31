import 'package:dartz/dartz.dart';
import '../../core/config/role_config.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Mock Data
  static const _mockUsers = {
    'student123': UserEntity(
      id: 'student123',
      name: 'John Doe',
      email: 'john.doe@student.svce.edu.in',
      role: UserRole.student,
    ),
    'faculty123': UserEntity(
      id: 'faculty123',
      name: 'Dr. Smith',
      email: 'smith@svce.edu.in',
      role: UserRole.faculty,
    ),
    'admin123': UserEntity(
      id: 'admin123',
      name: 'Admin User',
      email: 'admin@svce.edu.in',
      role: UserRole.admin,
    ),
    'gnana123': UserEntity(
      id: '24BFA33L12',
      name: 'Gnana Sekhar',
      email: 'gnanasekhar@student.svce.edu.in',
      role: UserRole.student,
    ),
    'vignesh123': UserEntity(
      id: '24BFA33L04',
      name: 'Vignesh',
      email: 'vigneshkumar@student.svce.edu.in',
      role: UserRole.student,
    ),
  };

  UserEntity? _currentUser;
  final SharedPreferences _prefs;
  static const String _userKey = 'auth_user_id';
  static const String _roleKey = 'auth_user_role';

  AuthRepositoryImpl(this._prefs);

  @override
  Future<Either<Exception, UserEntity>> login({
    required String collegeId,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate latency

    if (password != 'password') {
      return Left(Exception('Invalid password'));
    }

    final user = _mockUsers[collegeId];
    if (user == null) {
      return Left(Exception('User not found'));
    }

    if (user.role != role) {
      return Left(Exception('Role mismatch for this user'));
    }

    _currentUser = user;
    await _prefs.setString(_userKey, user.id);
    await _prefs.setString(_roleKey, user.role.name);

    return Right(user);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    await _prefs.remove(_userKey);
    await _prefs.remove(_roleKey);
  }

  @override
  Future<Either<Exception, UserEntity?>> getCurrentUser() async {
    if (_currentUser != null) return Right(_currentUser);

    final userId = _prefs.getString(_userKey);
    final roleName = _prefs.getString(_roleKey);

    if (userId != null && roleName != null) {
      // Find user in mock data (since we only have mock data)
      // In real app we might fetch from API or store full user object
      try {
        final user = _mockUsers.values.firstWhere((u) => u.id == userId);
        _currentUser = user;
        return Right(user);
      } catch (e) {
        // User not found in mock data (maybe data changed)
        return Right(null);
      }
    }
    return Right(null);
  }
}
