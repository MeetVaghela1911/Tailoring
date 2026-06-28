import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

class AddCustomerUseCase implements UseCase<Customer, Customer> {
  final CustomerRepository repository;

  AddCustomerUseCase(this.repository);

  @override
  Future<Either<Failure, Customer>> call(Customer customer) async {
    return await repository.addCustomer(customer);
  }
}
