## Collect

A Flutter toolkit born out of Willow — all the reusable bits we kept reaching for, pulled out into its own package so
we (and anyone else) can actually use them again.

### What's in here

**Custom data types** that do more than the defaults. `Colour` handles every color space you can think of. `Moment`
wraps DateTime and actually makes formatting and date math feel good. `Period` extends Duration with years and months,
because sometimes you need those.

**Extensions on everything.** Ints, doubles, strings, widgets, lists, BuildContext — if you use it day to day, there's
probably already an extension on it. Things like `.paddingAll()`, `.toCamelCase()`, `.sumBy()`, and quick notification
helpers straight off the context.

**Presentation widgets.** A Material 3 theme out of the box (Sage + Terracotta, if you're curious), plus a handful of
ready-to-drop widgets: tab views, action icons, a hex editor/viewer, a colour picker, hover detection, and more.

**Utilities.** Base conversion up to base-256, toast notifications, and string helpers that actually handle edge cases.

### Fonts

16 font families bundled and ready — Inter, Montserrat, JetBrains Mono, the KaTeX math set, and a bunch more. No extra
setup needed.

### Getting started

Just add `collect` to your `pubspec.yaml` and import the library. Everything's exported from a single entry point, so
one import covers the whole toolkit.

Docs live in the `doc/` folder if you want the full breakdown.
