enum FavoriteErrorType {
  load('Unable to load favorite countries!'),
  add('Unable to add to favorites!'),
  remove('Unable to remove from favorites!'),
  note('Unable to save note!');

  const FavoriteErrorType(this.errorMessage);

  final String errorMessage;
}
