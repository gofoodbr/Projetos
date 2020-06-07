import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_food_br/src/services/register-service.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends BlocBase{

  final _loadController = BehaviorSubject<int>.seeded(0);
  Function(int) get loadIn => _loadController.sink.add;
  Stream<int> get loadOut => _loadController.stream;
  
  Future<int> registerUser({
    FirebaseUser firebaseUser,
    String cpf,
    String phone,
    String sexo,
    String code
  })async{
    loadIn(1);

    if(phone.length != 13){
      return 2;
    }

    bool register = await registerUserService(
      firebaseUser: firebaseUser,
      cpf: cpf,
      phone: phone,
      sexo: sexo,
      code: code
    );
    if(register){
      return 5;
    }else{
      return 6;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _loadController.close();
  }
}