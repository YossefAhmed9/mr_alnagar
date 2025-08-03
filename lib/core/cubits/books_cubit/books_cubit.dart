import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/models/book_model.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/network/remote/api_endPoints.dart';
import 'package:mr_alnagar/core/network/remote/dio_helper.dart';

import 'books_state.dart';


class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(BooksInitial());
  static BooksCubit get(context) => BlocProvider.of(context);

bool isBookLoading=false;
void changeIsBookLoading(){
  isBookLoading=!isBookLoading;
  emit(IsBookLoadingChanged());

}

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


  Future<void> orderOfBook({
    required int id,
    required String paymentMethod,
    required String address,
    required int quantity
  }) async {
    emit(GetAllBooksLoading());

    final String? token = CacheHelper.getData(key: CacheKeys.token);
    final String? fullName = CacheHelper.getData(key: CacheKeys.fullName);
    final String? email = CacheHelper.getData(key: CacheKeys.email);
    final String? phone = CacheHelper.getData(key: CacheKeys.phone);

    print("id: $id");
    print("paymentMethod: $paymentMethod");
    print("Name: $fullName");
    print("Email: $email");
    print("Phone: $phone");

    try {
      final response = await DioHelper.postData(
        url: EndPoints.orderBooks,
        token: token,
        data: {
          "book_id": id,
          "payment_type": paymentMethod,
          "name": fullName,
          "email": email,
          "phone": phone,
          "address": address,
          "quantity": quantity,
        },
      );

      print(response.data);
      print(books);
      emit(GetAllBooksDone());

    } on DioException catch (dioError) {
      // Handle Dio-specific errors
      if (kDebugMode) {
        print(' message  message  message  message ');
      }
      if (kDebugMode) {
        print(dioError.response?.data);
      }
      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        emit(GetAllBooksError("Connection timed out. Please try again."));
      } else if (dioError.type == DioExceptionType.badResponse) {
        final statusCode = dioError.response?.statusCode;
        final message = dioError.response?.data['message'] ?? 'Unknown error';
        emit(GetAllBooksError(
            "Request failed [${statusCode ?? ''}]: $message"));
      } else if (dioError.type == DioExceptionType.unknown &&
          dioError.error is SocketException) {
        emit(GetAllBooksError("No Internet connection."));
      } else {
        emit(GetAllBooksError("Something went wrong: ${dioError.message}"));
      }

      print("DioError: ${dioError.message}");
      print("DioError type: ${dioError.type}");
      print("DioError data: ${dioError.response?.data}");

    } catch (error) {
      // Handle any other errors
      emit(GetAllBooksError("Unexpected error: ${error.toString()}"));
      print("General Error: $error");
    }
  }

var book;
  Future<Response?> getBookByID({required int id,})async{
    emit(GetAllBooksLoading());
    await DioHelper.getData(url: "${EndPoints.getAllBooks}/$id",
    token: CacheHelper.getData(key: CacheKeys.token)
    ).then((value){

      //books.addAll(value.data['data']);
      print(value.data['data']);
      book=value.data['data'];
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
