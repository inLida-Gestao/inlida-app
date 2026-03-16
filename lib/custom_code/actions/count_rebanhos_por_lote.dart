// Automatic FlutterFlow imports
import '/backend/sqlite/sqlite_manager.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int> countRebanhosPorLote(String loteNome) async {
  try {
    final db = SQLiteManager.instance.database;

    final result = await db.rawQuery('''
      SELECT COUNT(*) as quantidade
      FROM local_rebanho 
      WHERE loteNome = ?
      AND (deletado = 'NAO')
    ''', [loteNome]);

    if (result.isNotEmpty) {
      return result.first['quantidade'] as int;
    }

    return 0;
  } catch (e) {
    print('Erro ao buscar quantidade de rebanhos: $e');
    return 0;
  }
}
