part of 'user_home_layout_cubit.dart';

@immutable
sealed class UserHomeLayoutState {}

final class UserHomeLayoutInitial extends UserHomeLayoutState {}
final class ChangeBottomNavState extends UserHomeLayoutState {}
