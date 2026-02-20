import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _ultimaSincronizacao = prefs.containsKey('ff_ultimaSincronizacao')
          ? DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('ff_ultimaSincronizacao')!)
          : _ultimaSincronizacao;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_propriedadeSelecionada')) {
        try {
          final serializedData =
              prefs.getString('ff_propriedadeSelecionada') ?? '{}';
          _propriedadeSelecionada =
              PropriedadeSelecionadaStruct.fromSerializableMap(
                  jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _atividades = prefs.getStringList('ff_atividades') ?? _atividades;
    });
    _safeInit(() {
      _propCidades = prefs.getStringList('ff_propCidades') ?? _propCidades;
    });
    _safeInit(() {
      _propEstados = prefs.getStringList('ff_propEstados') ?? _propEstados;
    });
    _safeInit(() {
      _rebanhoOFF = prefs
              .getStringList('ff_rebanhoOFF')
              ?.map((x) {
                try {
                  return RebanhoStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _rebanhoOFF;
    });
    _safeInit(() {
      _coresPropriedade = prefs
              .getStringList('ff_coresPropriedade')
              ?.map((x) => Color(int.tryParse(x) ?? 0))
              .toList() ??
          _coresPropriedade;
    });
    _safeInit(() {
      _icones = prefs.getStringList('ff_icones') ?? _icones;
    });
    _safeInit(() {
      _propriedadesChangeDateTime =
          prefs.containsKey('ff_propriedadesChangeDateTime')
              ? DateTime.fromMillisecondsSinceEpoch(
                  prefs.getInt('ff_propriedadesChangeDateTime')!)
              : _propriedadesChangeDateTime;
    });
    _safeInit(() {
      _isFirstRun = prefs.getBool('ff_isFirstRun') ?? _isFirstRun;
    });
    _safeInit(() {
      _dataDadosNaoSyncProp = prefs.containsKey('ff_dataDadosNaoSyncProp')
          ? DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('ff_dataDadosNaoSyncProp')!)
          : _dataDadosNaoSyncProp;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_userLogado')) {
        try {
          final serializedData = prefs.getString('ff_userLogado') ?? '{}';
          _userLogado =
              UserStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _statusRebanho =
          prefs.getStringList('ff_statusRebanho') ?? _statusRebanho;
    });
    _safeInit(() {
      _categoriasRebanhoFemea =
          prefs.getStringList('ff_categoriasRebanhoFemea') ??
              _categoriasRebanhoFemea;
    });
    _safeInit(() {
      _raca = prefs.getStringList('ff_raca') ?? _raca;
    });
    _safeInit(() {
      _origemRebanho =
          prefs.getStringList('ff_origemRebanho') ?? _origemRebanho;
    });
    _safeInit(() {
      _rebanhosChangeDateTime = prefs.containsKey('ff_rebanhosChangeDateTime')
          ? DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('ff_rebanhosChangeDateTime')!)
          : _rebanhosChangeDateTime;
    });
    _safeInit(() {
      _rebanhosPesagemChangeDateTime =
          prefs.containsKey('ff_rebanhosPesagemChangeDateTime')
              ? DateTime.fromMillisecondsSinceEpoch(
                  prefs.getInt('ff_rebanhosPesagemChangeDateTime')!)
              : _rebanhosPesagemChangeDateTime;
    });
    _safeInit(() {
      _lotesCadastrados =
          prefs.getInt('ff_lotesCadastrados') ?? _lotesCadastrados;
    });
    _safeInit(() {
      _rebanhoLotesSelecionar = prefs
              .getStringList('ff_rebanhoLotesSelecionar')
              ?.map((x) {
                try {
                  return LocalLotesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _rebanhoLotesSelecionar;
    });
    _safeInit(() {
      _qtdVacinas = prefs.getInt('ff_qtdVacinas') ?? _qtdVacinas;
    });
    _safeInit(() {
      _categoriasRebanhoMacho =
          prefs.getStringList('ff_categoriasRebanhoMacho') ??
              _categoriasRebanhoMacho;
    });
    _safeInit(() {
      _categoriasRebanho =
          prefs.getStringList('ff_categoriasRebanho') ?? _categoriasRebanho;
    });
    _safeInit(() {
      _dataDadosNaoSyncRebanho = prefs.containsKey('ff_dataDadosNaoSyncRebanho')
          ? DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('ff_dataDadosNaoSyncRebanho')!)
          : _dataDadosNaoSyncRebanho;
    });
    _safeInit(() {
      _dataDadosNaoSyncLotes = prefs.containsKey('ff_dataDadosNaoSyncLotes')
          ? DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('ff_dataDadosNaoSyncLotes')!)
          : _dataDadosNaoSyncLotes;
    });
    _safeInit(() {
      _dataDadosNaoSyncRepro = prefs.containsKey('ff_dataDadosNaoSyncRepro')
          ? DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('ff_dataDadosNaoSyncRepro')!)
          : _dataDadosNaoSyncRepro;
    });
    _safeInit(() {
      _dataDadosNaoSyncSanidade =
          prefs.containsKey('ff_dataDadosNaoSyncSanidade')
              ? DateTime.fromMillisecondsSinceEpoch(
                  prefs.getInt('ff_dataDadosNaoSyncSanidade')!)
              : _dataDadosNaoSyncSanidade;
    });
    _safeInit(() {
      _propriedadesOFF = prefs
              .getStringList('ff_propriedadesOFF')
              ?.map((x) {
                try {
                  return PropriedadesStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _propriedadesOFF;
    });
    _safeInit(() {
      _firstRunUserEmail =
          prefs.getString('ff_firstRunUserEmail') ?? _firstRunUserEmail;
    });
    _safeInit(() {
      _dateDefault = prefs.containsKey('ff_dateDefault')
          ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt('ff_dateDefault')!)
          : _dateDefault;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _navegacaoDashboard = 'painel';
  String get navegacaoDashboard => _navegacaoDashboard;
  set navegacaoDashboard(String value) {
    _navegacaoDashboard = value;
  }

  DateTime? _ultimaSincronizacao;
  DateTime? get ultimaSincronizacao => _ultimaSincronizacao;
  set ultimaSincronizacao(DateTime? value) {
    _ultimaSincronizacao = value;
    value != null
        ? prefs.setInt('ff_ultimaSincronizacao', value.millisecondsSinceEpoch)
        : prefs.remove('ff_ultimaSincronizacao');
  }

  PropriedadeSelecionadaStruct _propriedadeSelecionada =
      PropriedadeSelecionadaStruct();
  PropriedadeSelecionadaStruct get propriedadeSelecionada =>
      _propriedadeSelecionada;
  set propriedadeSelecionada(PropriedadeSelecionadaStruct value) {
    _propriedadeSelecionada = value;
    prefs.setString('ff_propriedadeSelecionada', value.serialize());
  }

  void updatePropriedadeSelecionadaStruct(
      Function(PropriedadeSelecionadaStruct) updateFn) {
    updateFn(_propriedadeSelecionada);
    prefs.setString(
        'ff_propriedadeSelecionada', _propriedadeSelecionada.serialize());
  }

  String _pagePropriedades = 'home';
  String get pagePropriedades => _pagePropriedades;
  set pagePropriedades(String value) {
    _pagePropriedades = value;
  }

  List<String> _atividades = [
    'Confinamento',
    'Cria',
    'Engorda',
    'Leite',
    'Recria'
  ];
  List<String> get atividades => _atividades;
  set atividades(List<String> value) {
    _atividades = value;
    prefs.setStringList('ff_atividades', value);
  }

  void addToAtividades(String value) {
    atividades.add(value);
    prefs.setStringList('ff_atividades', _atividades);
  }

  void removeFromAtividades(String value) {
    atividades.remove(value);
    prefs.setStringList('ff_atividades', _atividades);
  }

  void removeAtIndexFromAtividades(int index) {
    atividades.removeAt(index);
    prefs.setStringList('ff_atividades', _atividades);
  }

  void updateAtividadesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    atividades[index] = updateFn(_atividades[index]);
    prefs.setStringList('ff_atividades', _atividades);
  }

  void insertAtIndexInAtividades(int index, String value) {
    atividades.insert(index, value);
    prefs.setStringList('ff_atividades', _atividades);
  }

  List<String> _propCidades = [];
  List<String> get propCidades => _propCidades;
  set propCidades(List<String> value) {
    _propCidades = value;
    prefs.setStringList('ff_propCidades', value);
  }

  void addToPropCidades(String value) {
    propCidades.add(value);
    prefs.setStringList('ff_propCidades', _propCidades);
  }

  void removeFromPropCidades(String value) {
    propCidades.remove(value);
    prefs.setStringList('ff_propCidades', _propCidades);
  }

  void removeAtIndexFromPropCidades(int index) {
    propCidades.removeAt(index);
    prefs.setStringList('ff_propCidades', _propCidades);
  }

  void updatePropCidadesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    propCidades[index] = updateFn(_propCidades[index]);
    prefs.setStringList('ff_propCidades', _propCidades);
  }

  void insertAtIndexInPropCidades(int index, String value) {
    propCidades.insert(index, value);
    prefs.setStringList('ff_propCidades', _propCidades);
  }

  List<String> _propEstados = [];
  List<String> get propEstados => _propEstados;
  set propEstados(List<String> value) {
    _propEstados = value;
    prefs.setStringList('ff_propEstados', value);
  }

  void addToPropEstados(String value) {
    propEstados.add(value);
    prefs.setStringList('ff_propEstados', _propEstados);
  }

  void removeFromPropEstados(String value) {
    propEstados.remove(value);
    prefs.setStringList('ff_propEstados', _propEstados);
  }

  void removeAtIndexFromPropEstados(int index) {
    propEstados.removeAt(index);
    prefs.setStringList('ff_propEstados', _propEstados);
  }

  void updatePropEstadosAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    propEstados[index] = updateFn(_propEstados[index]);
    prefs.setStringList('ff_propEstados', _propEstados);
  }

  void insertAtIndexInPropEstados(int index, String value) {
    propEstados.insert(index, value);
    prefs.setStringList('ff_propEstados', _propEstados);
  }

  double _filtroNumeroAnimais = 0.0;
  double get filtroNumeroAnimais => _filtroNumeroAnimais;
  set filtroNumeroAnimais(double value) {
    _filtroNumeroAnimais = value;
  }

  List<String> _filtrosAplicadosProp = [];
  List<String> get filtrosAplicadosProp => _filtrosAplicadosProp;
  set filtrosAplicadosProp(List<String> value) {
    _filtrosAplicadosProp = value;
  }

  void addToFiltrosAplicadosProp(String value) {
    filtrosAplicadosProp.add(value);
  }

  void removeFromFiltrosAplicadosProp(String value) {
    filtrosAplicadosProp.remove(value);
  }

  void removeAtIndexFromFiltrosAplicadosProp(int index) {
    filtrosAplicadosProp.removeAt(index);
  }

  void updateFiltrosAplicadosPropAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filtrosAplicadosProp[index] = updateFn(_filtrosAplicadosProp[index]);
  }

  void insertAtIndexInFiltrosAplicadosProp(int index, String value) {
    filtrosAplicadosProp.insert(index, value);
  }

  List<RebanhoStruct> _rebanhoOFF = [];
  List<RebanhoStruct> get rebanhoOFF => _rebanhoOFF;
  set rebanhoOFF(List<RebanhoStruct> value) {
    _rebanhoOFF = value;
    prefs.setStringList(
        'ff_rebanhoOFF', value.map((x) => x.serialize()).toList());
  }

  void addToRebanhoOFF(RebanhoStruct value) {
    rebanhoOFF.add(value);
    prefs.setStringList(
        'ff_rebanhoOFF', _rebanhoOFF.map((x) => x.serialize()).toList());
  }

  void removeFromRebanhoOFF(RebanhoStruct value) {
    rebanhoOFF.remove(value);
    prefs.setStringList(
        'ff_rebanhoOFF', _rebanhoOFF.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromRebanhoOFF(int index) {
    rebanhoOFF.removeAt(index);
    prefs.setStringList(
        'ff_rebanhoOFF', _rebanhoOFF.map((x) => x.serialize()).toList());
  }

  void updateRebanhoOFFAtIndex(
    int index,
    RebanhoStruct Function(RebanhoStruct) updateFn,
  ) {
    rebanhoOFF[index] = updateFn(_rebanhoOFF[index]);
    prefs.setStringList(
        'ff_rebanhoOFF', _rebanhoOFF.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInRebanhoOFF(int index, RebanhoStruct value) {
    rebanhoOFF.insert(index, value);
    prefs.setStringList(
        'ff_rebanhoOFF', _rebanhoOFF.map((x) => x.serialize()).toList());
  }

  String _filtroPropCidades = '';
  String get filtroPropCidades => _filtroPropCidades;
  set filtroPropCidades(String value) {
    _filtroPropCidades = value;
  }

  String _filtroPropEstados = '';
  String get filtroPropEstados => _filtroPropEstados;
  set filtroPropEstados(String value) {
    _filtroPropEstados = value;
  }

  String _filtroPropAtividades = '';
  String get filtroPropAtividades => _filtroPropAtividades;
  set filtroPropAtividades(String value) {
    _filtroPropAtividades = value;
  }

  List<Color> _coresPropriedade = [
    Color(4278239999),
    Color(4278247311),
    Color(4280853349),
    Color(4280906700),
    Color(4287269514),
    Color(4289842217),
    Color(4291045836),
    Color(4291573545),
    Color(4294237184),
    Color(4294901760),
    Color(4294901898),
    Color(4294929152)
  ];
  List<Color> get coresPropriedade => _coresPropriedade;
  set coresPropriedade(List<Color> value) {
    _coresPropriedade = value;
    prefs.setStringList(
        'ff_coresPropriedade', value.map((x) => x.value.toString()).toList());
  }

  void addToCoresPropriedade(Color value) {
    coresPropriedade.add(value);
    prefs.setStringList('ff_coresPropriedade',
        _coresPropriedade.map((x) => x.value.toString()).toList());
  }

  void removeFromCoresPropriedade(Color value) {
    coresPropriedade.remove(value);
    prefs.setStringList('ff_coresPropriedade',
        _coresPropriedade.map((x) => x.value.toString()).toList());
  }

  void removeAtIndexFromCoresPropriedade(int index) {
    coresPropriedade.removeAt(index);
    prefs.setStringList('ff_coresPropriedade',
        _coresPropriedade.map((x) => x.value.toString()).toList());
  }

  void updateCoresPropriedadeAtIndex(
    int index,
    Color Function(Color) updateFn,
  ) {
    coresPropriedade[index] = updateFn(_coresPropriedade[index]);
    prefs.setStringList('ff_coresPropriedade',
        _coresPropriedade.map((x) => x.value.toString()).toList());
  }

  void insertAtIndexInCoresPropriedade(int index, Color value) {
    coresPropriedade.insert(index, value);
    prefs.setStringList('ff_coresPropriedade',
        _coresPropriedade.map((x) => x.value.toString()).toList());
  }

  List<String> _icones = [
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/tw4d7h9d826t/Vaca.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/cxvwgktjh5z8/Trigo.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/gues8f2v97ou/Trator.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/kaqpi2ywhbwh/Sol.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/ltoe9gg0j4wg/Queijo.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/wv7p3dujwurs/Porco.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/f5ykb54ult7i/Peixe.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/5zbk9384p0ja/Moinho.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/kpdgcsdxpwzi/Milho.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/d6vpjpmkwpgx/Leite.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/tajyotth3ks2/Folha.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/h4cbgm6ey2sq/Flor.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/p5k1nadu225f/Estrela.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/xlsppkci2uay/Chape%CC%81u.png',
    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/in-linda-b-k-p-a05zov/assets/ywwpnb4a7904/A%CC%81rvore.png'
  ];
  List<String> get icones => _icones;
  set icones(List<String> value) {
    _icones = value;
    prefs.setStringList('ff_icones', value);
  }

  void addToIcones(String value) {
    icones.add(value);
    prefs.setStringList('ff_icones', _icones);
  }

  void removeFromIcones(String value) {
    icones.remove(value);
    prefs.setStringList('ff_icones', _icones);
  }

  void removeAtIndexFromIcones(int index) {
    icones.removeAt(index);
    prefs.setStringList('ff_icones', _icones);
  }

  void updateIconesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    icones[index] = updateFn(_icones[index]);
    prefs.setStringList('ff_icones', _icones);
  }

  void insertAtIndexInIcones(int index, String value) {
    icones.insert(index, value);
    prefs.setStringList('ff_icones', _icones);
  }

  String _corSelecionada = '';
  String get corSelecionada => _corSelecionada;
  set corSelecionada(String value) {
    _corSelecionada = value;
  }

  String _iconeSelecionado = '';
  String get iconeSelecionado => _iconeSelecionado;
  set iconeSelecionado(String value) {
    _iconeSelecionado = value;
  }

  DateTime? _propriedadesChangeDateTime =
      DateTime.fromMillisecondsSinceEpoch(1495616760000);
  DateTime? get propriedadesChangeDateTime => _propriedadesChangeDateTime;
  set propriedadesChangeDateTime(DateTime? value) {
    _propriedadesChangeDateTime = value;
    value != null
        ? prefs.setInt(
            'ff_propriedadesChangeDateTime', value.millisecondsSinceEpoch)
        : prefs.remove('ff_propriedadesChangeDateTime');
  }

  int _propriedadesIndex = 0;
  int get propriedadesIndex => _propriedadesIndex;
  set propriedadesIndex(int value) {
    _propriedadesIndex = value;
  }

  bool _isFirstRun = true;
  bool get isFirstRun => _isFirstRun;
  set isFirstRun(bool value) {
    _isFirstRun = value;
    prefs.setBool('ff_isFirstRun', value);
  }

  DateTime? _dataDadosNaoSyncProp;
  DateTime? get dataDadosNaoSyncProp => _dataDadosNaoSyncProp;
  set dataDadosNaoSyncProp(DateTime? value) {
    _dataDadosNaoSyncProp = value;
    value != null
        ? prefs.setInt('ff_dataDadosNaoSyncProp', value.millisecondsSinceEpoch)
        : prefs.remove('ff_dataDadosNaoSyncProp');
  }

  UserStruct _userLogado = UserStruct();
  UserStruct get userLogado => _userLogado;
  set userLogado(UserStruct value) {
    _userLogado = value;
    prefs.setString('ff_userLogado', value.serialize());
  }

  void updateUserLogadoStruct(Function(UserStruct) updateFn) {
    updateFn(_userLogado);
    prefs.setString('ff_userLogado', _userLogado.serialize());
  }

  LocalPropriedadeStruct _propriedadeBuscada = LocalPropriedadeStruct();
  LocalPropriedadeStruct get propriedadeBuscada => _propriedadeBuscada;
  set propriedadeBuscada(LocalPropriedadeStruct value) {
    _propriedadeBuscada = value;
  }

  void updatePropriedadeBuscadaStruct(
      Function(LocalPropriedadeStruct) updateFn) {
    updateFn(_propriedadeBuscada);
  }

  String _filtroOrdenacao = 'Crescente';
  String get filtroOrdenacao => _filtroOrdenacao;
  set filtroOrdenacao(String value) {
    _filtroOrdenacao = value;
  }

  String _filtroTipoOrdenacao = '';
  String get filtroTipoOrdenacao => _filtroTipoOrdenacao;
  set filtroTipoOrdenacao(String value) {
    _filtroTipoOrdenacao = value;
  }

  List<UsersPropriedadeStruct> _usersPropriedade = [];
  List<UsersPropriedadeStruct> get usersPropriedade => _usersPropriedade;
  set usersPropriedade(List<UsersPropriedadeStruct> value) {
    _usersPropriedade = value;
  }

  void addToUsersPropriedade(UsersPropriedadeStruct value) {
    usersPropriedade.add(value);
  }

  void removeFromUsersPropriedade(UsersPropriedadeStruct value) {
    usersPropriedade.remove(value);
  }

  void removeAtIndexFromUsersPropriedade(int index) {
    usersPropriedade.removeAt(index);
  }

  void updateUsersPropriedadeAtIndex(
    int index,
    UsersPropriedadeStruct Function(UsersPropriedadeStruct) updateFn,
  ) {
    usersPropriedade[index] = updateFn(_usersPropriedade[index]);
  }

  void insertAtIndexInUsersPropriedade(
      int index, UsersPropriedadeStruct value) {
    usersPropriedade.insert(index, value);
  }

  int _usersPropIndex = 0;
  int get usersPropIndex => _usersPropIndex;
  set usersPropIndex(int value) {
    _usersPropIndex = value;
  }

  List<String> _addUserProp = [];
  List<String> get addUserProp => _addUserProp;
  set addUserProp(List<String> value) {
    _addUserProp = value;
  }

  void addToAddUserProp(String value) {
    addUserProp.add(value);
  }

  void removeFromAddUserProp(String value) {
    addUserProp.remove(value);
  }

  void removeAtIndexFromAddUserProp(int index) {
    addUserProp.removeAt(index);
  }

  void updateAddUserPropAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    addUserProp[index] = updateFn(_addUserProp[index]);
  }

  void insertAtIndexInAddUserProp(int index, String value) {
    addUserProp.insert(index, value);
  }

  List<String> _usersIDnaProppriedade = [];
  List<String> get usersIDnaProppriedade => _usersIDnaProppriedade;
  set usersIDnaProppriedade(List<String> value) {
    _usersIDnaProppriedade = value;
  }

  void addToUsersIDnaProppriedade(String value) {
    usersIDnaProppriedade.add(value);
  }

  void removeFromUsersIDnaProppriedade(String value) {
    usersIDnaProppriedade.remove(value);
  }

  void removeAtIndexFromUsersIDnaProppriedade(int index) {
    usersIDnaProppriedade.removeAt(index);
  }

  void updateUsersIDnaProppriedadeAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    usersIDnaProppriedade[index] = updateFn(_usersIDnaProppriedade[index]);
  }

  void insertAtIndexInUsersIDnaProppriedade(int index, String value) {
    usersIDnaProppriedade.insert(index, value);
  }

  List<String> _filtrosAplicadosRebanho = [];
  List<String> get filtrosAplicadosRebanho => _filtrosAplicadosRebanho;
  set filtrosAplicadosRebanho(List<String> value) {
    _filtrosAplicadosRebanho = value;
  }

  void addToFiltrosAplicadosRebanho(String value) {
    filtrosAplicadosRebanho.add(value);
  }

  void removeFromFiltrosAplicadosRebanho(String value) {
    filtrosAplicadosRebanho.remove(value);
  }

  void removeAtIndexFromFiltrosAplicadosRebanho(int index) {
    filtrosAplicadosRebanho.removeAt(index);
  }

  void updateFiltrosAplicadosRebanhoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filtrosAplicadosRebanho[index] = updateFn(_filtrosAplicadosRebanho[index]);
  }

  void insertAtIndexInFiltrosAplicadosRebanho(int index, String value) {
    filtrosAplicadosRebanho.insert(index, value);
  }

  List<String> _statusRebanho = [
    'Sêmen',
    'Vendido',
    'Na propriedade',
    'Fora da propriedade',
    'Morto',
    'Movimentação'
  ];
  List<String> get statusRebanho => _statusRebanho;
  set statusRebanho(List<String> value) {
    _statusRebanho = value;
    prefs.setStringList('ff_statusRebanho', value);
  }

  void addToStatusRebanho(String value) {
    statusRebanho.add(value);
    prefs.setStringList('ff_statusRebanho', _statusRebanho);
  }

  void removeFromStatusRebanho(String value) {
    statusRebanho.remove(value);
    prefs.setStringList('ff_statusRebanho', _statusRebanho);
  }

  void removeAtIndexFromStatusRebanho(int index) {
    statusRebanho.removeAt(index);
    prefs.setStringList('ff_statusRebanho', _statusRebanho);
  }

  void updateStatusRebanhoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    statusRebanho[index] = updateFn(_statusRebanho[index]);
    prefs.setStringList('ff_statusRebanho', _statusRebanho);
  }

  void insertAtIndexInStatusRebanho(int index, String value) {
    statusRebanho.insert(index, value);
    prefs.setStringList('ff_statusRebanho', _statusRebanho);
  }

  String _filtroSexoRebanho = '';
  String get filtroSexoRebanho => _filtroSexoRebanho;
  set filtroSexoRebanho(String value) {
    _filtroSexoRebanho = value;
  }

  String _filtroStatusRebanho = '';
  String get filtroStatusRebanho => _filtroStatusRebanho;
  set filtroStatusRebanho(String value) {
    _filtroStatusRebanho = value;
  }

  List<String> _categoriasRebanhoFemea = [
    'Bezerra',
    'Novilha',
    'Vaca Multipara',
    'Vaca Primipara'
  ];
  List<String> get categoriasRebanhoFemea => _categoriasRebanhoFemea;
  set categoriasRebanhoFemea(List<String> value) {
    _categoriasRebanhoFemea = value;
    prefs.setStringList('ff_categoriasRebanhoFemea', value);
  }

  void addToCategoriasRebanhoFemea(String value) {
    categoriasRebanhoFemea.add(value);
    prefs.setStringList('ff_categoriasRebanhoFemea', _categoriasRebanhoFemea);
  }

  void removeFromCategoriasRebanhoFemea(String value) {
    categoriasRebanhoFemea.remove(value);
    prefs.setStringList('ff_categoriasRebanhoFemea', _categoriasRebanhoFemea);
  }

  void removeAtIndexFromCategoriasRebanhoFemea(int index) {
    categoriasRebanhoFemea.removeAt(index);
    prefs.setStringList('ff_categoriasRebanhoFemea', _categoriasRebanhoFemea);
  }

  void updateCategoriasRebanhoFemeaAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    categoriasRebanhoFemea[index] = updateFn(_categoriasRebanhoFemea[index]);
    prefs.setStringList('ff_categoriasRebanhoFemea', _categoriasRebanhoFemea);
  }

  void insertAtIndexInCategoriasRebanhoFemea(int index, String value) {
    categoriasRebanhoFemea.insert(index, value);
    prefs.setStringList('ff_categoriasRebanhoFemea', _categoriasRebanhoFemea);
  }

  String _filtroCategoriasRebanho = '';
  String get filtroCategoriasRebanho => _filtroCategoriasRebanho;
  set filtroCategoriasRebanho(String value) {
    _filtroCategoriasRebanho = value;
  }

  List<String> _raca = [
    'Aberdeen',
    'Angus Black',
    'Angus Red',
    'Bonsmara',
    'Braford',
    'Brahman',
    'Brangus',
    'Caracu',
    'Charolês',
    'Devon Red',
    'Gir',
    'Girolando',
    'Guzerá',
    'Hereford',
    'Holandês',
    'Jersey',
    'Limousin',
    'Marchigiana',
    'Mestiço',
    'Nelore',
    'Nelore PO',
    'Pardo Suíço (CORTE)',
    'Pardo Suíço (Leite)',
    'Santa Gertrudis',
    'Senepol',
    'Simental',
    'Sindi',
    'Sindinel',
    'Tabapuã',
    'Wagyu'
  ];
  List<String> get raca => _raca;
  set raca(List<String> value) {
    _raca = value;
    prefs.setStringList('ff_raca', value);
  }

  void addToRaca(String value) {
    raca.add(value);
    prefs.setStringList('ff_raca', _raca);
  }

  void removeFromRaca(String value) {
    raca.remove(value);
    prefs.setStringList('ff_raca', _raca);
  }

  void removeAtIndexFromRaca(int index) {
    raca.removeAt(index);
    prefs.setStringList('ff_raca', _raca);
  }

  void updateRacaAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    raca[index] = updateFn(_raca[index]);
    prefs.setStringList('ff_raca', _raca);
  }

  void insertAtIndexInRaca(int index, String value) {
    raca.insert(index, value);
    prefs.setStringList('ff_raca', _raca);
  }

  String _filtroRaca = '';
  String get filtroRaca => _filtroRaca;
  set filtroRaca(String value) {
    _filtroRaca = value;
  }

  String _filtroOrigemRebanho = '';
  String get filtroOrigemRebanho => _filtroOrigemRebanho;
  set filtroOrigemRebanho(String value) {
    _filtroOrigemRebanho = value;
  }

  List<String> _origemRebanho = ['Compra', 'Movimentação', 'Nascimento'];
  List<String> get origemRebanho => _origemRebanho;
  set origemRebanho(List<String> value) {
    _origemRebanho = value;
    prefs.setStringList('ff_origemRebanho', value);
  }

  void addToOrigemRebanho(String value) {
    origemRebanho.add(value);
    prefs.setStringList('ff_origemRebanho', _origemRebanho);
  }

  void removeFromOrigemRebanho(String value) {
    origemRebanho.remove(value);
    prefs.setStringList('ff_origemRebanho', _origemRebanho);
  }

  void removeAtIndexFromOrigemRebanho(int index) {
    origemRebanho.removeAt(index);
    prefs.setStringList('ff_origemRebanho', _origemRebanho);
  }

  void updateOrigemRebanhoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    origemRebanho[index] = updateFn(_origemRebanho[index]);
    prefs.setStringList('ff_origemRebanho', _origemRebanho);
  }

  void insertAtIndexInOrigemRebanho(int index, String value) {
    origemRebanho.insert(index, value);
    prefs.setStringList('ff_origemRebanho', _origemRebanho);
  }

  int _qtdAnimaisPropriedade = 0;
  int get qtdAnimaisPropriedade => _qtdAnimaisPropriedade;
  set qtdAnimaisPropriedade(int value) {
    _qtdAnimaisPropriedade = value;
  }

  String _valueFormat = '';
  String get valueFormat => _valueFormat;
  set valueFormat(String value) {
    _valueFormat = value;
  }

  double _valueDouble = 0.0;
  double get valueDouble => _valueDouble;
  set valueDouble(double value) {
    _valueDouble = value;
  }

  String _valorSelecionadoCredito = '';
  String get valorSelecionadoCredito => _valorSelecionadoCredito;
  set valorSelecionadoCredito(String value) {
    _valorSelecionadoCredito = value;
  }

  DateTime? _rebanhosChangeDateTime =
      DateTime.fromMillisecondsSinceEpoch(1528129140000);
  DateTime? get rebanhosChangeDateTime => _rebanhosChangeDateTime;
  set rebanhosChangeDateTime(DateTime? value) {
    _rebanhosChangeDateTime = value;
    value != null
        ? prefs.setInt(
            'ff_rebanhosChangeDateTime', value.millisecondsSinceEpoch)
        : prefs.remove('ff_rebanhosChangeDateTime');
  }

  int _rebanhosIndex = 0;
  int get rebanhosIndex => _rebanhosIndex;
  set rebanhosIndex(int value) {
    _rebanhosIndex = value;
  }

  int _animaisRegistrados = 0;
  int get animaisRegistrados => _animaisRegistrados;
  set animaisRegistrados(int value) {
    _animaisRegistrados = value;
  }

  String _matrizNome = '';
  String get matrizNome => _matrizNome;
  set matrizNome(String value) {
    _matrizNome = value;
  }

  String _reprodutorNome = '';
  String get reprodutorNome => _reprodutorNome;
  set reprodutorNome(String value) {
    _reprodutorNome = value;
  }

  List<AnimaisStruct> _crias = [];
  List<AnimaisStruct> get crias => _crias;
  set crias(List<AnimaisStruct> value) {
    _crias = value;
  }

  void addToCrias(AnimaisStruct value) {
    crias.add(value);
  }

  void removeFromCrias(AnimaisStruct value) {
    crias.remove(value);
  }

  void removeAtIndexFromCrias(int index) {
    crias.removeAt(index);
  }

  void updateCriasAtIndex(
    int index,
    AnimaisStruct Function(AnimaisStruct) updateFn,
  ) {
    crias[index] = updateFn(_crias[index]);
  }

  void insertAtIndexInCrias(int index, AnimaisStruct value) {
    crias.insert(index, value);
  }

  List<HistoricoPesagensStruct> _histPesagens = [];
  List<HistoricoPesagensStruct> get histPesagens => _histPesagens;
  set histPesagens(List<HistoricoPesagensStruct> value) {
    _histPesagens = value;
  }

  void addToHistPesagens(HistoricoPesagensStruct value) {
    histPesagens.add(value);
  }

  void removeFromHistPesagens(HistoricoPesagensStruct value) {
    histPesagens.remove(value);
  }

  void removeAtIndexFromHistPesagens(int index) {
    histPesagens.removeAt(index);
  }

  void updateHistPesagensAtIndex(
    int index,
    HistoricoPesagensStruct Function(HistoricoPesagensStruct) updateFn,
  ) {
    histPesagens[index] = updateFn(_histPesagens[index]);
  }

  void insertAtIndexInHistPesagens(int index, HistoricoPesagensStruct value) {
    histPesagens.insert(index, value);
  }

  RebanhoStruct _rebanhoSelecionado = RebanhoStruct();
  RebanhoStruct get rebanhoSelecionado => _rebanhoSelecionado;
  set rebanhoSelecionado(RebanhoStruct value) {
    _rebanhoSelecionado = value;
  }

  void updateRebanhoSelecionadoStruct(Function(RebanhoStruct) updateFn) {
    updateFn(_rebanhoSelecionado);
  }

  DateTime? _rebanhosPesagemChangeDateTime =
      DateTime.fromMillisecondsSinceEpoch(1528308480000);
  DateTime? get rebanhosPesagemChangeDateTime => _rebanhosPesagemChangeDateTime;
  set rebanhosPesagemChangeDateTime(DateTime? value) {
    _rebanhosPesagemChangeDateTime = value;
    value != null
        ? prefs.setInt(
            'ff_rebanhosPesagemChangeDateTime', value.millisecondsSinceEpoch)
        : prefs.remove('ff_rebanhosPesagemChangeDateTime');
  }

  int _pesagensIndex = 0;
  int get pesagensIndex => _pesagensIndex;
  set pesagensIndex(int value) {
    _pesagensIndex = value;
  }

  List<String> _filtroAplicadosLotes = [];
  List<String> get filtroAplicadosLotes => _filtroAplicadosLotes;
  set filtroAplicadosLotes(List<String> value) {
    _filtroAplicadosLotes = value;
  }

  void addToFiltroAplicadosLotes(String value) {
    filtroAplicadosLotes.add(value);
  }

  void removeFromFiltroAplicadosLotes(String value) {
    filtroAplicadosLotes.remove(value);
  }

  void removeAtIndexFromFiltroAplicadosLotes(int index) {
    filtroAplicadosLotes.removeAt(index);
  }

  void updateFiltroAplicadosLotesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filtroAplicadosLotes[index] = updateFn(_filtroAplicadosLotes[index]);
  }

  void insertAtIndexInFiltroAplicadosLotes(int index, String value) {
    filtroAplicadosLotes.insert(index, value);
  }

  String _filtroAtivoLotes = '';
  String get filtroAtivoLotes => _filtroAtivoLotes;
  set filtroAtivoLotes(String value) {
    _filtroAtivoLotes = value;
  }

  int _qtdLotesAtivos = 0;
  int get qtdLotesAtivos => _qtdLotesAtivos;
  set qtdLotesAtivos(int value) {
    _qtdLotesAtivos = value;
  }

  int _qtdLotesInativos = 0;
  int get qtdLotesInativos => _qtdLotesInativos;
  set qtdLotesInativos(int value) {
    _qtdLotesInativos = value;
  }

  int _qtdAnimaisLote = 0;
  int get qtdAnimaisLote => _qtdAnimaisLote;
  set qtdAnimaisLote(int value) {
    _qtdAnimaisLote = value;
  }

  List<RebanhoStruct> _rebanhosLote = [];
  List<RebanhoStruct> get rebanhosLote => _rebanhosLote;
  set rebanhosLote(List<RebanhoStruct> value) {
    _rebanhosLote = value;
  }

  void addToRebanhosLote(RebanhoStruct value) {
    rebanhosLote.add(value);
  }

  void removeFromRebanhosLote(RebanhoStruct value) {
    rebanhosLote.remove(value);
  }

  void removeAtIndexFromRebanhosLote(int index) {
    rebanhosLote.removeAt(index);
  }

  void updateRebanhosLoteAtIndex(
    int index,
    RebanhoStruct Function(RebanhoStruct) updateFn,
  ) {
    rebanhosLote[index] = updateFn(_rebanhosLote[index]);
  }

  void insertAtIndexInRebanhosLote(int index, RebanhoStruct value) {
    rebanhosLote.insert(index, value);
  }

  int _rebanhosLoteIndex = 0;
  int get rebanhosLoteIndex => _rebanhosLoteIndex;
  set rebanhosLoteIndex(int value) {
    _rebanhosLoteIndex = value;
  }

  DateTime? _lotesChangeDateTime =
      DateTime.fromMillisecondsSinceEpoch(1497268200000);
  DateTime? get lotesChangeDateTime => _lotesChangeDateTime;
  set lotesChangeDateTime(DateTime? value) {
    _lotesChangeDateTime = value;
  }

  int _lotesIndex = 0;
  int get lotesIndex => _lotesIndex;
  set lotesIndex(int value) {
    _lotesIndex = value;
  }

  int _lotesCadastrados = 0;
  int get lotesCadastrados => _lotesCadastrados;
  set lotesCadastrados(int value) {
    _lotesCadastrados = value;
    prefs.setInt('ff_lotesCadastrados', value);
  }

  List<LocalLotesStruct> _rebanhoLotesSelecionar = [];
  List<LocalLotesStruct> get rebanhoLotesSelecionar => _rebanhoLotesSelecionar;
  set rebanhoLotesSelecionar(List<LocalLotesStruct> value) {
    _rebanhoLotesSelecionar = value;
    prefs.setStringList(
        'ff_rebanhoLotesSelecionar', value.map((x) => x.serialize()).toList());
  }

  void addToRebanhoLotesSelecionar(LocalLotesStruct value) {
    rebanhoLotesSelecionar.add(value);
    prefs.setStringList('ff_rebanhoLotesSelecionar',
        _rebanhoLotesSelecionar.map((x) => x.serialize()).toList());
  }

  void removeFromRebanhoLotesSelecionar(LocalLotesStruct value) {
    rebanhoLotesSelecionar.remove(value);
    prefs.setStringList('ff_rebanhoLotesSelecionar',
        _rebanhoLotesSelecionar.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromRebanhoLotesSelecionar(int index) {
    rebanhoLotesSelecionar.removeAt(index);
    prefs.setStringList('ff_rebanhoLotesSelecionar',
        _rebanhoLotesSelecionar.map((x) => x.serialize()).toList());
  }

  void updateRebanhoLotesSelecionarAtIndex(
    int index,
    LocalLotesStruct Function(LocalLotesStruct) updateFn,
  ) {
    rebanhoLotesSelecionar[index] = updateFn(_rebanhoLotesSelecionar[index]);
    prefs.setStringList('ff_rebanhoLotesSelecionar',
        _rebanhoLotesSelecionar.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInRebanhoLotesSelecionar(
      int index, LocalLotesStruct value) {
    rebanhoLotesSelecionar.insert(index, value);
    prefs.setStringList('ff_rebanhoLotesSelecionar',
        _rebanhoLotesSelecionar.map((x) => x.serialize()).toList());
  }

  String _filtroReproducao = '';
  String get filtroReproducao => _filtroReproducao;
  set filtroReproducao(String value) {
    _filtroReproducao = value;
  }

  List<String> _filtrosAplicadosReproducao = [];
  List<String> get filtrosAplicadosReproducao => _filtrosAplicadosReproducao;
  set filtrosAplicadosReproducao(List<String> value) {
    _filtrosAplicadosReproducao = value;
  }

  void addToFiltrosAplicadosReproducao(String value) {
    filtrosAplicadosReproducao.add(value);
  }

  void removeFromFiltrosAplicadosReproducao(String value) {
    filtrosAplicadosReproducao.remove(value);
  }

  void removeAtIndexFromFiltrosAplicadosReproducao(int index) {
    filtrosAplicadosReproducao.removeAt(index);
  }

  void updateFiltrosAplicadosReproducaoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filtrosAplicadosReproducao[index] =
        updateFn(_filtrosAplicadosReproducao[index]);
  }

  void insertAtIndexInFiltrosAplicadosReproducao(int index, String value) {
    filtrosAplicadosReproducao.insert(index, value);
  }

  DateTime? _filtroDataReproducao;
  DateTime? get filtroDataReproducao => _filtroDataReproducao;
  set filtroDataReproducao(DateTime? value) {
    _filtroDataReproducao = value;
  }

  DateTime? _filtroDataParto;
  DateTime? get filtroDataParto => _filtroDataParto;
  set filtroDataParto(DateTime? value) {
    _filtroDataParto = value;
  }

  String _filtroInseminador = '';
  String get filtroInseminador => _filtroInseminador;
  set filtroInseminador(String value) {
    _filtroInseminador = value;
  }

  int _countReproducoes = 0;
  int get countReproducoes => _countReproducoes;
  set countReproducoes(int value) {
    _countReproducoes = value;
  }

  int _countInseminacoes = 0;
  int get countInseminacoes => _countInseminacoes;
  set countInseminacoes(int value) {
    _countInseminacoes = value;
  }

  int _countMontaNatural = 0;
  int get countMontaNatural => _countMontaNatural;
  set countMontaNatural(int value) {
    _countMontaNatural = value;
  }

  String _filtroMatrizReproducao = '';
  String get filtroMatrizReproducao => _filtroMatrizReproducao;
  set filtroMatrizReproducao(String value) {
    _filtroMatrizReproducao = value;
  }

  String _filtroReprodutorReproducao = '';
  String get filtroReprodutorReproducao => _filtroReprodutorReproducao;
  set filtroReprodutorReproducao(String value) {
    _filtroReprodutorReproducao = value;
  }

  String _filtroLoteReproducao = '';
  String get filtroLoteReproducao => _filtroLoteReproducao;
  set filtroLoteReproducao(String value) {
    _filtroLoteReproducao = value;
  }

  String _filtroDataReproducaoTxt = '';
  String get filtroDataReproducaoTxt => _filtroDataReproducaoTxt;
  set filtroDataReproducaoTxt(String value) {
    _filtroDataReproducaoTxt = value;
  }

  String _filtroPrevisaoPartoTxt = '';
  String get filtroPrevisaoPartoTxt => _filtroPrevisaoPartoTxt;
  set filtroPrevisaoPartoTxt(String value) {
    _filtroPrevisaoPartoTxt = value;
  }

  DateTime? _reproducaoChangeDateTime =
      DateTime.fromMillisecondsSinceEpoch(1497796620000);
  DateTime? get reproducaoChangeDateTime => _reproducaoChangeDateTime;
  set reproducaoChangeDateTime(DateTime? value) {
    _reproducaoChangeDateTime = value;
  }

  int _reproducaoIndex = 0;
  int get reproducaoIndex => _reproducaoIndex;
  set reproducaoIndex(int value) {
    _reproducaoIndex = value;
  }

  List<String> _sanidadesOp = [
    'Vacina',
    'Antiparasitário',
    'Tratamento',
    'Protocolo reprodutivo'
  ];
  List<String> get sanidadesOp => _sanidadesOp;
  set sanidadesOp(List<String> value) {
    _sanidadesOp = value;
  }

  void addToSanidadesOp(String value) {
    sanidadesOp.add(value);
  }

  void removeFromSanidadesOp(String value) {
    sanidadesOp.remove(value);
  }

  void removeAtIndexFromSanidadesOp(int index) {
    sanidadesOp.removeAt(index);
  }

  void updateSanidadesOpAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    sanidadesOp[index] = updateFn(_sanidadesOp[index]);
  }

  void insertAtIndexInSanidadesOp(int index, String value) {
    sanidadesOp.insert(index, value);
  }

  List<String> _sanidade = [];
  List<String> get sanidade => _sanidade;
  set sanidade(List<String> value) {
    _sanidade = value;
  }

  void addToSanidade(String value) {
    sanidade.add(value);
  }

  void removeFromSanidade(String value) {
    sanidade.remove(value);
  }

  void removeAtIndexFromSanidade(int index) {
    sanidade.removeAt(index);
  }

  void updateSanidadeAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    sanidade[index] = updateFn(_sanidade[index]);
  }

  void insertAtIndexInSanidade(int index, String value) {
    sanidade.insert(index, value);
  }

  int _vacinasCount = 0;
  int get vacinasCount => _vacinasCount;
  set vacinasCount(int value) {
    _vacinasCount = value;
  }

  int _antiParasitarioCount = 0;
  int get antiParasitarioCount => _antiParasitarioCount;
  set antiParasitarioCount(int value) {
    _antiParasitarioCount = value;
  }

  int _tratamentosCount = 0;
  int get tratamentosCount => _tratamentosCount;
  set tratamentosCount(int value) {
    _tratamentosCount = value;
  }

  int _protocolosReproCount = 0;
  int get protocolosReproCount => _protocolosReproCount;
  set protocolosReproCount(int value) {
    _protocolosReproCount = value;
  }

  SanidadeStruct _sanidadeSelecionada = SanidadeStruct();
  SanidadeStruct get sanidadeSelecionada => _sanidadeSelecionada;
  set sanidadeSelecionada(SanidadeStruct value) {
    _sanidadeSelecionada = value;
  }

  void updateSanidadeSelecionadaStruct(Function(SanidadeStruct) updateFn) {
    updateFn(_sanidadeSelecionada);
  }

  int _qtdVacinas = 0;
  int get qtdVacinas => _qtdVacinas;
  set qtdVacinas(int value) {
    _qtdVacinas = value;
    prefs.setInt('ff_qtdVacinas', value);
  }

  int _indexCountSanidades = 0;
  int get indexCountSanidades => _indexCountSanidades;
  set indexCountSanidades(int value) {
    _indexCountSanidades = value;
  }

  int _qtdAntiparasitarios = 0;
  int get qtdAntiparasitarios => _qtdAntiparasitarios;
  set qtdAntiparasitarios(int value) {
    _qtdAntiparasitarios = value;
  }

  int _qtdTratamento = 0;
  int get qtdTratamento => _qtdTratamento;
  set qtdTratamento(int value) {
    _qtdTratamento = value;
  }

  int _qtdProtocoloReprodutivo = 0;
  int get qtdProtocoloReprodutivo => _qtdProtocoloReprodutivo;
  set qtdProtocoloReprodutivo(int value) {
    _qtdProtocoloReprodutivo = value;
  }

  int _indexCountSanidades2 = 0;
  int get indexCountSanidades2 => _indexCountSanidades2;
  set indexCountSanidades2(int value) {
    _indexCountSanidades2 = value;
  }

  int _indexCountSanidades3 = 0;
  int get indexCountSanidades3 => _indexCountSanidades3;
  set indexCountSanidades3(int value) {
    _indexCountSanidades3 = value;
  }

  int _indexCountSanidades4 = 0;
  int get indexCountSanidades4 => _indexCountSanidades4;
  set indexCountSanidades4(int value) {
    _indexCountSanidades4 = value;
  }

  List<String> _vacinacao = [
    'Aftosa',
    'Antitetânica',
    'Botulismo',
    'Brucelose',
    'Clostridiose',
    'Diarréia (BVD)',
    'Doença Respiratóa (DBR)',
    'Leptospirose',
    'Parainfluenza e herpes',
    'Raiva',
    'Rinotraqueíte (IBR)'
  ];
  List<String> get vacinacao => _vacinacao;
  set vacinacao(List<String> value) {
    _vacinacao = value;
  }

  void addToVacinacao(String value) {
    vacinacao.add(value);
  }

  void removeFromVacinacao(String value) {
    vacinacao.remove(value);
  }

  void removeAtIndexFromVacinacao(int index) {
    vacinacao.removeAt(index);
  }

  void updateVacinacaoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    vacinacao[index] = updateFn(_vacinacao[index]);
  }

  void insertAtIndexInVacinacao(int index, String value) {
    vacinacao.insert(index, value);
  }

  List<String> _antiparasitario = [
    'Abamectina',
    'Albendazol',
    'Babesiose (Tristeza Bovina) & Tripanossoma',
    'Brinco mosquicida',
    'Carrapaticida & Mosquicida (PourON)',
    'Carrapaticida & Mosquicida (Pulverização)',
    'Deltrametrina, Imidocarp, Nitroxinil & Triclorfon',
    'Doramectina',
    'Eprinomectina',
    'Ivermectina'
  ];
  List<String> get antiparasitario => _antiparasitario;
  set antiparasitario(List<String> value) {
    _antiparasitario = value;
  }

  void addToAntiparasitario(String value) {
    antiparasitario.add(value);
  }

  void removeFromAntiparasitario(String value) {
    antiparasitario.remove(value);
  }

  void removeAtIndexFromAntiparasitario(int index) {
    antiparasitario.removeAt(index);
  }

  void updateAntiparasitarioAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    antiparasitario[index] = updateFn(_antiparasitario[index]);
  }

  void insertAtIndexInAntiparasitario(int index, String value) {
    antiparasitario.insert(index, value);
  }

  List<String> _tratamento = [
    'Anestésico, Sedativo & Similares',
    'Analgésico',
    'Anti-inflamatório',
    'Anti-séptico',
    'Castração Química',
    'Complexo Vitamínico & Mineral',
    'Homeopático',
    'Hormônio',
    'Antibiótico'
  ];
  List<String> get tratamento => _tratamento;
  set tratamento(List<String> value) {
    _tratamento = value;
  }

  void addToTratamento(String value) {
    tratamento.add(value);
  }

  void removeFromTratamento(String value) {
    tratamento.remove(value);
  }

  void removeAtIndexFromTratamento(int index) {
    tratamento.removeAt(index);
  }

  void updateTratamentoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    tratamento[index] = updateFn(_tratamento[index]);
  }

  void insertAtIndexInTratamento(int index, String value) {
    tratamento.insert(index, value);
  }

  List<String> _protocoloReprodutivo = [
    'Benzoato de estradiol',
    'Progesterona',
    'Gonadotrofina',
    'Prostaglandina',
    'Cipionato de estradiol'
  ];
  List<String> get protocoloReprodutivo => _protocoloReprodutivo;
  set protocoloReprodutivo(List<String> value) {
    _protocoloReprodutivo = value;
  }

  void addToProtocoloReprodutivo(String value) {
    protocoloReprodutivo.add(value);
  }

  void removeFromProtocoloReprodutivo(String value) {
    protocoloReprodutivo.remove(value);
  }

  void removeAtIndexFromProtocoloReprodutivo(int index) {
    protocoloReprodutivo.removeAt(index);
  }

  void updateProtocoloReprodutivoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    protocoloReprodutivo[index] = updateFn(_protocoloReprodutivo[index]);
  }

  void insertAtIndexInProtocoloReprodutivo(int index, String value) {
    protocoloReprodutivo.insert(index, value);
  }

  List<String> _filtrosSanidades = [];
  List<String> get filtrosSanidades => _filtrosSanidades;
  set filtrosSanidades(List<String> value) {
    _filtrosSanidades = value;
  }

  void addToFiltrosSanidades(String value) {
    filtrosSanidades.add(value);
  }

  void removeFromFiltrosSanidades(String value) {
    filtrosSanidades.remove(value);
  }

  void removeAtIndexFromFiltrosSanidades(int index) {
    filtrosSanidades.removeAt(index);
  }

  void updateFiltrosSanidadesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filtrosSanidades[index] = updateFn(_filtrosSanidades[index]);
  }

  void insertAtIndexInFiltrosSanidades(int index, String value) {
    filtrosSanidades.insert(index, value);
  }

  String _filtroVacinacao = '';
  String get filtroVacinacao => _filtroVacinacao;
  set filtroVacinacao(String value) {
    _filtroVacinacao = value;
  }

  String _filtroAntiparasitario = '';
  String get filtroAntiparasitario => _filtroAntiparasitario;
  set filtroAntiparasitario(String value) {
    _filtroAntiparasitario = value;
  }

  String _filtroTratamento = '';
  String get filtroTratamento => _filtroTratamento;
  set filtroTratamento(String value) {
    _filtroTratamento = value;
  }

  String _filtroProtocoloReprodutivo = '';
  String get filtroProtocoloReprodutivo => _filtroProtocoloReprodutivo;
  set filtroProtocoloReprodutivo(String value) {
    _filtroProtocoloReprodutivo = value;
  }

  String _filtroLoteSanidade = '';
  String get filtroLoteSanidade => _filtroLoteSanidade;
  set filtroLoteSanidade(String value) {
    _filtroLoteSanidade = value;
  }

  String _filtroLoteSanidadeNome = '';
  String get filtroLoteSanidadeNome => _filtroLoteSanidadeNome;
  set filtroLoteSanidadeNome(String value) {
    _filtroLoteSanidadeNome = value;
  }

  String _filtroSanidadeAnimal = '';
  String get filtroSanidadeAnimal => _filtroSanidadeAnimal;
  set filtroSanidadeAnimal(String value) {
    _filtroSanidadeAnimal = value;
  }

  String _filtroSanidadeAnimalNome = '';
  String get filtroSanidadeAnimalNome => _filtroSanidadeAnimalNome;
  set filtroSanidadeAnimalNome(String value) {
    _filtroSanidadeAnimalNome = value;
  }

  DateTime? _filtroDataSanidade;
  DateTime? get filtroDataSanidade => _filtroDataSanidade;
  set filtroDataSanidade(DateTime? value) {
    _filtroDataSanidade = value;
  }

  String _filtroDataSanidadeTxt = '';
  String get filtroDataSanidadeTxt => _filtroDataSanidadeTxt;
  set filtroDataSanidadeTxt(String value) {
    _filtroDataSanidadeTxt = value;
  }

  DateTime? _sanidadeChangeDateTime =
      DateTime.fromMillisecondsSinceEpoch(1498343520000);
  DateTime? get sanidadeChangeDateTime => _sanidadeChangeDateTime;
  set sanidadeChangeDateTime(DateTime? value) {
    _sanidadeChangeDateTime = value;
  }

  int _sanidadeIndex = 0;
  int get sanidadeIndex => _sanidadeIndex;
  set sanidadeIndex(int value) {
    _sanidadeIndex = value;
  }

  List<String> _filtroStatusRebanhoList = [];
  List<String> get filtroStatusRebanhoList => _filtroStatusRebanhoList;
  set filtroStatusRebanhoList(List<String> value) {
    _filtroStatusRebanhoList = value;
  }

  void addToFiltroStatusRebanhoList(String value) {
    filtroStatusRebanhoList.add(value);
  }

  void removeFromFiltroStatusRebanhoList(String value) {
    filtroStatusRebanhoList.remove(value);
  }

  void removeAtIndexFromFiltroStatusRebanhoList(int index) {
    filtroStatusRebanhoList.removeAt(index);
  }

  void updateFiltroStatusRebanhoListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    filtroStatusRebanhoList[index] = updateFn(_filtroStatusRebanhoList[index]);
  }

  void insertAtIndexInFiltroStatusRebanhoList(int index, String value) {
    filtroStatusRebanhoList.insert(index, value);
  }

  List<String> _categoriasRebanhoMacho = [
    'Boi Gordo',
    'Boi Magro',
    'Garrote',
    'Rufião',
    'Touro',
    'Bezerro'
  ];
  List<String> get categoriasRebanhoMacho => _categoriasRebanhoMacho;
  set categoriasRebanhoMacho(List<String> value) {
    _categoriasRebanhoMacho = value;
    prefs.setStringList('ff_categoriasRebanhoMacho', value);
  }

  void addToCategoriasRebanhoMacho(String value) {
    categoriasRebanhoMacho.add(value);
    prefs.setStringList('ff_categoriasRebanhoMacho', _categoriasRebanhoMacho);
  }

  void removeFromCategoriasRebanhoMacho(String value) {
    categoriasRebanhoMacho.remove(value);
    prefs.setStringList('ff_categoriasRebanhoMacho', _categoriasRebanhoMacho);
  }

  void removeAtIndexFromCategoriasRebanhoMacho(int index) {
    categoriasRebanhoMacho.removeAt(index);
    prefs.setStringList('ff_categoriasRebanhoMacho', _categoriasRebanhoMacho);
  }

  void updateCategoriasRebanhoMachoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    categoriasRebanhoMacho[index] = updateFn(_categoriasRebanhoMacho[index]);
    prefs.setStringList('ff_categoriasRebanhoMacho', _categoriasRebanhoMacho);
  }

  void insertAtIndexInCategoriasRebanhoMacho(int index, String value) {
    categoriasRebanhoMacho.insert(index, value);
    prefs.setStringList('ff_categoriasRebanhoMacho', _categoriasRebanhoMacho);
  }

  List<String> _categoriasRebanho = [
    'Bezerra',
    'Bezerro',
    'Boi Gordo',
    'Boi Magro',
    'Garrote',
    'Novilha',
    'Rufião',
    'Touro',
    'Vaca Multipara',
    'Vaca Primipara'
  ];
  List<String> get categoriasRebanho => _categoriasRebanho;
  set categoriasRebanho(List<String> value) {
    _categoriasRebanho = value;
    prefs.setStringList('ff_categoriasRebanho', value);
  }

  void addToCategoriasRebanho(String value) {
    categoriasRebanho.add(value);
    prefs.setStringList('ff_categoriasRebanho', _categoriasRebanho);
  }

  void removeFromCategoriasRebanho(String value) {
    categoriasRebanho.remove(value);
    prefs.setStringList('ff_categoriasRebanho', _categoriasRebanho);
  }

  void removeAtIndexFromCategoriasRebanho(int index) {
    categoriasRebanho.removeAt(index);
    prefs.setStringList('ff_categoriasRebanho', _categoriasRebanho);
  }

  void updateCategoriasRebanhoAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    categoriasRebanho[index] = updateFn(_categoriasRebanho[index]);
    prefs.setStringList('ff_categoriasRebanho', _categoriasRebanho);
  }

  void insertAtIndexInCategoriasRebanho(int index, String value) {
    categoriasRebanho.insert(index, value);
    prefs.setStringList('ff_categoriasRebanho', _categoriasRebanho);
  }

  int _indexRebPaginacao = 0;
  int get indexRebPaginacao => _indexRebPaginacao;
  set indexRebPaginacao(int value) {
    _indexRebPaginacao = value;
  }

  int _ctrlUltimaPagina = 0;
  int get ctrlUltimaPagina => _ctrlUltimaPagina;
  set ctrlUltimaPagina(int value) {
    _ctrlUltimaPagina = value;
  }

  int _indexCtrlRebanhos = 0;
  int get indexCtrlRebanhos => _indexCtrlRebanhos;
  set indexCtrlRebanhos(int value) {
    _indexCtrlRebanhos = value;
  }

  int _totalRebanhos = 0;
  int get totalRebanhos => _totalRebanhos;
  set totalRebanhos(int value) {
    _totalRebanhos = value;
  }

  bool _visibleProgressBar = false;
  bool get visibleProgressBar => _visibleProgressBar;
  set visibleProgressBar(bool value) {
    _visibleProgressBar = value;
  }

  String _valueFormat2 = '';
  String get valueFormat2 => _valueFormat2;
  set valueFormat2(String value) {
    _valueFormat2 = value;
  }

  double _valueDouble2 = 0.0;
  double get valueDouble2 => _valueDouble2;
  set valueDouble2(double value) {
    _valueDouble2 = value;
  }

  DateTime? _dataDadosNaoSyncRebanho;
  DateTime? get dataDadosNaoSyncRebanho => _dataDadosNaoSyncRebanho;
  set dataDadosNaoSyncRebanho(DateTime? value) {
    _dataDadosNaoSyncRebanho = value;
    value != null
        ? prefs.setInt(
            'ff_dataDadosNaoSyncRebanho', value.millisecondsSinceEpoch)
        : prefs.remove('ff_dataDadosNaoSyncRebanho');
  }

  DateTime? _dataDadosNaoSyncLotes;
  DateTime? get dataDadosNaoSyncLotes => _dataDadosNaoSyncLotes;
  set dataDadosNaoSyncLotes(DateTime? value) {
    _dataDadosNaoSyncLotes = value;
    value != null
        ? prefs.setInt('ff_dataDadosNaoSyncLotes', value.millisecondsSinceEpoch)
        : prefs.remove('ff_dataDadosNaoSyncLotes');
  }

  DateTime? _dataDadosNaoSyncRepro;
  DateTime? get dataDadosNaoSyncRepro => _dataDadosNaoSyncRepro;
  set dataDadosNaoSyncRepro(DateTime? value) {
    _dataDadosNaoSyncRepro = value;
    value != null
        ? prefs.setInt('ff_dataDadosNaoSyncRepro', value.millisecondsSinceEpoch)
        : prefs.remove('ff_dataDadosNaoSyncRepro');
  }

  DateTime? _dataDadosNaoSyncSanidade;
  DateTime? get dataDadosNaoSyncSanidade => _dataDadosNaoSyncSanidade;
  set dataDadosNaoSyncSanidade(DateTime? value) {
    _dataDadosNaoSyncSanidade = value;
    value != null
        ? prefs.setInt(
            'ff_dataDadosNaoSyncSanidade', value.millisecondsSinceEpoch)
        : prefs.remove('ff_dataDadosNaoSyncSanidade');
  }

  AnimalSelecionadoStruct _matrizSelecionada =
      AnimalSelecionadoStruct.fromSerializableMap(jsonDecode('{}'));
  AnimalSelecionadoStruct get matrizSelecionada => _matrizSelecionada;
  set matrizSelecionada(AnimalSelecionadoStruct value) {
    _matrizSelecionada = value;
  }

  void updateMatrizSelecionadaStruct(
      Function(AnimalSelecionadoStruct) updateFn) {
    updateFn(_matrizSelecionada);
  }

  AnimalSelecionadoStruct _reprodutorSelecionado =
      AnimalSelecionadoStruct.fromSerializableMap(jsonDecode('{}'));
  AnimalSelecionadoStruct get reprodutorSelecionado => _reprodutorSelecionado;
  set reprodutorSelecionado(AnimalSelecionadoStruct value) {
    _reprodutorSelecionado = value;
  }

  void updateReprodutorSelecionadoStruct(
      Function(AnimalSelecionadoStruct) updateFn) {
    updateFn(_reprodutorSelecionado);
  }

  int _totalReproducoes = 0;
  int get totalReproducoes => _totalReproducoes;
  set totalReproducoes(int value) {
    _totalReproducoes = value;
  }

  int _indexReproPaginacao = 0;
  int get indexReproPaginacao => _indexReproPaginacao;
  set indexReproPaginacao(int value) {
    _indexReproPaginacao = value;
  }

  bool _visibilidadeProgressBarRepro = false;
  bool get visibilidadeProgressBarRepro => _visibilidadeProgressBarRepro;
  set visibilidadeProgressBarRepro(bool value) {
    _visibilidadeProgressBarRepro = value;
  }

  AnimalSelecionadoStruct _rebanhoSanidadeSelecionado =
      AnimalSelecionadoStruct();
  AnimalSelecionadoStruct get rebanhoSanidadeSelecionado =>
      _rebanhoSanidadeSelecionado;
  set rebanhoSanidadeSelecionado(AnimalSelecionadoStruct value) {
    _rebanhoSanidadeSelecionado = value;
  }

  void updateRebanhoSanidadeSelecionadoStruct(
      Function(AnimalSelecionadoStruct) updateFn) {
    updateFn(_rebanhoSanidadeSelecionado);
  }

  int _qtdSanidades = 0;
  int get qtdSanidades => _qtdSanidades;
  set qtdSanidades(int value) {
    _qtdSanidades = value;
  }

  List<PropriedadesStruct> _propriedadesOFF = [];
  List<PropriedadesStruct> get propriedadesOFF => _propriedadesOFF;
  set propriedadesOFF(List<PropriedadesStruct> value) {
    _propriedadesOFF = value;
    prefs.setStringList(
        'ff_propriedadesOFF', value.map((x) => x.serialize()).toList());
  }

  void addToPropriedadesOFF(PropriedadesStruct value) {
    propriedadesOFF.add(value);
    prefs.setStringList('ff_propriedadesOFF',
        _propriedadesOFF.map((x) => x.serialize()).toList());
  }

  void removeFromPropriedadesOFF(PropriedadesStruct value) {
    propriedadesOFF.remove(value);
    prefs.setStringList('ff_propriedadesOFF',
        _propriedadesOFF.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromPropriedadesOFF(int index) {
    propriedadesOFF.removeAt(index);
    prefs.setStringList('ff_propriedadesOFF',
        _propriedadesOFF.map((x) => x.serialize()).toList());
  }

  void updatePropriedadesOFFAtIndex(
    int index,
    PropriedadesStruct Function(PropriedadesStruct) updateFn,
  ) {
    propriedadesOFF[index] = updateFn(_propriedadesOFF[index]);
    prefs.setStringList('ff_propriedadesOFF',
        _propriedadesOFF.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInPropriedadesOFF(int index, PropriedadesStruct value) {
    propriedadesOFF.insert(index, value);
    prefs.setStringList('ff_propriedadesOFF',
        _propriedadesOFF.map((x) => x.serialize()).toList());
  }

  String _firstRunUserEmail = '';
  String get firstRunUserEmail => _firstRunUserEmail;
  set firstRunUserEmail(String value) {
    _firstRunUserEmail = value;
    prefs.setString('ff_firstRunUserEmail', value);
  }

  DateTime? _pesagensChangeDateTime =
      DateTime.fromMillisecondsSinceEpoch(1505578800000);
  DateTime? get pesagensChangeDateTime => _pesagensChangeDateTime;
  set pesagensChangeDateTime(DateTime? value) {
    _pesagensChangeDateTime = value;
  }

  int _totalPesagens = 0;
  int get totalPesagens => _totalPesagens;
  set totalPesagens(int value) {
    _totalPesagens = value;
  }

  int _indexPesagens = 0;
  int get indexPesagens => _indexPesagens;
  set indexPesagens(int value) {
    _indexPesagens = value;
  }

  bool _rebuild = false;
  bool get rebuild => _rebuild;
  set rebuild(bool value) {
    _rebuild = value;
  }

  String _criaSelecionada = '';
  String get criaSelecionada => _criaSelecionada;
  set criaSelecionada(String value) {
    _criaSelecionada = value;
  }

  List<AnimaisStruct> _crias2 = [];
  List<AnimaisStruct> get crias2 => _crias2;
  set crias2(List<AnimaisStruct> value) {
    _crias2 = value;
  }

  void addToCrias2(AnimaisStruct value) {
    crias2.add(value);
  }

  void removeFromCrias2(AnimaisStruct value) {
    crias2.remove(value);
  }

  void removeAtIndexFromCrias2(int index) {
    crias2.removeAt(index);
  }

  void updateCrias2AtIndex(
    int index,
    AnimaisStruct Function(AnimaisStruct) updateFn,
  ) {
    crias2[index] = updateFn(_crias2[index]);
  }

  void insertAtIndexInCrias2(int index, AnimaisStruct value) {
    crias2.insert(index, value);
  }

  DateTime? _filtroDataHoje;
  DateTime? get filtroDataHoje => _filtroDataHoje;
  set filtroDataHoje(DateTime? value) {
    _filtroDataHoje = value;
  }

  int _rangeIni = 0;
  int get rangeIni => _rangeIni;
  set rangeIni(int value) {
    _rangeIni = value;
  }

  int _rangeFim = 999;
  int get rangeFim => _rangeFim;
  set rangeFim(int value) {
    _rangeFim = value;
  }

  int _totalCidades = 5571;
  int get totalCidades => _totalCidades;
  set totalCidades(int value) {
    _totalCidades = value;
  }

  int _indexCidades = 0;
  int get indexCidades => _indexCidades;
  set indexCidades(int value) {
    _indexCidades = value;
  }

  int _indexInsertCidades = 0;
  int get indexInsertCidades => _indexInsertCidades;
  set indexInsertCidades(int value) {
    _indexInsertCidades = value;
  }

  String _cidadeSelecionada = '';
  String get cidadeSelecionada => _cidadeSelecionada;
  set cidadeSelecionada(String value) {
    _cidadeSelecionada = value;
  }

  String _ordenacaoRebanho = '';
  String get ordenacaoRebanho => _ordenacaoRebanho;
  set ordenacaoRebanho(String value) {
    _ordenacaoRebanho = value;
  }

  String _ordenacaoRebanhoTipo = '';
  String get ordenacaoRebanhoTipo => _ordenacaoRebanhoTipo;
  set ordenacaoRebanhoTipo(String value) {
    _ordenacaoRebanhoTipo = value;
  }

  String _ordenacaoPropriedade = '';
  String get ordenacaoPropriedade => _ordenacaoPropriedade;
  set ordenacaoPropriedade(String value) {
    _ordenacaoPropriedade = value;
  }

  String _ordenacaoPropTipo = '';
  String get ordenacaoPropTipo => _ordenacaoPropTipo;
  set ordenacaoPropTipo(String value) {
    _ordenacaoPropTipo = value;
  }

  int _totalSanidades = 0;
  int get totalSanidades => _totalSanidades;
  set totalSanidades(int value) {
    _totalSanidades = value;
  }

  int _indexSanidadePaginacao = 0;
  int get indexSanidadePaginacao => _indexSanidadePaginacao;
  set indexSanidadePaginacao(int value) {
    _indexSanidadePaginacao = value;
  }

  bool _visbilidadeProgressBarSan = false;
  bool get visbilidadeProgressBarSan => _visbilidadeProgressBarSan;
  set visbilidadeProgressBarSan(bool value) {
    _visbilidadeProgressBarSan = value;
  }

  DateTime? _dateDefault = DateTime.fromMillisecondsSinceEpoch(7258042800000);
  DateTime? get dateDefault => _dateDefault;
  set dateDefault(DateTime? value) {
    _dateDefault = value;
    value != null
        ? prefs.setInt('ff_dateDefault', value.millisecondsSinceEpoch)
        : prefs.remove('ff_dateDefault');
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

Color? _colorFromIntValue(int? val) {
  if (val == null) {
    return null;
  }
  return Color(val);
}
