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

The BlocBuilder builder returns a Widget. The BlocListener listener returns nothing (void). That is why the listener can only do things and can’t draw anything.

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
- The initial screen build executes all three BlocBuilder builders once.
After that:
Typing three characters in the email field triggers three email state changes. The email builder rebuilds three additional times.
Typing two characters in the password field triggers two password state changes. The password builder rebuilds twice.
When Login is tapped, the Bloc emits loading and then error states. The BlocListener is invoked twice.
Therefore, the final totals are:
Email BlocBuilder: 4
Password BlocBuilder: 3
Button BlocBuilder: 1
BlocListener: 2

No. The email TextFormField only dispatches an EmailChanged event through context.read<LoginBloc>(). It doesn't consume state.email to display its value.
The TextFormField manages its displayed text internally.
Therefore, rebuilding the email field whenever its state changes is unnecessary in this implementation.
The buildWhen condition restricts rebuilds to email-related state changes, preventing unnecessary rebuilds caused by password or login-status changes.
However, the email field doesn't actually need those rebuilds.

BlocBuilder is needed when a widget's UI depends on Bloc state and must update when that state changes.
For example:
Displaying validation errors.
Showing a loading indicator.
Enabling or disabling a button.
Displaying success or error messages within the UI.

It is unnecessary when a widget doesn't consume Bloc state and doesn't need to change based on state.
In such cases, using BlocBuilder only adds unnecessary rebuild logic.

BlocBuilder rebuilds UI based on state changes.
BlocListener performs one-time side effects in response to state changes, such as showing SnackBars, navigating, or displaying dialogs.
context.read() accesses the Bloc without subscribing the widget to state changes.
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
Part A: The listener is invoked 4 times across two submissions.
The sequence is:
First submission: Initial → Loading (listener invocation 1).
First submission: Loading → Error (listener invocation 2).
Second submission: Error → Loading (listener invocation 3).
Second submission: Loading → Error (listener invocation 4).
Even though both API failures return the same message, the loading state creates a state transition between the two errors.

Part B:
The listener is invoked only once.
First submission: Initial → Error (listener invocation 1).
Second submission: Error → Error (no new emission).
Bloc uses state equality (Equatable) to prevent emitting an identical state. Since the second failure has the same status, message, email and password, 
the new state equals the current state and Bloc suppresses the emission.

There are two filtering stages:

Bloc's equality check determines whether a new state is emitted.
listenWhen determines whether the listener reacts to an emitted state.
In this case, the second failure is stopped by Bloc's equality check before listenWhen gets a chance to evaluate it.

The conclusion remains the same. The password edit produces a new state, but the second failure retains that updated password. If the status and error message 
are also unchanged, the resulting state is still identical to the latest state and the emission is suppressed.

Part C: 
Suppose the first error is "Invalid password" and the second is "Account temporarily locked". 
Since the error message has changed, the new state is different according to Equatable, so Bloc emits it.
The existing listenWhen compares only login status. Both the previous and current statuses are LoginState.error, so the condition returns false.
The second error message is not displayed because the listener is not invoked.
Include the message comparison in listenWhen:
listenWhen: (prev, curr) =>
    prev.loginStatus != curr.loginStatus ||
    prev.message != curr.message,

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
When we use BlocProvider with the create constructor, it automatically manages the Bloc lifecycle and closes the Bloc when the provider is removed from the widget tree. 
However, BlocProvider.value is used to provide an existing Bloc and doesn't automatically close it.

Regarding BuildContext, a context can access a provider only if that provider is above its position in the widget tree. So, if I use the screen's own build context, 
which is above BlocProvider, it won't find the Bloc. But a descendant context, such as the one inside BlocBuilder, can access it.

Finally, if I provide a Bloc at the screen level, it gets disposed when that screen's provider is removed, and a new instance is created when the screen is 
opened again. If I provide it at the application level, the same instance can survive screen navigation. So, I choose the provider's scope based on the lifecycle 
and responsibility of the state it manages, rather than just memory consumption.

*/

void main() {}

/*
========================================================
                  END OF DAY 08
========================================================
*/
