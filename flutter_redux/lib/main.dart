import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AuthState {
  bool isLogin;
  String account;

  AuthState({this.isLogin: false, this.account});
}

class MainPageState {
  int counter;

  MainPageState({this.counter: 0});
}

class AppState {
  AuthState authState;
  MainPageState mainPageState;

  AppState({this.authState, this.mainPageState});
}

class LoginSuccessAction {
  String account;

  LoginSuccessAction({this.account});
}

enum Actions{
  Increase,
  LogoutAction,
}

AppState mainReducer(AppState state, dynamic action){

  if (Actions.Increase == action){
    state.mainPageState.counter += 1;
  } else if (Actions.LogoutAction == action) {
    state.authState.isLogin = false;
    state.authState.account = null;
  } else if (action is LoginSuccessAction) {
    state.authState.isLogin = true;
    state.authState.account = action.account;
  }

  return state;
}

void main() {
  Store<AppState> store = new Store<AppState>(mainReducer, initialState: AppState(authState: AuthState(), mainPageState: MainPageState()));
  runApp(new MyApp(store: store,));
}

class MyApp extends StatelessWidget {

  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(store: store, child: new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  new StoreConnector(builder: (BuildContext context, AppState appState){
        return new MyHomePage(title: 'Flutter Demo Home Page', appState: appState,);
      }, converter: (Store<AppState> store){
        return store.state;
      }) ,
    ));
  }
}

class MyHomePage extends StatelessWidget {

  MyHomePage({Key key, this.title,this.appState}) : super(key: key);
  final String title;
  final AppState appState;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              appState.mainPageState.counter.toString(),
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
            _buildLoginButton(),
          ],
        ),
      ),
      floatingActionButton: StoreConnector<AppState, VoidCallback>(builder: (BuildContext context,VoidCallback callback) {
        return FloatingActionButton(
          onPressed:callback,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        );

      }, converter: (Store<AppState> store){
        return () => store.dispatch(Actions.Increase);
      }),
    );
  }

  Widget _buildLoginButton() {
    Widget loginButton;
    String account = appState.authState.account;
    if (appState.authState.isLogin) {
      loginButton = StoreConnector(
          key: ValueKey("login"),
          builder: (BuildContext context, VoidCallback logout) {
        return RaisedButton(onPressed: logout, child: Text("您好：$account，点击退出"),);
      }, converter: (Store<AppState> store) {
        return () => store.dispatch(Actions.LogoutAction);
      });
    } else {
      loginButton = StoreConnector(
          key: ValueKey("logout"),
          builder: (BuildContext context, VoidCallback login) {
        return RaisedButton(onPressed: login, child: Text("登录"),);
      }, converter: (Store<AppState> store) {
        return () => store.dispatch(LoginSuccessAction(account: "zlove"));
      });
    }
    return loginButton;
  }
}


