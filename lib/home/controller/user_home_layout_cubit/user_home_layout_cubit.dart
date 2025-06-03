import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_home_layout_state.dart';

class UserHomeLayoutCubit extends Cubit<UserHomeLayoutState> {
  UserHomeLayoutCubit() : super(UserHomeLayoutInitial());

  static UserHomeLayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  PageController pageController = PageController();

  void changePage(int index) {
    pageController.jumpToPage(index);
    changeIndex(index);
  }

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }
}
