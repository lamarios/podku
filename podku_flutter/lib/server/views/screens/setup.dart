import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:podku_flutter/server/states/server.dart';

import '../../../utils.dart';

class ServerSetupScreen extends StatelessWidget {
  const ServerSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1b3a3a),
              Color(0xFF0f2626),
            ],
            begin: .topLeft,
            end: .bottomRight,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<ServerCubit, ServerState>(
            builder: (context, state) {
              final cubit = context.read<ServerCubit>();
              return Padding(
                padding: .all(pu4),
                child: Column(
                  crossAxisAlignment: .stretch,
                  mainAxisAlignment: .center,
                  children: [
                    SvgPicture.asset('assets/podku-icon-no-background.svg', width: 200,height: 200,),
                    Text('Server URL'),
                    TextField(
                      controller: cubit.controller,
                    ),
                    Align(alignment: .centerRight,
                    child: TextButton(onPressed: () async {
                      if(await cubit.setServerUrl(cubit.controller.text) && context.mounted){
                        context.go('/episodes');
                      }
                    }, child: Text('Go')),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
