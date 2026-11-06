# Instructions for agents working on Hop

Read `README.md` and `docs/product-context.md` before changing product code. Treat those files as the product brief; update them when a product decision changes.

## Product and platform

- Build a native macOS application in Swift with Xcode. Prefer SwiftUI for app structure and AppKit for terminal behavior that SwiftUI cannot provide well.
- Keep the interface minimal and aligned with macOS conventions. Use system controls, menus, keyboard shortcuts, accessibility labels, and light/dark appearance.
- Design for App Sandbox from the first implementation. Do not rely on unrestricted access to `~/.ssh`, arbitrary local paths, or external command execution without verifying behavior in a sandboxed app.
- Keep SSH transport, SFTP transfers, tunnel lifecycle, persistence, and UI separate. Do not embed credentials in host configuration models.

## SSH and security

- Validate server host keys; never silently accept a changed key or disable verification for convenience.
- Store passwords, private key passphrases, and tokens in Keychain. Never write secrets to defaults, project files, test snapshots, CI logs, or transfer logs.
- Support local and remote TCP forwarding explicitly. Bind local listeners to loopback by default; broader exposure requires an explicit UI choice.
- Make connection, tunnel, and transfer cancellation reliable. Close resources on disconnect and app exit.
- For machine-to-machine copies, use two authenticated SFTP sessions and relay bytes through the app unless a later design explicitly changes this model.

## Development workflow

- Add focused tests for host configuration validation, host-key policy, tunnel mapping/lifecycle, and transfer failure/cancellation.
- Run the relevant `xcodebuild` build and test commands before claiming an implementation works. Record any unavailable signing or App Store validation separately.
- Keep CI on a macOS runner. Build and test on pull requests; upload an unsigned build artifact for inspection. Treat signing, notarization, Store submission, and update publication as distinct release steps.
- Never commit credentials, signing material, private keys, or machine-specific configuration.
