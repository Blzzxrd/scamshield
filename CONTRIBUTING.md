# Working together on ScamShield

The repository's `main` branch is the shared integration branch. Work on a separate branch, push it, and open a pull request into `main`. This lets text, email, call, and interface changes move forward at the same time while Flutter CI checks the combined result.

## Feature folders

| Area | Main files |
| --- | --- |
| Interface and shared UI | `lib/features/interface/`, `lib/app.dart` |
| Home scoreboard | `lib/features/home/` |
| Text imitation | `lib/features/text/` |
| Email imitation | `lib/features/email/` |
| Call imitation | `lib/features/call/` |
| Lessons | `lib/features/learn/` |
| Practice menu | `lib/features/practice/` |
| Profile | `lib/features/profile/` |
| Shared progress and message model | `lib/services/`, `lib/models/` |

Keep feature-specific UI and sample scenarios in the matching feature folder. The small files in `lib/data/` combine data used across features. When changing a shared model, theme, navigation, or progress rule, explain its impact on the other features in the pull request.

## Branch and pull request flow

1. Update your local `main`: `git checkout main` and `git pull origin main`.
2. Create a branch for your change, such as `feature/text-new-scenario` or `feature/email-inbox`.
3. Make focused commits and push your branch: `git push -u origin <branch-name>`.
4. Open a pull request into `main`. Review the changed files and wait for **Flutter checks** to pass.
5. If `main` changes while you work, merge or rebase the latest `main` into your branch, resolve any conflicts, and run the checks again.
6. Merge the pull request when it is ready. Pull the updated `main` before starting another change.

Run these checks locally before opening a pull request:

```sh
flutter pub get
flutter analyze
flutter test
flutter build web
```

The prototype stores progress only in each browser. There is no shared player account or multiplayer leaderboard yet.
