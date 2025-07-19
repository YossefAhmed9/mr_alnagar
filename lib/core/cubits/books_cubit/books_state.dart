
sealed class BooksState {}

final class BooksInitial extends BooksState {}
final class GetAllBooksLoading extends BooksState {}
final class GetAllBooksDone extends BooksState {}
final class GetAllBooksError extends BooksState {
  final error;
  GetAllBooksError(this.error);
}
