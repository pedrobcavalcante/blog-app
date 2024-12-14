abstract class UseCase<InputType, OutputType> {
  Future<OutputType> call(InputType input);
}
