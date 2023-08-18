<div align="center">

# `>` Command Palette

[![GitHub Repo Stars Badge](https://img.shields.io/github/stars/MichaelPriebe/CommandPalette?logo=github&color=yellow)](https://github.com/MichaelPriebe/CommandPalette)
[![Donate PayPal Badge](https://img.shields.io/badge/donate-paypal-blue?logo=paypal)](https://www.paypal.com/donate/?business=7CX6PEVVWC97N&no_recurring=0&item_name=Creating+Command+Palette&currency_code=USD)
[![Download CurseForge Badge](https://img.shields.io/badge/download-curseforge-orange?logo=curseforge)](https://curseforge.com/wow/addons/command-palette)
[![Download GitHub Badge](https://img.shields.io/badge/download-github-lightgray?logo=github)](https://github.com/MichaelPriebe/CommandPalette/releases)
</div>

Command Palette gives you everything at your fingertips with a single search. Use `CTRL+SHIFT+P` to bring up the Command Palette and search for what you are looking for. Use `UP` + `DOWN` arrow keys to adjust your selection, and click `ENTER` to execute, or simply click on the option with your mouse.

![Screenshot of Command Palette AddOn](https://i.imgur.com/hWuEc9j.png)

## ❓ What Can It Do?

Command Palette can do almost everything, for example:
- Cast Spells
- Use Items
- Use Toys
- Summon Mounts
- Summon Pets
- Use Emotes
- Set Titles
- And more!

## 🫥 Missing Something?

If you are finding something missing from Command Palette:

### Players 🧍

Make a [New Issue](https://github.com/MichaelPriebe/CommandPalette/issues) with your requested action.

---

### Localizers 🌐

See [Localization.esMX.lua](CommandPalette/localization/Localization.esMX.lua) for example.

---

### Addon Developers 🧑‍💻

Consider making Bindings for your addons features. Command Palette adds all game and addon bindings to the interface. This helps your users regardless of them using Command Palette.

Binding icons are automatically set to your addons `IconTexture` if your addon name matches the header or category text. Per-binding icons can be set with a global variable:

```lua
-- Any first argument to TextureBase:SetTexture
BINDING_ICON_RAIDTARGET1 = 137001
```

If there is a dynamic action that cannot be put into bindings, you can respond to the `CommandPalette.UpdateActions` event, and add your action. Example: [Titles.lua](CommandPalette/plugins/Titles.lua)

If your action is not addon specific, consider creating a [Pull Request](https://github.com/MichaelPriebe/CommandPalette/pulls) with a new [plugin](CommandPalette/plugins) instead of creating a new addon.

---

### Blizzard ❄️
- [ ] Create more Bindings for game functions.
- [ ] Create a `binding` type for `SecureActionButtonTemplate`
- [ ] Create `nearbyX` unit types. Nameplates are too limiting.
- [ ] Bring back `[target=Name]` or `[@Name]` macro conditionals.
- [ ] Make functions that take UnitID/UnitToken also take a name.

---