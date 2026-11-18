## Unreleased

- 🍔 `MenuButton` and `MenuEntry`: an icon that opens a short menu under itself. With a `label` it is an outlined button, such as "More".
- 🖱️ `ContextMenuRegion`: the same menu on a right-click or a long press, where the pointer is.
- ♿️ Screen readers and keyboards: `Tappable` takes a `semanticLabel` (its `tooltip` when left out) and says "button" for anything with a name; `SwitchToggle` says on or off, takes the focus and flips on Space or Enter; `Button` shows a focus ring; an off switch has an outline you can see on a light page.
- ♿️ Menus and choices: a `ContextMenuRegion`'s entries are the child's own actions to a screen reader, an open menu closes on its dismiss gesture, `RadioIcon` and `CheckBox` say whether they are picked, and a `Tappable` nobody can press is no longer a stop for Tab.

## 1.0.0

- 🦊 Initial release.
