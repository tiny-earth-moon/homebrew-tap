# tiny-earth-moon/homebrew-tap

Homebrew tap of [tiny-earth-moon](https://github.com/tiny-earth-moon).

| Formula | What |
|---|---|
| `periphery` | [Maintained fork](https://github.com/tiny-earth-moon/periphery) of the archived [peripheryapp/periphery](https://github.com/peripheryapp/periphery): identifies unused code in Swift projects. Builds from source (Xcode 26+). |

```bash
brew tap tiny-earth-moon/tap
brew install tiny-earth-moon/tap/periphery
```

The core `periphery` formula (3.8.0, deprecated upstream, disabled 2027-08-12) conflicts with this one: `brew uninstall periphery` first.
