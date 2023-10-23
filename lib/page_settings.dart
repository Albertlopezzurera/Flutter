import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatelessWidget {
  List<String> listLanguages = ['English', 'Spanish', 'French', 'Italian'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General Settings'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text('Select a Language'),
                        children: listLanguages.map((language) {
                          return SimpleDialogOption(
                            onPressed: () {
                              // Aquí puedes realizar la lógica para cambiar el idioma
                              // por ejemplo, puedes usar SharedPreferences o algún otro método.
                              // Recuerda que debes mantener el idioma seleccionado en algún lugar
                              // y aplicar el cambio en toda la aplicación.
                              Navigator.pop(context);
                            },
                            child: Text(language),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.next_week_outlined),
        onPressed: () {},
      ),
    );
  }
}
