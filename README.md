<div align="center">

# `>` Command Palette

[![GitHub Repo Stars Badge](https://img.shields.io/github/stars/MichaelPriebe/CommandPalette)](https://github.com/MichaelPriebe/CommandPalette)
[![Donate Badge](https://img.shields.io/badge/donate-paypal-blue)](https://www.paypal.com/cgi-bin/webscr?return=https://legacy.curseforge.com/projects/903532&cn=Add+special+instructions+to+the+addon+author()&business=paypal%40mikuhl.me&bn=PP-DonationsBF:btn_donateCC_LG.gif:NonHosted&cancel_return=https://legacy.curseforge.com/projects/903532&lc=US&item_name=Command+Palette+(from+curseforge.com)&cmd=_donations&rm=1&no_shipping=1&currency_code=USD)

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