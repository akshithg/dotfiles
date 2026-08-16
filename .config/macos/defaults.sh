#!/usr/bin/env bash
set -euo pipefail

# Apply macOS defaults
# References:
# - https://macos-defaults.com/
# - https://github.com/mathiasbynens/dotfiles/blob/main/.macos
#
# Note: Removed deprecated settings that no longer work:
# - com.apple.dock no-glass (pre-Yosemite)
# - com.apple.finder EmptyTrashSecurely (removed in 10.11 El Capitan)

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Error: Not macOS" >&2
  exit 1
fi

echo "==> Dock"
defaults write com.apple.dock "orientation" -string "bottom"
defaults write com.apple.dock "tilesize" -int "48"
defaults write com.apple.dock "autohide" -bool true
defaults write com.apple.dock "autohide-time-modifier" -float "0"
defaults write com.apple.dock "autohide-delay" -float "0.0"
defaults write com.apple.dock "show-recents" -bool false
defaults write com.apple.dock "show-process-indicators" -bool true
defaults write com.apple.dock "launchanim" -bool false
defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -bool true
defaults write com.apple.dock "showhidden" -bool true
defaults write com.apple.dock "expose-group-apps" -bool true
defaults write com.apple.dock "scroll-to-open" -bool true
defaults write com.apple.dock "mru-spaces" -bool false
defaults write com.apple.dock "no-bouncing" -bool true

echo "==> Hot corners"
# bottom left: Launchpad
defaults write com.apple.dock "wvous-bl-corner" -int 11
defaults write com.apple.dock "wvous-bl-modifier" -int 0
# bottom right: none
defaults write com.apple.dock "wvous-br-corner" -int 1
defaults write com.apple.dock "wvous-br-modifier" -int 0
# top left: none
defaults write com.apple.dock "wvous-tl-corner" -int 1
defaults write com.apple.dock "wvous-tl-modifier" -int 0
# top right: notification
defaults write com.apple.dock "wvous-tr-corner" -int 12
defaults write com.apple.dock "wvous-tr-modifier" -int 0

echo "==> Screenshots"
defaults write com.apple.screencapture "include-date" -bool true
defaults write com.apple.screencapture "disable-shadow" -bool true
mkdir -p "$HOME/Downloads/Screenshots"
defaults write com.apple.screencapture "location" -string "$HOME/Downloads/Screenshots"
defaults write com.apple.screencapture "show-thumbnail" -bool true
defaults write com.apple.screencapture "type" -string "png"

echo "==> Safari"
defaults write com.apple.safari "ShowFullURLInSmartSearchField" -bool true
defaults write com.apple.Safari "DebugSnapshotsUpdatePolicy" -int "2"
defaults write com.apple.Safari "IncludeInternalDebugMenu" -bool true
defaults write com.apple.Safari "FindOnPageMatchesWordStartsOnly" -bool false
defaults write com.apple.Safari "ProxiesInBookmarksBar" "()"

echo "==> Finder"
defaults write com.apple.finder "DisableAllAnimations" -bool true
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool false
defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"
defaults write com.apple.finder "_FXShowPosixPathInTitle" -bool true
defaults write com.apple.finder "_FXSortFoldersFirst" -bool true
defaults write com.apple.finder "ShowStatusBar" -bool true
defaults write com.apple.finder "AppleShowAllFiles" -bool true
defaults write com.apple.finder "QLEnableTextSelection" -bool true
defaults write com.apple.finder "QuitMenuItem" -bool true
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool true
defaults write com.apple.finder "WarnOnEmptyTrash" -bool false
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool true
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool true
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool true
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool true
defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool true

echo "==> Global (NSGlobalDomain)"
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool true
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool false
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode" -bool true
defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint" -bool true
defaults write NSGlobalDomain "PMPrintingExpandedStateForPrint2" -bool true
defaults write NSGlobalDomain "AppleEnableMenuBarTransparency" -bool false
defaults write NSGlobalDomain "AppleKeyboardUIMode" -int 3
defaults write NSGlobalDomain "KeyRepeat" -int 1
defaults write NSGlobalDomain "InitialKeyRepeat" -int 15
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool false
defaults write NSGlobalDomain "AppleFontSmoothing" -int 2
defaults write NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled" -bool false
defaults write NSGlobalDomain "NSAutomaticWindowAnimationsEnabled" -bool false
defaults write NSGlobalDomain "NSWindowResizeTime" -float 0.001
defaults write NSGlobalDomain "NSQuitAlwaysKeepsWindows" -bool false
defaults write NSGlobalDomain "com.apple.mouse.linear" -bool true


echo "==> Trackpad"
defaults write com.apple.AppleMultitouchTrackpad "Clicking" -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "Clicking" -bool true
defaults write NSGlobalDomain "com.apple.mouse.tapBehavior" -int 1
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadThreeFingerDrag" -bool true

echo "==> Desktop Services"
defaults write com.apple.desktopservices "DSDontWriteNetworkStores" -bool true

echo "==> Menu bar"
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM h:mm:ss\""
defaults write com.apple.menuextra.battery "ShowPercent" -string "YES"

echo "==> TextEdit"
defaults write com.apple.TextEdit "RichText" -bool false

echo "==> Time Machine"
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool true

echo "==> Activity Monitor"
defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "5"
defaults write com.apple.ActivityMonitor "IconType" -int "5"

echo "==> Terminal"
defaults write com.apple.terminal "StringEncodings" -array 4

echo "==> Mail"
defaults write com.apple.Mail "DisableReplyAnimations" -bool true
defaults write com.apple.Mail "DisableSendAnimations" -bool true
defaults write com.apple.mail "AddressesIncludeNameOnPasteboard" -bool false

echo "==> Screensaver"
defaults write com.apple.screensaver "askForPassword" -int 1
defaults write com.apple.screensaver "askForPasswordDelay" -int 0

echo "==> Xcode (if installed)"
if [[ -d "/Applications/Xcode.app" ]]; then
  defaults write com.apple.dt.Xcode "ShowBuildOperationDuration" -bool true
fi

echo "==> Show ~/Library folder"
chflags nohidden ~/Library

echo "==> Restart affected applications"
for app in Dock Safari Finder Mail SystemUIServer TextEdit "Activity Monitor"; do
  killall "$app" 2>/dev/null || true
done

echo ""
echo "Done. Some changes require logout/restart."
echo ""
echo "Manual setup required:"
echo "  - Caps Lock → Escape: System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys"
