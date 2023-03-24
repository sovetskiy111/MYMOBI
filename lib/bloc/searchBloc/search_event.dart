abstract class SearchEvent{}
class SearchGetEvent extends SearchEvent{
  final List<String> searchList;
  SearchGetEvent({required this.searchList});
}