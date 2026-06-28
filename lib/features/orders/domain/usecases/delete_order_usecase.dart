import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/order_repository.dart';

class DeleteOrderUseCase implements UseCase<void, String> {
  final OrderRepository repository;

  DeleteOrderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteOrder(id);
  }
}
