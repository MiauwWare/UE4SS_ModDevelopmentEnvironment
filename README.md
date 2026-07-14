# UE4SSCPPTemplate

## Fast Edit-Build-Test Loop

This repo now includes helper scripts so you can iterate quickly:

1. Edit mod code.
2. Build and install to Palworld Mods.
3. Launch the game and test.
4. Repeat.

### One-time setup

1. Copy `dev.config.example.bat` to `dev.local.bat`.
2. Edit `dev.local.bat` and set your local paths.

### Daily loop

Run one command from repo root:

```
dev_loop.bat
```

This runs:

- `dev_build_install.bat` (build + copy DLL to UE4SS Mods)
- `dev_run_game.bat` (launch Palworld)

### Individual commands

Build + install only:

```
dev_build_install.bat
```

Launch game only:

```
dev_run_game.bat
```

### Notes

- UE4SS build mode names follow `<Target>__<Config>__<Platform>` (for example `Game__Debug__Win64`).
- For Visual Studio generators, builds require `--config <mode>`. The scripts handle this for you.
- `install_mod.bat` accepts either the game folder (containing `Mods`) or the `Mods` folder itself.

