abstract class SearchStates {}

class SearchInitial extends SearchStates {}
class LoadingSearchResults extends SearchStates {}
class UpdatingSuggestions extends SearchStates {}
class UpdatedSuggestions extends SearchStates {}
class DataLoadedSuccessState extends SearchStates {}
class ErrorLoadingDataState extends SearchStates {}
