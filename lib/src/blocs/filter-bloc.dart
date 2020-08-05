import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:rxdart/rxdart.dart';

class FilterBloc extends BlocBase{

  BehaviorSubject<Map<String, Map<String,dynamic>>> _filterController = BehaviorSubject<Map<String, Map<String,dynamic>>>.seeded({
    "filter": {},
    "ord": {
      "padrao": true
    }
  });
  Stream<Map<String, Map<String,dynamic>>> get filterStream => _filterController.stream;
  Function(Map<String, Map<String,dynamic>>) get filterInput => _filterController.sink.add;

  final _companiesController = BehaviorSubject<List<Company>>.seeded([]);
  Function(List<Company>) get companiesIn => _companiesController.sink.add;
  Stream<List<Company>> get companiesOut => _companiesController.stream;

  void addFilter({int cat, double km, int frete, String name}){
    if(cat != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      if(!filters.containsKey("filter")){
        filters["filter"] = {};
      }
      filters["filter"]["cat"] = cat;
      _filterController.sink.add(filters);
    }
    if(km != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      if(!filters.containsKey("filter")){
        filters["filter"] = {};
      }
      filters["filter"]["km"] = km;
      _filterController.sink.add(filters);
    }
    if(frete != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      if(!filters.containsKey("filter")){
        filters["filter"] = {};
      }
      filters["filter"]["frete"] = frete;
      _filterController.sink.add(filters);
    }
    if(name != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      if(!filters.containsKey("filter")){
        filters["filter"] = {};
      }
      filters["filter"]["name"] = name;
      _filterController.sink.add(filters);
    }
  }

  void addOrd({bool distancia, bool frete, bool time, bool padrao}){
    if(distancia != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      filters["ord"] = {};
      filters["ord"]["distancia"] = distancia;
      _filterController.sink.add(filters);
    }
    if(frete != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      filters["ord"] = {};
      filters["ord"]["frete"] = frete;
      _filterController.sink.add(filters);
    }
    if(time != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      filters["ord"] = {};
      filters["ord"]["time"] = time;
      _filterController.sink.add(filters);
    }
    if(padrao != null){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      filters["ord"] = {};
      filters["ord"]["padrao"] = padrao;
      _filterController.sink.add(filters);
    }
  }

  void resetFilter({bool frete = false}){
    if(frete){
      Map<String, Map<String,dynamic>> filters = _filterController.value;
      if(!filters.containsKey("filter")){
        filters["filter"] = {};
      }
      filters["filter"]["frete"] = null;
      _filterController.sink.add(filters);
      return;
    }
    Map<String, Map<String,dynamic>> filters = _filterController.value;
    filters["filter"] = {};
    _filterController.sink.add(filters);
  }

  @override
  void dispose() {
    super.dispose();
    _filterController.close();
    _companiesController.close();
  }
}