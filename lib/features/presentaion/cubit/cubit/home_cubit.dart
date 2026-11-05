import 'dart:async';

import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:app3/features/welcome/presentaion/home/home-repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Timer? _debounce;

  Future<void> getBestSellerBox() async {
    emit(GetBestSellerLoading());
    final response = await HomeRepo().getBestSellerBox();

    if (isClosed) return;

    if (response is BookModel) {
      emit(GetBestSellerSuccess(response.data?.products));
    } else {
      emit(GetBestSellerError());
    }
  }


  void searchWithDelay(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(text);
    });
  }

  Future<void> search(String text) async {

    if (text.trim().isEmpty) {
      emit(HomeInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final data = await HomeRepo.search(text);


      if (isClosed) return;

      if (data != null) {
        emit(SearchSuccess(data));
      } else {
        emit(SearchError());
      }
    } catch (e) {
      print('SEARCH ERROR: $e');
      if (isClosed) return;
      emit(SearchError());
    }

  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
  addToCart(int productId)async{
    emit(AddToCartLoading());
    final response = await HomeRepo.addToCart(productId);
    if(response){
      emit(AddToCartSuccess());

    }else{
      emit(AddToCartError());
    }

  }
}