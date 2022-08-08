import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) {
          return Auth();
        }),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, previousItems) {
            if (previousItems != null) {
              previousItems.updateToken(
                auth.token ?? '',
                auth.userId ?? '',
              );
              return previousItems;
            } else {
              return Products();
            }
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) {
            return Cart();
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, previousOrders) {
            if (previousOrders != null) {
              previousOrders.updateAuth(
                auth.token ?? '',
                auth.userId ?? '',
              );
              return previousOrders;
            } else {
              return Orders();
            }
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: "MyShop",
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.purple,
                secondary: Colors.deepOrange,
              ),
              fontFamily: "Lato",
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
            ),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: ((context, loginSnapshot) {
                      if (loginSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    }),
                  ),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) {
                return const ProductsOverviewScreen();
              },
              ProductDetailScreen.route: (ctx) {
                return const ProductDetailScreen();
              },
              CartScreen.routeName: (ctx) {
                return const CartScreen();
              },
              OrdersScreen.routeName: (ctx) {
                return const OrdersScreen();
              },
              UserProductsScreen.routeName: (ctx) {
                return const UserProductsScreen();
              },
              EditProductScreen.routeName: (ctx) {
                return const EditProductScreen();
              }
            },
            initialRoute: "/",
          );
        },
      ),
    );
  }
}
