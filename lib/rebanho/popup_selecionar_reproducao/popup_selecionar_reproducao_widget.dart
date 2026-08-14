// Popup exibido ao cadastrar um nascimento quando nenhuma inseminação foi
// encontrada na janela automática de gestação (275 a 305 dias antes do
// nascimento), mas existem reproduções (Inseminação ou Monta Natural) na
// janela estendida (306 a 350 dias). O usuário escolhe manualmente qual
// reprodução originou o nascimento — ou fecha o popup sem vincular nada.
import '/backend/utils/reproducao_parto_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class PopupSelecionarReproducaoWidget extends StatelessWidget {
  const PopupSelecionarReproducaoWidget({
    super.key,
    required this.candidatos,
    required this.dataNascimento,
  });

  final List<CandidatoReproducao> candidatos;
  final DateTime dataNascimento;

  bool _temReprodutor(CandidatoReproducao candidato) {
    final num = candidato.numReprodutor;
    return num != null && num.isNotEmpty && num != 'null';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480.0, maxHeight: 560.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Selecionar reprodução do nascimento',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: FlutterFlowTheme.of(context).accent3,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                'Nenhuma inseminação foi encontrada no período padrão de gestação (275 a 305 dias). '
                'Selecione abaixo a reprodução que originou este nascimento, se houver.',
                style: FlutterFlowTheme.of(context).bodySmall,
              ),
              const SizedBox(height: 12.0),
              Flexible(
                child: candidatos.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'Nenhuma reprodução foi encontrada nesse período.',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: candidatos.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8.0),
                        itemBuilder: (context, index) {
                          final candidato = candidatos[index];
                          final dias = dataNascimento
                              .difference(candidato.dataReferencia)
                              .inDays;
                          final temReprodutor = _temReprodutor(candidato);
                          final nomeReprodutor = candidato.nomeReprodutor;
                          final temNome = nomeReprodutor != null &&
                              nomeReprodutor.isNotEmpty &&
                              nomeReprodutor != 'null';

                          return InkWell(
                            onTap: () => Navigator.pop(context, candidato),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        candidato.tipoReproducao ??
                                            'Reprodução',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              fontWeight: FontWeight.w600,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      Text(
                                        '$dias dias entre reprodução e parto',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Data: ${dateTimeFormat('d/M/y', candidato.dataReferencia)}',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    temReprodutor
                                        ? 'Reprodutor: ${candidato.numReprodutor}${temNome ? ' • $nomeReprodutor' : ''}'
                                        : 'Sem reprodutor vinculado',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12.0),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Não vincular'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
