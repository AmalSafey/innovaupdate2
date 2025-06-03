



abstract class AuthStates{


}

class AuthIntialState extends AuthStates{}

class RegisterLoadingState  extends AuthStates{}


class RegisterSuccessState  extends AuthStates{
  final String messagesuccess;
  RegisterSuccessState({required this.messagesuccess});
} 

class RegisterErrorStata  extends AuthStates{
 String message;

 RegisterErrorStata({required this.message});             
  
} 



 class LoginLoadingState extends AuthStates{} 
 class LoginSuccessState extends AuthStates{
  final String message;
  final String token; //
  final String userId;
  final String roleName;
  //final UserModel userModel;
  
   LoginSuccessState({
    required this.message, 
    required this.token,
    required this.userId,
    required this.roleName});
 } 

 class LoginErrorState extends AuthStates{
  String message;

 LoginErrorState({required this.message});             
  
 } 
