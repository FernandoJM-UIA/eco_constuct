abstract class Either<L, R> {
  const Either();

  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight);

  bool get isLeft => fold((_) => true, (_) => false);
  bool get isRight => fold((_) => false, (_) => true);
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifLeft(value);

  @override
  bool operator ==(Object other) => other is Left && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifRight(value);

  @override
  bool operator ==(Object other) => other is Right && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
