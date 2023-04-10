import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';


class BasicAppBar extends StatelessWidget implements PreferredSizeWidget{
  final title;
  final String router; 
  const BasicAppBar({super.key, required this.title, required this.router});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            GoRouter.of(context).go(router);
          },
        ),
        title: Text(title),
      );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}