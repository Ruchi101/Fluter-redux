import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(new MyApp());

class AppState {
  int i;

  AppState({this.i});

  AppState copywith(int j) {
    return AppState(i: j ?? this.i);
  }
}

class increase {}

AppState reducer(AppState prev, action) {
  if (action is increase) {
    print("Reducer Called with $action");
    return prev.copywith(prev.i + 1);
  }
  return prev;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Store store = Store<AppState>(reducer, initialState: AppState(i: 10));
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: StoreConnector<AppState, int>(
              converter: (Store store) {
                return store.state.i;
              },

              builder: (context,index){
                return Text("$index");
              },
            ),
          ),

          floatingActionButton: StoreConnector<AppState,Store>(
            converter: (Store store){return store;},
            builder: (context,store){
              return FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){

                  print("Dispatched");
                  store.dispatch(increase());
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
