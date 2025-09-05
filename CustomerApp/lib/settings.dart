import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projectst/Pages/changePassword.dart';
import 'package:provider/provider.dart';
import '../Themes/le_provider.dart';
import '../../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(S.of(context).SettingsTitle),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(S.of(context).General,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 12),
        ListTile(
          title: Text(S.of(context).Language),
          trailing: CupertinoSwitch(
              value: Provider.of<LeProvider>(context, listen: false).isEnLocale,
              onChanged: (value) =>
                  Provider.of<LeProvider>(context, listen: false)
                      .toggleLocale()),
          leading: const Icon(Icons.language),
        ),
        ListTile(
          title: Text(S.of(context).Theme),
          trailing: CupertinoSwitch(
              value: Provider.of<LeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) =>
                  Provider.of<LeProvider>(context, listen: false)
                      .toggleTheme()),
          leading: const Icon(Icons.dark_mode),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(S.of(context).privacy,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 12),
        ListTile(
          title: Text(S.of(context).Passwordch),
          trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ),
                );
              }),
          leading: const Icon(Icons.privacy_tip),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(S.of(context).hs,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 12),
        ListTile(
          title: Text(S.of(context).about),
          trailing: const Icon(Icons.arrow_forward_ios),
          leading: const Icon(Icons.info_outline_rounded),
        ),
      ]),
    );
  }
}
