import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/models/book_model.dart';
import 'package:mr_alnagar/core/network/remote/api_endPoints.dart';
import 'package:mr_alnagar/core/network/remote/dio_helper.dart';

import 'books_state.dart';


class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(BooksInitial());
  static BooksCubit get(context) => BlocProvider.of(context);


  List books=[];
  Future<void> getAllBooks()async{
    emit(GetAllBooksLoading());
    await DioHelper.getData(url: EndPoints.getAllBooks).then((value){

      books=[];
      books.addAll(value.data['data']);
      print(books);
      emit(GetAllBooksDone());
      //print(value.data);
    }).catchError((error){
      print(error);
      print(error.toString());
      print(error.runtimeType);
      emit(GetAllBooksError(error));
    });
  }


  Future<void> orderOfBook()async{
    emit(GetAllBooksLoading());
    await DioHelper.getData(url: EndPoints.orderBooks).then((value){


      print(books);
      emit(GetAllBooksDone());
      //print(value.data);
    }).catchError((error){
      print(error);
      print(error.toString());
      print(error.runtimeType);
      emit(GetAllBooksError(error));
    });
  }


  Future<Response?> getBookByID({required int id})async{
    emit(GetAllBooksLoading());
    await DioHelper.getData(url: "${EndPoints.getAllBooks}/$id").then((value){

      //books.addAll(value.data['data']);
      print(value.data['data']);
      emit(GetAllBooksDone());
      return value.data['data'];
      //print(value.data);
    }).catchError((error){
      print(error);
      print(error.toString());
      print(error.runtimeType);
      emit(GetAllBooksError(error));
    });
    return null;
  }






}
