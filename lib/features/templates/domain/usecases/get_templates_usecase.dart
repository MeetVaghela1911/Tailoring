import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/template.dart';
import '../repositories/template_repository.dart';

class GetTemplatesUseCase implements UseCase<List<Template>, NoParams> {
  final TemplateRepository repository;

  GetTemplatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Template>>> call(NoParams params) async {
    return await repository.getTemplates();
  }
}
