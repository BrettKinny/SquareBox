# SquareBox first-run demo — https://github.com/charmbracelet/vhs
#
# Generate the GIF:
#   vhs demo/demo.tape
#
# Requires: vhs (brew install vhs), ttyd, ffmpeg

Output demo/squarebox-setup.webp

Set Shell "bash"
Set FontSize 16
Set Width 900
Set Height 550
Set Padding 20
Set Theme "Catppuccin Frappe"
Set TypingSpeed 60ms
Set WindowBar Colorful
Set WindowBarSize 40
Set CursorBlink false

Sleep 500ms

# Show the install command being typed
Type "curl -fsSL https://raw.githubusercontent.com/BrettKinny/SquareBox/main/install.sh | bash"
Sleep 600ms

# Secretly swap to the demo script and press Enter — all while hidden
Hide
Ctrl+U
Type "bash demo/install-demo.sh"
Enter
Sleep 500ms
Show

# Wait for the full simulation to play out
Sleep 20s

Sleep 3s
