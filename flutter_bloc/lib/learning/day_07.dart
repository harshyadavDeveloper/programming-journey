/*
========================================================
   FLUTTER BLOC — DAY 07: SEARCH / FILTER IN THE POST BLOC
========================================================

Video covered: search by email in the post app

Topics:
- A SearchItem event and its handler
- Filtering lists inside a handler
- Equatable and consecutive states
- Modelling "no search" vs "no results" in state
- When state is read relative to events

IMPORTANT:
- Everything in this file is predict-and-explain. All
  code sits inside comments.
- Assume this state shape (your real file may differ
  slightly):

  class PostBlocState extends Equatable {
    final PostStatus postStatus;         // default loading
    final List<PostModel> postList;      // default const []
    final List<PostModel> tempPostList;  // default const []
    final String errorMessage;
    final String searchMessage;          // default ''
    // props => [postStatus, postList, tempPostList,
    //           errorMessage, searchMessage]
  }

- The handler, as you wrote it (comments removed):

  void _filterList(SearchItem event, Emitter<PostBlocState> emit) {
    if (event.searchTerm.isEmpty) {
      emit(state.copyWith(tempPostList: [], searchMessage: ''));
    } else {
      tempPostList = state.postList.where((ele) =>
          ele.email.toString().toLowerCase()
              .contains(event.searchTerm.toLowerCase())).toList();
      if (tempPostList.isEmpty) {
        emit(state.copyWith(
            tempPostList: tempPostList, searchMessage: 'No Data Found'));
      } else {
        emit(state.copyWith(tempPostList: tempPostList, searchMessage: ''));
      }
    }
  }

- The UI shows searchMessage if it is not empty. Otherwise
  it shows tempPostList if that is not empty, and the full
  postList if tempPostList is empty.
*/

/*
========================================================
Q1. THE PRINT THAT LAGS
========================================================

  TextFormField(
    onChanged: (val) {
      context.read<PostBloc>().add(SearchItem(val));
      print(state.tempPostList.length);
    },
  )

Here `state` is the parameter of the BlocBuilder builder
that built this widget.

Assume: the fetch has succeeded and postList has 500
posts. Searching "a" matches 120 posts and "ab" matches
15. The user types "a", waits until the screen updates,
then types "b".
*/
/*
Questions:
- What does the print show for the first keystroke? And
  for the second?
- Where does `state` in the print come from, and why does
  it not show the result of the event that was just added?
- If you replaced the print with
    print(context.read<PostBloc>().state.tempPostList.length);
  would the first keystroke print 120? Why or why not?

Your answer:
- First keystroke ("a"): 0
- Second keystroke ("ab"): 120

- state comes from the BlocBuilder builder parameter. It holds the state received during that build. add() only dispatches an event; the new state is emitted later, 
so the print uses the previously captured state.

- No. It would print 0 because bloc.state returns the currently emitted state, not the result of the newly dispatched event.

*/

/*
========================================================
Q2. "NO SEARCH" vs "NO RESULTS"
========================================================

Fill in what the state holds in each situation, and what
the screen shows:

  Situation                       tempPostList   searchMessage   Screen shows
  a) Nothing typed yet            ?              ?               ?
  b) "ab" typed, 15 matches       ?              ?               ?
  c) "zzz" typed, no matches      ?              ?               ?
*/
/*
Questions:
- Fill in the table.
- Suppose searchMessage is deleted from the state and the
  UI relies only on tempPostList. What does the screen
  show for situation (c), and why?
- What does this show about using an empty list to mean
  "not searching"?
- Describe one cleaner way to model "search is active but
  nothing matched". No code needed.

Your answer:

  Situation                       tempPostList   searchMessage   Screen shows
  a) Nothing typed yet            Empty list      Empty string     Original postList (500 posts)
  b) "ab" typed, 15 matches       15 posts        Empty string     	Filtered tempPostList
  c) "zzz" typed, no matches      Empty list      "No Data Found"   No Data Found message

- The original postList will be displayed because tempPostList is empty. It cannot distinguish between an empty list because no search was performed and an empty 
list because no results matched.

- An empty list is ambiguous. It can represent two different situations:
- Search is inactive.
- Search is active, but no results were found.
Therefore, an empty list alone is insufficient to represent both states.

- Use a nullable list:
- null → Search is inactive.
- Empty list → Search is active, but no results found.
- Non-empty list → Search is active and results are available.
*/

/*
========================================================
Q3. WHICH EMITS ARE DROPPED
========================================================

Assume filter results are lists of the SAME post objects,
in the same order, so two results with the same posts
compare equal.

The user types these six values one at a time, waiting
for the screen between each (the current state before
the first is: nothing typed, full list shown):

  1. "a"      -> 120 matches
  2. "ab"     -> 15 matches
  3. "abc"    -> the same 15 matches as "ab"
  4. "abcz"   -> 0 matches
  5. "abczz"  -> 0 matches
  6. (field cleared) -> empty search term
*/
/*
Questions:
- Which of the six emits reach the UI, and which are
  dropped? Compare each new state with the CURRENT state.
- How many times does the BlocBuilder builder run because
  of these six keystrokes?
- Is dropping the duplicates here good or bad for the
  user? Why?

Your answer:
- for 3 and 5 is droppepd because it matches the previous value,
- 4 times, because only four different states are emitted to the UI. The duplicate states at steps 3 and 5 are suppressed.
- Generally, good. There is no reason to rebuild the UI when the resulting data and message haven't changed.
For example:
- "ab" and "abc" produce exactly the same 15 posts.
- "abcz" and "abczz" both produce the same No Data Found message.
Rebuilding the UI in these situations provides no visual benefit.

One important exception: If you also wanted to display the current search term somewhere, you would need to store it in the state. Then a changed search 
term could make the states different even when the result lists are identical.

*/

void main() {}

/*
========================================================
                  END OF DAY 07
========================================================
*/
