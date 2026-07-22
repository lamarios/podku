import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/error_listener.dart';
import 'package:podku/utils/views/components/forced_dark_theme.dart';

class ServerSetupScreen extends StatelessWidget {
  const ServerSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return ForcedDarkThemeBuilder(
      builder: (context) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1b3a3a), Color(0xFF0f2626)],
                begin: .topLeft,
                end: .bottomRight,
              ),
            ),
            child: SafeArea(
              child: ErrorHandler<ServerCubit, ServerState>(
                child: BlocBuilder<ServerCubit, ServerState>(
                  builder: (context, state) {
                    final cubit = context.read<ServerCubit>();
                    return Padding(
                      padding: .all(pu4),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        mainAxisAlignment: .center,
                        children: [
                          SvgPicture.asset('assets/podku-icon-no-background.svg', width: 200, height: 200),
                          Text(locals.serverUrl),
                          TextField(controller: cubit.controller),
                          Align(
                            alignment: .centerRight,
                            child: state.loading
                                ? SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Padding(padding: .all(pu), child: LoadingIndicator()),
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      if ((await cubit.setServerUrl(cubit.controller.text)) && context.mounted) {
                                        context.go('/episodes');
                                      }
                                    },
                                    child: Text(locals.go),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
