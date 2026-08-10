# FishHub GitHub structure

Upload `FishHub_GitHub_Main.lua` as the main script.
Upload the eight files in `FunctionModules/` to the same GitHub repository.

## Important
The source file supplied for this build contains eight URL fields, but all eight
are empty. No real Shop/Farm/etc. GitHub URLs were present in the supplied file,
so this build does NOT invent or overwrite them.

Paste the real RAW URLs into the eight `FeatureScripts` entries in the main file.

## Function behavior
- URL empty -> clicking the card does nothing except a notification.
- URL invalid/load error -> stays on Function page.
- URL loads successfully -> FishHub opens its existing content page.
- Search and Back are owned by FishHub, not by the remote module.

## Remote module contract
Each module returns a table with `Start(self, API)`.
Use `API.SetContent(title, content)` to fill FishHub's existing content page.
Use `API.ShowNotification(message)` for notifications.
