/*
========================================================
   FLUTTER BLOC — DAY 08: LOGIN FORM (BlocListener + SCOPE)
========================================================

Videos covered: playlist videos 12 and 13

Topics:
- Provider scope and lifetime
- BlocListener and listenWhen
- BlocBuilder vs BlocListener
- Which widgets rebuild, which listeners fire
- Why the loading emit matters
- BuildContext and where the provider sits

IMPORTANT:
- Everything in this file is predict-and-explain. All
  code sits inside comments.
- Only Bloc behaviour is tested. Nothing about http, JSON
  or text fields.
- Assume this state shape (your real file may differ):

  enum LoginState { initial, loading, success, error }

  class LoginBlocState extends Equatable {
    final String email;            // default ''
    final String password;         // default ''
    final String message;          // default ''
    final LoginState loginStatus;  // default LoginState.initial
    // props => [email, password, message, loginStatus]
  }

- The submit handler, trimmed:

  void _handleLoginApi(SubmitForm event, Emitter<LoginBlocState> emit) async {
    emit(state.copyWith(loginStatus: LoginState.loading));
    try {
      final response = await <post request using state.email and state.password>;
      if (<status is 200>) {
        emit(state.copyWith(
            loginStatus: LoginState.success, message: 'Login Success'));
      } else {
        emit(state.copyWith(
            loginStatus: LoginState.error, message: <server error text>));
      }
    } catch (e) {
      emit(state.copyWith(
          loginStatus: LoginState.error, message: e.toString()));
    }
  }

- The screen, summarised:
  * LoginScreen is a StatefulWidget. initState creates
    _loginBloc = LoginBloc(). build returns
    BlocProvider(create: (_) => _loginBloc, child: Scaffold(...)).
  * Email field: BlocBuilder with buildWhen
    prev.email != curr.email. Its TextFormField does not read
    state. onChanged adds EmailChanged.
  * Password field: the same with password and PasswordChanged.
  * Login button: a BlocListener with
    listenWhen prev.loginStatus != curr.loginStatus, whose
    listener shows a snackbar for loading, success and error.
    Its child is a BlocBuilder with buildWhen: (p, c) => false,
    which builds an ElevatedButton whose onPressed runs
    context.read<LoginBloc>().add(SubmitForm()). The context
    is the one given by that BlocBuilder's builder.
*/

/*
========================================================
Q1. UMBRELLA THEORY — BlocBuilder vs BlocListener
========================================================

Explain this as if answering an interview question:
"What is the difference between BlocBuilder and
BlocListener, and between buildWhen and listenWhen?"

Cover these points:
- What does each widget do, and what does each callback
  return?
- Why can't a snackbar or navigation live in the builder?
- Is the listener called for the initial state? Does it
  rebuild its child?
- There are two filtering layers between emit and the
  screen. What are they, and who owns each?
- Which widget would you use for each of these:
    (i)   showing a spinner while loading
    (ii)  showing a snackbar on error
    (iii) navigating to the home screen on success
    (iv)  displaying the typed email in a Text widget

Your answer:
Both BlocBuilder and BlocListener react to BLoC state changes, but they serve different purposes.
BlocBuilder is used to rebuild the UI based on the current state, such as displaying a loading indicator, updating a button, or showing data. 
BlocListener, on the other hand, is used to handle side effects like showing a SnackBar, navigating to another screen, or displaying a dialog.

Both have filtering mechanisms. BlocBuilder uses buildWhen, which returns a boolean to determine whether the builder should rebuild for a particular 
state transition. BlocListener uses listenWhen, which also returns a boolean to determine whether its listener should execute.

We shouldn't put navigation or SnackBars inside BlocBuilder because builders can run multiple times, and we don't want side effects to occur repeatedly 
during UI rebuilding.

BlocListener is not called for the initial state. It reacts to subsequent state changes, and it doesn't rebuild its child when the listener executes.

So, I would use BlocBuilder to show a loading spinner and display the typed email, while BlocListener would be used to show a SnackBar on error or navigate 
to the home screen on success.

*/

/*
========================================================
Q2. WHO REBUILDS, WHO FIRES
========================================================

Scenario, in this order:
  1. The login screen opens. (The builders build once.)
  2. The user types three characters in the email field.
  3. The user types two characters in the password field.
  4. The user taps Login and the server rejects it
     (status becomes error).
*/
/*
Questions:
- Give totals for each of these:
    (a) the email BlocBuilder builder runs
    (b) the password BlocBuilder builder runs
    (c) the button BlocBuilder builder runs
    (d) the BlocListener listener is invoked
- Does the email TextFormField read anything from state?
  Then what does the buildWhen on the email BlocBuilder
  change for the user?
- When is a BlocBuilder actually needed, and when is it
  just extra?

Your answer:

*/

/*
========================================================
Q3. WHY THE LOADING EMIT MATTERS
========================================================

Scenario: the user submits the form with a wrong password
and the server rejects it with the SAME message both
times. The user taps Login twice, one after the other,
waiting for each result.
*/
/*
Questions:
- Part A (code as written): how many times is the listener
  invoked across the two submits? List the invocations in
  order.
- Part B: delete the first line of the handler
  (emit loading). How many times is the listener invoked
  now? Which of the two filtering layers from Q1 stops the
  second failure, and does it matter if the user edited
  the password between the two taps?
- Part C: still without the loading emit, the second
  failure returns a DIFFERENT message. Is the state
  delivered? Is the listener invoked? What does the user
  see, and what one change to listenWhen would fix it?

Your answer:

*/

/*
========================================================
Q4. SCOPE, LIFETIME AND CONTEXT
========================================================

Questions:
- In this screen the Bloc is created in the State and
  passed in as BlocProvider(create: (_) => _loginBloc ...).
  Who closes the Bloc when the screen is removed? Would it
  be different with BlocProvider.value?
- context.read<LoginBloc>() inside the button's onPressed
  works because it uses the context given by the
  BlocBuilder's builder. Suppose the ElevatedButton were
  placed directly in the Column and onPressed used the
  context of the screen's own build method. What happens,
  and why? (Where does that context sit relative to
  BlocProvider?)
- The user logs in successfully, leaves the screen and
  comes back later. What state does the form's Bloc hold
  in (a) this screen-level setup, and (b) if LoginBloc had
  been provided at the app root? Is RAM the main reason to
  avoid root-level providers?

Your answer:

*/

void main() {}

/*
========================================================
                  END OF DAY 08
========================================================
*/
