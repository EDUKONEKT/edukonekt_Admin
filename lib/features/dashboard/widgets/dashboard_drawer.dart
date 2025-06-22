import 'package:flutter/material.dart';
//import '../../schoolfee/screen/installment_definition_screen.dart';


class CollapsibleDrawer extends StatefulWidget {
  const CollapsibleDrawer({super.key});

  @override
  CollapsibleDrawerState createState() => CollapsibleDrawerState();
}

class CollapsibleDrawerState extends State<CollapsibleDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isCollapsed)
          Container(
            width: 200,
            color: Theme.of(context).primaryColor,
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                  ),
                  child: Center(
                    child: Text(
                      'EDUKONEKT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _drawerListTile('Élèves', Icons.people, () {}),
                _drawerListTile('Parents', Icons.group, () {}),
                _drawerListTile('Enseignants', Icons.school, () {}),
                _drawerListTile('Notes', Icons.grade, () {}),
                _drawerListTile('Bulletins', Icons.receipt_long, () {}),
                _drawerListTile('Classes', Icons.class_, () {
                 /*Navigator.of(context).push(
                 MaterialPageRoute(builder: (context) =>  ClassListScreen()),
                 );*/
                }),
                _drawerListTile('Cours', Icons.book, () {}),
                _drawerListTile('Emploi du temps', Icons.schedule, () {}),
                _drawerListTile('Calendrier', Icons.calendar_month, () {}),
                _drawerListTile('Messagerie', Icons.message, () {}),
                _drawerListTile('Paramètres', Icons.settings,  () {
                  
                }),
                ListTile(
                  title: const Text(
                    'VERSION 1.0.0',
                    style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        IconButton(
          icon: Icon(_isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            setState(() {
              _isCollapsed = !_isCollapsed;
            });
          },
        ),
      ],
    );
  }

  Widget _drawerListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontFamily: 'Roboto')),
      onTap: onTap,
    );
  }
}