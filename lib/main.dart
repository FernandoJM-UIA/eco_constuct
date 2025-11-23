import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/mock_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/impact_repository_impl.dart';
import 'data/repositories/material_repository_impl.dart';
import 'data/repositories/messaging_repository_impl.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/impact_provider.dart';
import 'presentation/providers/material_provider.dart';
import 'presentation/providers/messaging_provider.dart';
import 'presentation/providers/payment_provider.dart';
import 'presentation/routes/route_arguments.dart';
import 'presentation/screens/chat_screen.dart';
import 'presentation/screens/chat_tab_screen.dart';
import 'presentation/screens/favorites_screen.dart';
import 'presentation/screens/ai_chat_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/impact_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/map_screen.dart';
import 'presentation/screens/material_detail_screen.dart';
import 'presentation/screens/material_form_screen.dart';
import 'presentation/screens/payment_screen.dart';
import 'presentation/screens/register_screen.dart';

void main() {
  // Initialize Data Layer
  final mockDataSource = MockDataSource();
  
  final authRepository = AuthRepositoryImpl(mockDataSource);
  final materialRepository = MaterialRepositoryImpl(mockDataSource);
  final messagingRepository = MessagingRepositoryImpl(mockDataSource, authRepository);
  final paymentRepository = PaymentRepositoryImpl(mockDataSource);
  final impactRepository = ImpactRepositoryImpl(mockDataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => MaterialProvider(materialRepository)),
        ChangeNotifierProvider(create: (_) => MessagingProvider(messagingRepository)),
        ChangeNotifierProvider(create: (_) => PaymentProvider(paymentRepository)),
        ChangeNotifierProvider(create: (_) => ImpactProvider(impactRepository)),
        Provider.value(value: impactRepository), // Inject repository for direct usage if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoConstruct',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/favorites': (_) => const FavoritesScreen(),
        '/chatTab': (_) => const ChatTabScreen(),
        '/aiChat': (_) => const AiChatScreen(),
        '/addMaterial': (_) => const MaterialFormScreen(),
        '/impact': (_) => const ImpactScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/materialDetail') {
          final args = settings.arguments as MaterialDetailArgs;
          return MaterialPageRoute(
            builder: (_) => MaterialDetailScreen(item: args.item),
          );
        } else if (settings.name == '/chat') {
          final args = settings.arguments as ChatScreenArgs;
          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              otherUserId: args.otherUserId,
              materialId: args.materialId,
            ),
          );
        } else if (settings.name == '/payment') {
          final args = settings.arguments as PaymentScreenArgs;
          return MaterialPageRoute(
            builder: (_) => PaymentScreen(material: args.material),
          );
        } else if (settings.name == '/map') {
          final args = settings.arguments as MapScreenArgs;
          return MaterialPageRoute(
            builder: (_) => MapScreen(item: args.item),
          );
        }
        return null;
      },
    );
  }
}
