import 'package:crypto_bloc_flutter/models/coin_model.dart';
import 'package:crypto_bloc_flutter/repositories/crypto_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cryptoRepository = CryptoRepository();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Coins'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Colors.grey[900],
            ],
          ),
        ),
        child: FutureBuilder(
          future: _cryptoRepository.getTopCoins(page: _page),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                ),
              );
            }
            final List<Coin> coins = snapshot.data;
            return RefreshIndicator(
              color: Theme.of(context).accentColor,
              onRefresh: () async {
                setState(() => _page = 0);
              },
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                final coin = coins[index];
                FlutterMoneyFormatter fmf =
                    FlutterMoneyFormatter(amount: coin.price);

                return ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${++index}',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    coin.fullName,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    coin.name,
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    '${fmf.output.withoutFractionDigits} 원',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
