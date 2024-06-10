import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String userName;
  final String userAvatarLink;
  final String uid;
  final int countFollowers;
  final int countSubs;
  final bool isLoading;
  final bool hasError;

  const ProfileState({
    this.name = '',
    this.userName = '',
    this.userAvatarLink = '',
    this.uid = '',
    this.countFollowers = 0,
    this.countSubs = 0,
    this.isLoading = true,
    this.hasError = false,
  });

  ProfileState copyWith({
    String? name,
    String? userName,
    String? userAvatarLink,
    String? uid,
    int? countFollowers,
    int? countSubs,
    bool? isLoading,
    bool? hasError,
  }) {
    return ProfileState(
      name: name ?? this.name,
      userName: userName ?? this.userName,
      userAvatarLink: userAvatarLink ?? this.userAvatarLink,
      uid: uid ?? this.uid,
      countFollowers: countFollowers ?? this.countFollowers,
      countSubs: countSubs ?? this.countSubs,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  @override
  List<Object> get props => [
    name,
    userName,
    userAvatarLink,
    uid,
    countFollowers,
    countSubs,
    isLoading,
    hasError,
  ];
}
