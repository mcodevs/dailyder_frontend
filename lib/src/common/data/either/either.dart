class Either<L, R> {
  const Either.left(this.leftValue) : rightValue = null;
  const Either.right(this.rightValue) : leftValue = null;

  final L? leftValue;
  final R? rightValue;

  bool get isLeft => leftValue != null;
  bool get isRight => rightValue != null;

  T fold<T>({
    required T Function(L value) onLeft,
    required T Function(R value) onRight,
  }) {
    if (leftValue != null) {
      return onLeft(leftValue as L);
    }
    return onRight(rightValue as R);
  }
}
