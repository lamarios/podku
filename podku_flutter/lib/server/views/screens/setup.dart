import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/error_listener.dart';
import 'package:podku/utils/views/components/forced_dark_theme.dart';

class ServerSetupScreen extends StatelessWidget {
  const ServerSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isMobile = BreakPoint.get(context) == .mobile;

    return ForcedDarkThemeBuilder(
      builder: (context) {
        var background = LinearGradient(
          colors: [Color(0xFF1b3a3a), Color(0xFF0f2626)],
          begin: .topLeft,
          end: .bottomRight,
        );
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: isMobile ? background : null, color: isMobile ? null : colors.surface),
            child: SafeArea(
              child: ErrorHandler<ServerCubit, ServerState>(
                showAsSnack: true,
                child: BlocBuilder<ServerCubit, ServerState>(
                  builder: (context, state) {
                    final cubit = context.read<ServerCubit>();
                    return ConditionalWrap(
                      wrapIf: !isMobile,
                      wrapper: (child) => Center(
                        child: Container(
                          width: 400,
                          height: 350,
                          decoration: BoxDecoration(gradient: background, borderRadius: .circular(pu5)),
                          child: child,
                        ),
                      ),
                      child: Padding(
                        padding: .all(pu4),
                        child: Column(
                          crossAxisAlignment: .stretch,
                          mainAxisAlignment: .center,
                          children: [
                            SvgPicture.asset('assets/podku-icon-no-background.svg', width: 200, height: 200),
                            Text(locals.serverUrl),
                            TextField(controller: cubit.controller),
                            SizedBox(
                              height: 50,
                              child: Align(
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
                            ),
                          ],
                        ),
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
