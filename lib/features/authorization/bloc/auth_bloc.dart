import 'package:equatable/equatable.dart';
import '../data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {

    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signIn(
          email: event.email, password: event.password
        );
        emit(Authenticated());
      } catch (e){
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async{
      emit(Loading());
      try {
        await authRepository.signUp(
            email: event.email, password: event.password
        );
        emit(Authenticated());
      } catch (e){
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<GoogleSignInRequested>((event, emit) async{
      emit(Loading());
      try {
         await authRepository.signInWithGoogle();
         emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async{
      emit(Loading());
      await authRepository.signOut();
      emit(UnAuthenticated());
    });


  }
}
