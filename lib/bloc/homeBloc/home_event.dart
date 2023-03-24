abstract class HomeEvent{}
class HomeGetAllEvent extends HomeEvent{}
class HomeGetOfCategoryEvent extends HomeEvent{
  final String category;
  HomeGetOfCategoryEvent({required this.category});
}