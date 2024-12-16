import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class SaveEmailUseCase implements UseCase<String, String> {
  final SimpleStorageDatasource _datasource;

  SaveEmailUseCase(this._datasource);

  @override
  Future<String> call(String email) async {
    await _datasource.saveEmail(email);
    return email;
  }
}
