import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'owner_home_layout_state.dart';

class OwnerHomeLayoutCubit extends Cubit<OwnerHomeLayoutState> {
  OwnerHomeLayoutCubit() : super(OwnerHomeLayoutInitial());

  static OwnerHomeLayoutCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  PageController pageController = PageController();

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void changePage(int index) {
    pageController.jumpToPage(index);
    changeIndex(index);
  }
}
