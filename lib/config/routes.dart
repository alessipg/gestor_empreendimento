import 'package:go_router/go_router.dart';
import 'package:gestor_empreendimento/views/pages/home.dart';
import 'package:gestor_empreendimento/views/pages/menu.dart';
import 'package:gestor_empreendimento/views/pages/receitas.dart';
import 'package:gestor_empreendimento/views/pages/mercadorias.dart';
import 'package:gestor_empreendimento/views/pages/insumos.dart';
import 'package:gestor_empreendimento/views/pages/add_insumo.dart';

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Home()),
    GoRoute(path: '/menu', builder: (context, state) => const Menu()),
    GoRoute(path: '/receitas', builder: (context, state) => const Receitas()),
    GoRoute(
      path: '/mercadorias',
      builder: (context, state) => const Mercadorias(),
    ),
    GoRoute(path: '/insumos', builder: (context, state) => const Insumos()),
    GoRoute(path: '/insumos/add', builder: (context, state) => const AddInsumo()),
  ],
);
