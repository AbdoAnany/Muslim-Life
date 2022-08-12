abstract class AzkarState  {

}

class AzkarInitial extends AzkarState {}

class AzkarLoading extends AzkarState {}

class AzkarSuccess extends AzkarState {}
class AzkarSearchSuccess extends AzkarState {}

class AzkarFailure extends AzkarState {
   final String error;
  AzkarFailure(this.error);
}

class AzkarSearchLoading extends AzkarState {}

class ScrollAzkar extends AzkarState {}
abstract class BaseStates {}
