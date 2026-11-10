/*
========================================================
   FLUTTER BLOC — DAY 05: FAVOURITE APP (LISTS IN STATE)
========================================================

Video covered: playlist video 9 (favourite app)

Topics:
- Lists inside state
- Emitting a copy of a list (List.from)
- Equatable with nested lists and models
- buildWhen with list fields
- Status enum (loading / success / failure)

IMPORTANT:
- Everything in this file is predict-and-explain. All
  code sits inside comments.
- Assume these shapes (your real files may differ
  slightly):

  class FavouriteItemModel extends Equatable {
    final String id;
    final String value;
    final bool isFavourite;
    // props => [id, value, isFavourite]
  }

  class FavouriteAppState extends Equatable {
    final List<FavouriteItemModel> favouriteItemList;
    final List<FavouriteItemModel> tempFavouriteItemList;
    final ListStatus listStatus;

    const FavouriteAppState({
      this.favouriteItemList = const [],
      this.tempFavouriteItemList = const [],
      this.listStatus = ListStatus.loading,
    });

    // copyWith as usual

    // props => [favouriteItemList, tempFavouriteItemList, listStatus]
  }

- The Bloc keeps the mutable fields favouriteList and
  tempFavouriteList, exactly as in your code.
- Equatable compares lists inside props by their CONTENTS.
  A plain List compared with == in your own code does not.
*/

/*
========================================================
Q1. DEBUGGING — WHY List.from MATTERS
========================================================

A teammate removes List.from to "save memory":

  void _selectItemHandler(
    SelectItemEvent event,
    Emitter<FavouriteAppState> emit,
  ) {
    tempFavouriteList.add(event.item);
    emit(state.copyWith(tempFavouriteItemList: tempFavouriteList));
  }

Scenario: the app has loaded. The user ticks the checkbox
of item 1, then item 2, then item 3, one tap at a time.
*/
/*
Questions:
- Trace the first emit: how does the new state compare
  with the current state? Is it dropped?
- Trace the second emit. What does the user see?
  (Hint: who else holds a reference to that list after
  the first emit?)
- Why does List.from fix this?
- Which Day 02 question is this a cousin of?

Your answer:
- No, the first emission is not dropped. The list gets item 1, so the new state has different list contents from the current state. Equatable detects the difference
 and allows the emission.

- After the first emission, both tempFavouriteList and the current BLoC state reference the same list object.
When item 2 is added, the existing state's list is also modified. Equatable compares the current and new states, finds them equal, and suppresses the emission.
The UI therefore does not rebuild to show item 2 or item 3.

- List.from() creates a separate list object containing the same elements.

- This prevents modifications to tempFavouriteList from affecting the list stored in the previous state. Equatable can now detect the difference between the old and 
new list contents, allowing BLoC to emit the new state.

- Day 02, Q3 — The Frozen Counter.
Both problems happen because existing state data is mutated instead of preserved. The solution is to maintain immutable state and emit new state snapshots
 whenever data changes.
*/

/*
========================================================
Q2. buildWhen WITH LIST FIELDS
========================================================

The AppBar has a BlocBuilder that shows the delete icon.
It has no buildWhen today.

  Visibility(
    visible: state.tempFavouriteItemList.isNotEmpty,
    child: IconButton(...delete...),
  )

Scenario, in this order:
  1. The app launches and the fetch completes.
  2. The user ticks items 1, 2 and 3.
  3. The user taps the heart on item 1.
  4. The user unticks items 3, 2 and 1.
*/
/*
Questions:
- How many times does this builder run with no buildWhen?
  (Count the initial build.)
- Write a buildWhen so it rebuilds only when the icon's
  visibility changes. How many builder runs now?
- A teammate writes:
    buildWhen: (previous, current) =>
        previous.tempFavouriteItemList != current.tempFavouriteItemList
  Does it filter anything? Why or why not? (Hint: Day 01.)
- Would adding a buildWhen to the main list BlocBuilder
  help? Why or why not?

Your answer:
9 times.
- 1 initial build.
- 1 after fetch completes.
- 3 times when selecting items 1, 2 and 3.
- 1 time when favouriting item 1.
- 3 times when unselecting items 3, 2 and 1.

buildWhen: (previous, current) =>
    previous.tempFavouriteItemList.isEmpty !=
    current.tempFavouriteItemList.isEmpty,
Builder runs: 3 times.
1 initial build.
1 when the first item is selected (icon becomes visible).
1 when the last selected item is unselected (icon becomes hidden).

- Not necessarily. Dart lists use identity-based equality by default, not content-based equality.
If the BLoC creates a new list for every state update, this condition will be true even if the list contains the same elements.

- It can help avoid unnecessary rebuilds, but we must be careful.
The main list depends on both favouriteItemList and tempFavouriteItemList. Checkbox selection changes the temporary list, and favouriting an item changes the favourite list.
So buildWhen must account for both changes. Otherwise, the UI may not reflect the latest state.

*/

/*
========================================================
Q3. INTERVIEW SCENARIO — THE STALE COPY
========================================================

Look at _addFavouriteHandler. When an item is hearted, a
NEW FavouriteItemModel is created with isFavourite
flipped, and the code swaps it into tempFavouriteList if
the old copy was selected.

Suppose a teammate deletes that swap block:

  if (tempFavouriteList.contains(favouriteList[index])) {
    tempFavouriteList.remove(favouriteList[index]);
    tempFavouriteList.add(event.item);
  }

Scenario: the user ticks item 2, then taps its heart.
The UI draws the checkbox with:
  state.tempFavouriteItemList.contains(item)
*/
/*
Questions:
- What does item 2's checkbox show after the heart tap,
  and why? (Trace contains with the model's ==.)
- The user then presses the delete icon. What happens
  to item 2?
- Twist: if the model's props were only [id], would the
  heart icon even update when tapped? Why or why not?
  (Hint: Day 03 Q3.)

Your answer:
- The checkbox becomes unchecked.
FavouriteItemModel uses Equatable. After tapping the heart, a new model is created with a different isFavourite value.
Since the old and new models are not equal, contains(item) returns false.

-Item 2 will not be deleted from the main favourite list because it is no longer present in the temporary selected list.
The stale old copy remains in tempFavouriteList, but it doesn't match the updated item.

- Yes. Because both old and new models have the same id, Equatable considers them equal. However, the UI still receives the updated favouriteItemList containing the new model 
with the flipped isFavourite value.

- Therefore, the heart icon updates, but equality-based comparisons cannot distinguish the old and new versions based on isFavourite

*/

/*
========================================================
Q4. STATUS ENUM — THE FAILURE BRANCH
========================================================

The UI has a case for ListStatus.faliure, but no handler
in the Bloc ever emits it. Assume the default listStatus
is ListStatus.loading.

Scenario: fetchAllList() throws an exception.
*/
/*
Questions:
- What does the user see on screen?
- Does the failure branch in the UI ever run? Why not?
- What does this show about adding a status to the state
  versus actually emitting it?

(No need to write the fix. API calls come in the next
video.)

Your answer:
- The user continues seeing the CircularProgressIndicator (loader) because the default status is ListStatus.loading.
- No. Even though the UI has a ListStatus.faliure case, the BLoC never emits that status when the exception occurs.
- Defining a status in an enum or state doesn't automatically activate it.
The BLoC must explicitly emit the corresponding state for the UI to react to it.

The UI responds to emitted states, not merely to the states defined in the enum.

*/

void main() {}

/*
========================================================
                  END OF DAY 05
========================================================
*/
