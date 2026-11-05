part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}
final class GetProfileLoading extends ProfileState {}
final class GetProfileSuccess extends ProfileState {
  final ProfileDataModel? profileDate;

  GetProfileSuccess(this.profileDate);

}
final class GetProfileError extends ProfileState {}
