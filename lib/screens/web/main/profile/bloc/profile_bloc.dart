import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadUserData>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
      LoadUserData event, Emitter<ProfileState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final data =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final followers = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('followers')
          .get();
      final subscriptions = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('subscriptions')
          .get();

      emit(state.copyWith(
        userName: data['user_name'],
        userAvatarLink: data['avatar_link'],
        name: data['name'] != '' ? data['name'] : data['user_name'],
        uid: data['uid'],
        countFollowers: followers.size,
        countSubs: subscriptions.size,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        isLoading: false,
      ));
    }
  }
}
