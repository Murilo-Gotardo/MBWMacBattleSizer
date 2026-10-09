<a href="https://www.moddb.com/mods/mbwmacbattlesizer" title="View MBWMacBattleSizer on ModDB" target="_blank"><img src="https://button.moddb.com/popularity/medium/mods/73347.png" alt="MBWMacBattleSizer" /></a>
<a href="https://www.moddb.com/mods/mbwmacbattlesizer/downloads/mbwmacbattlesizer" title="Download MBWMacBattleSizer - ModDB" target="_blank"><img src="https://button.moddb.com/download/medium/318121.png" alt="MBWMacBattleSizer" /></a>

# Mac Battle Sizer for Mount & Blade: Warband

A small macOS app that lets you go beyond the default battle size limit in Mount & Blade: Warband. It works by editing the game's configuration file (`rgl_config.txt`).

## How it works

The slider in this app sets the `battle_size` value written to the config file. That number is **not** the battle size you see in game. The game applies a formula to it, which is why the app also shows a **Real game value** counter next to the slider.

For every value from 1 to 998 in the config file, the value shown in game is:

real game value = 120 × n + 30

where `n` is the number selected on the slider.

For example, `n = 100` shows `12030` in game, and `n = 500` shows `60030`.

## Warning

Don't overdo it. High values can cause crashes and/or bad performance. Values above 998 behave irregularly in game (999 repeats the value of 998, and 1000 shows an unrelated number), so the slider is limited to 998.

## Notes

- The app edits `~/Library/Application Support/MBWarband/rgl_config.txt`.
- Close the game before saving, otherwise it may overwrite the change on exit.
- Consider making a backup of your config file before using the app.

## Credits

The original app was created by [pullo123](https://www.moddb.com/members/pullo123) and is made exclusively for Windows. This project is a macOS version inspired by it.

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
