# In-Class Activity 11: The Haunted Creature Registry

## Name

- Tejaswini Kolliboni (graduate track) – 003037935


## Track and tasks

- **Track:** Graduate
- **Shared build:** Welcome -> Signup -> Success, built from the Activity 10 form
- **Extension:** Task C – The Guarded Crypt (defensive navigation)
- **Repository:** https://github.com/Tejaswini345/MAD_inClass11
- **APK:** `build/app/outputs/flutter-apk/app-debug.apk` (debug build)


## How the app works

| File | Role |
|---|---|
| `lib/main.dart` | App shell only. `MaterialApp(home: WelcomeScreen())` |
| `lib/haunted_theme.dart` | Shared palette, `BrutalBox`, `BrutalButton`, input style, creature list |
| `lib/screens/welcome_screen.dart` | Typewriter title (`animated_text_kit`); `Navigator.push` to the Lab |
| `lib/screens/signup_screen.dart` | Form, validators, password toggle, birth-date picker, required creature dropdown, loading state; `Navigator.pushReplacement` to the Ballroom |
| `lib/screens/success_screen.dart` | Receives name and creature through constructor parameters; confetti (`confetti`); guard against empty data |

- **Navigation:** `push()` from Foyer to Lab, so Back returns to the Foyer. `pushReplacement()` from Lab to Ballroom, so Back cannot resubmit the form.
- **State:** typed values, the visibility toggle, the birth date and the selected creature live in `SignupScreen`'s State and die with that screen. Only the name and creature type are handed forward, by value, as `SuccessScreen(userName, creatureType)`.
- **Dispose:** all four `TextEditingController`s and the `ConfettiController` are disposed.
- **Validators kept from Activity 10:** name required, email must contain `@`, password at least 6 characters. Added: birth date required (no future dates), creature type required.

## Task C – The Guarded Crypt

1. **Guard the Ballroom.** `SuccessScreen` checks that `userName` and `creatureType` are not empty (`_hasValidData`). If either is empty it draws no certificate and reroutes to the Foyer with `pushAndRemoveUntil`, using a post-frame callback because navigation cannot run inside `initState`. `SignupScreen` also refuses to navigate with an empty name or null creature.
2. **Second double-submit guard.** `_inFlight` is a plain bool set synchronously at the top of `_submit()`, so a second call returns immediately even if the button were enabled. The disabled button (`onPressed: null` while `_submitting`) is the first guard.
3. **Async gap.** After the 2-second `await`, `if (!mounted) return;` runs before any `setState` or navigation.

## Tests run
 APK built with `flutter build apk --debug`.

| # | Test | Result |
|---|---|---|
| 1 | All fields empty, tap Register Creature | Five error messages shown (name, email, password, birth date, creature) – pass |
| 2 | Email without "@" | "Email must contain @" – pass |
| 3 | Password under 6 characters | "At least 6 characters" – pass |
| 4 | Eye icon | Password switches between dots and letters – pass |
| 5 | Birth-date picker | Opens at 2000; year list stops at 2026, no future years – pass |
| 6 | Creature dropdown | All five choices listed (Ghost, Bat, Black Cat, Pumpkin Spirit, Witch) – pass |
| 7 | Valid submit | "BREWING..." spinner with disabled button, then success screen with name and creature – pass |

## Task C hostile-case table

Temporary edits used for H1, H2 and H4 were reverted after testing.

| # | Hostile case | How to trigger | Expected | Observed |
|---|---|---|---|---|
| H1 | Empty name reaches Ballroom | Temporarily pass `userName: ''` in `pushReplacement` | Rerouted to Foyer, no certificate | Pass – returned to the Foyer, no certificate shown |
| H2 | Missing creature type | Temporarily pass `creatureType: ''` | Rerouted to Foyer, no certificate | Pass – returned to the Foyer, no certificate shown |
| H3 | Double-tap Register | Tap twice fast on a valid form | One navigation, one Ballroom | Pass – only one success screen appeared |
| H4 | Double submit with button enabled | Temporarily set `onPressed: _submit` always, tap twice | Second call stops at `_inFlight` | Pass – repeated taps produced one success screen (`_inFlight` blocked the rest) |
| H5 | Back out during the 2 s load | Tap Register, then press Back | Returns to Foyer, no `setState() called after dispose` error | Pass – returned to the Foyer, no dispose error in the terminal |
| H6 | Back from the Ballroom | Browser or system Back after success | Does not return to the form | Pass – Back did not return to the form |

## Contribution


- Copied my Activity 10 project into a new folder and added the `animated_text_kit` and `confetti` packages.
- Organized the app into `lib/screens/` with one file per screen and a small `main.dart`.
- Built and ran the Welcome, Signup and Success screens, including the creature dropdown, password toggle, birth-date picker, loading state and confetti.
- Chose Task C (defensive navigation) as my graduate extension.
- Ran the form tests in Android Studio and took screenshots as evidence.
- Built the debug APK, created the GitHub repository, and wrote this README and the Word document.


## Reflection – Tejaswini Kolliboni (graduate)

**1. push() vs pushReplacement().** The Foyer uses `push()` because a guest may change their mind and walk back out. The Lab uses `pushReplacement()` to reach the Ballroom because going back to a finished form would risk a second submission. The stack after signup is Foyer, Ballroom, so Back from the Ballroom leaves the app rather than reopening the form.

**2. Async gaps.** `_submit()` has a 2-second delay. During that time the guest can leave, so the State can be disposed before the line after the `await` runs. The `mounted` check stops a `setState` or navigation on a dead screen, and `_inFlight` stops a second submission from starting during the wait.

**3. Trade-off and improvement.** Rerouting silently to the Foyer keeps the app safe and simple, but the guest gets no explanation. An improvement is to show a SnackBar on the Foyer explaining that the registration data was incomplete, and to replace the fake delay with a real call that can fail and be retried.