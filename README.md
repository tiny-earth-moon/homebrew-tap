# tiny-earth-moon/homebrew-tap

Homebrew tap of [tiny-earth-moon](https://github.com/tiny-earth-moon).

| Formula | What |
|---|---|
| `outskirts` | [outskirts](https://github.com/tiny-earth-moon/outskirts), the community-maintained successor of the archived [peripheryapp/periphery](https://github.com/peripheryapp/periphery): finds unused code in Swift projects. Arm64 bottle, or builds from source (Xcode 26+). Installs `periphery` as an alias of `outskirts`. |

```bash
brew tap tiny-earth-moon/tap
brew install tiny-earth-moon/tap/outskirts
```

The formula was named `periphery` until 3.15.0: `brew install tiny-earth-moon/tap/periphery` and existing installs keep working, and `brew upgrade` moves them to `outskirts`.

The core `periphery` formula (3.8.0, deprecated upstream, disabled 2027-08-12) conflicts with this one: `brew uninstall periphery` first.
