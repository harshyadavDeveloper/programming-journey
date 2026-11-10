/*
========================================================
   FLUTTER BLOC — DAY 06: API CALL WITH BLOC
========================================================

Video covered: playlist video 10 (post list from an API)

Topics:
- Repository + Bloc + dependency injection
- try/catch inside a handler
- Emitting loading / success / failure
- What the Bloc sees vs what the repository decides
- Registering handlers with on<EventType>

IMPORTANT:
- Everything in this file is predict-and-explain. All
  code sits inside comments.
- Only Bloc behaviour is tested. Nothing about http or JSON.
- Assume these shapes (your real files may differ slightly):

  abstract class PostBlocEvent extends Equatable { ... }
  class PostFetched extends PostBlocEvent { ... }

  class PostBlocState extends Equatable {
    final PostStatus postStatus;       // default PostStatus.loading
    final List<PostModel> postList;    // default const []
    final String errorMessage;         // default ''
    // props => [postStatus, postList, errorMessage]
  }

  class PostBloc extends Bloc<PostBlocEvent, PostBlocState> {
    final PostRepository _postRepository;

    PostBloc(this._postRepository) : super(const PostBlocState()) {
      on<PostBlocEvent>(fetchPostHandler);
    }

    Future<void> fetchPostHandler(
      PostBlocEvent event,
      Emitter<PostBlocState> emit,
    ) async {
      try {
        final val = await _postRepository.fetchPost();
        emit(state.copyWith(
          postStatus: PostStatus.success,
          errorMessage: 'success',
          postList: val,
        ));
      } catch (err) {
        emit(state.copyWith(
          postStatus: PostStatus.failure,
          errorMessage: err.toString(),
        ));
      }
    }
  }
*/

/*
========================================================
Q1. UMBRELLA THEORY — API CALLS WITH BLOC
========================================================

Explain this as if answering an interview question:
"How would you make an API call using Bloc?"

Cover these points:
- What does each layer do: model, repository, Bloc, UI?
  Which layer knows about http and JSON, and which does not?
- How does PostBloc get its repository? Where is the real
  object created?
- Which status is the initial state, and which statuses does
  the handler actually emit? Is loading ever emitted by the
  handler today?
- Where does try/catch sit, and why does the failure
  branch now work (compare Day 05 Q4)?
- Why not call the repository from the widget directly?

Your answer:

First, I create a model class that represents the structure of the API response. It acts as a blueprint for converting the JSON response into Dart objects.

Next, I create a repository layer, where I handle the API calls, HTTP requests, and JSON parsing. The repository returns the parsed model data to the Bloc, 
keeping the API-related logic separate from the UI and business logic.

Then, I create the Bloc events and states. Events represent actions or requests, such as fetching posts, while states represent the different conditions of 
the application, such as loading, success, or failure.

In the Bloc, I register an event handler that listens for the fetch event, calls the repository, and emits a new state containing the retrieved data when successful, 
or an error message when something goes wrong.

Finally, in the UI, I use `BlocBuilder` to listen to state changes and rebuild the interface accordingly. I display a loading indicator while the data is loading, 
the actual list when the request succeeds, and an error message if it fails.

In my current implementation, the initial state is already set to loading through the Bloc's constructor. So I don't explicitly emit a loading state inside 
the event handler. The handler only emits success or failure after the API request completes.

This separation ensures that the UI doesn't need to know about HTTP requests or JSON parsing, making the application easier to maintain, test, and scale.

*/

/*
========================================================
Q2. THE CONTRACT BETWEEN REPOSITORY AND BLOC
========================================================

Assume the repository returns an empty list when the
server replies with an error code (for example 500), and
throws only for network problems such as no internet.
*/
/*
Questions:
- The server replies with a 500. What status does the Bloc
  emit, and what does the screen show?
- Why can't the Bloc detect this case by checking whether
  the list is empty?
- When does the Bloc emit failure at all? What does that
  tell you about what the Bloc relies on the repository to
  do?
- Where would you fix this, and why there? Describe it,
  no code needed.

Your answer:
The repository is responsible for handling API responses and identifying errors. If the server returns a 500 status but the repository converts it into an empty 
list, the Bloc treats it as a successful response because it receives valid data and no exception is thrown.
We cannot identify failure just by checking whether the list is empty, because an empty list can also represent a successful response with no records.
The Bloc emits failure only when an exception is thrown and reaches its catch block. Therefore, I would fix this in the repository by properly checking the 
HTTP response status and throwing an exception for unsuccessful responses. This allows the Bloc to handle the failure and emit the appropriate state

*/

/*
========================================================
Q3. RETRY — WHAT THE USER SEES
========================================================

A Retry button is added to the failure screen. Tapping it
adds PostFetched again. The handler is exactly as shown
at the top.

Scenario: the first fetch fails with a network error. The
user taps Retry.
*/
/*
Questions:
- Part A: while the retry request is in flight, which
  status does the screen show, and why?
- Part B: the retry fails with exactly the same error
  message. Is the new failure emit delivered to the UI?
  Compare the two states field by field.
- Part C: a teammate adds this as the first line of the
  handler:

      emit(state.copyWith(postStatus: PostStatus.loading));

  Repeat A and B. What changes on screen? Is the second
  identical failure dropped now? Explain by comparing the
  states emitted one after another.

Your answer:
Bloc compares a newly emitted state with the current state to determine whether it is different.
If a retry fails with the same error message and no loading state is emitted in between, the new failure state is identical to the current failure state. 
Therefore, Bloc suppresses that emission, and the UI doesn't receive a new state.
However, if I emit a loading state before starting the retry request, the sequence becomes Failure → Loading → Failure.
Now, when the retry fails, the new failure state is compared with the current loading state, not the previous failure state. Since they are different, 
the failure state is emitted successfully.
This means Bloc compares consecutive states rather than checking whether a particular state was emitted at some point in the past.

*/

/*
========================================================
Q4. REGISTERING ON THE BASE TYPE
========================================================

Today the Bloc registers:

    on<PostBlocEvent>(fetchPostHandler);

Tomorrow a teammate adds a second event:

    class PostRefreshed extends PostBlocEvent {}

and a second handler:

    on<PostRefreshed>(refreshHandler);

Scenario: the user triggers PostRefreshed.
*/
/*
Questions:
- Which handlers run for PostRefreshed? Why?
- What is the side effect on the app?
- What is the fix, and what rule does it teach about
  on<...> registrations?

Your answer:
Initially, I mistakenly registered my event handler using the base event class, `PostBlocEvent`, instead of the specific event class, `PostFetched`.
This worked initially because I had only one event in my Bloc. However, if I introduced another event, such as `PostRefreshed`, which also extends 
`PostBlocEvent`, dispatching it would match both the base-type registration and the specific event registration.
As a result, both handlers could execute, potentially triggering duplicate API requests and unexpected state emissions.
The fix is to register handlers using their specific event types, such as `on<PostFetched>` and `on<PostRefreshed>`.
The key takeaway is that event handlers should generally be registered against specific event types rather than their common parent type, unless handling 
all child events is intentional.

*/

void main() {}

/*
========================================================
                  END OF DAY 06
========================================================
*/
