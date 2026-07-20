{ config, pkgs, ... }:
{
  # fcitx5 configuration files
  xdg.configFile."fcitx5/profile".text = ''
    [Groups/0]
    Name=Default
    Default Layout=us
    DefaultIM=pinyin

    [Groups/0/Items/0]
    Name=keyboard-us
    Layout=

    [Groups/0/Items/1]
    Name=pinyin
    Layout=

    [GroupOrder]
    0=Default
  '';

  xdg.configFile."fcitx5/config".text = ''
    [Hotkey]
    # Trigger Input Method
    TriggerKeys=
    # Enumerate when press trigger key repeatedly
    EnumerateWithTriggerKeys=True
    # Temporally switch between first and current Input Method
    AltTriggerKeys=
    # Enumerate Input Method Forward
    EnumerateForwardKeys=
    # Enumerate Input Method Backward
    EnumerateBackwardKeys=
    # Skip first input method while enumerating
    EnumerateSkipFirst=False
    # Toggle embedded preedit
    TogglePreedit=

    [Hotkey/TriggerKeys]
    0=Control+space
    1=Zenkaku_Hankaku
    2=Hangul

    [Behavior]
    # Active By Default
    ActiveByDefault=False
    # Share Input State
    ShareInputState=No
    # Show preedit in application
    PreeditEnabledByDefault=True
    # Show Input Method Information when switch input method
    ShowInputMethodInformation=True
    # Show Input Method Information when changing focus
    showInputMethodInformationWhenFocusIn=False
    # Show compact input method information
    CompactInputMethodInformation=True
    # Show first input method information
    ShowFirstInputMethodInformation=True
    # Default page size
    DefaultPageSize=5
    # Override Xkb Option
    OverrideXkbOption=False
    # Custom Xkb Option
    CustomXkbOption=
    # Force Enabled Addons
    EnabledAddons=
    # Force Disabled Addons
    DisabledAddons=
    # Preload input method to be used by default
    PreloadInputMethod=True
  '';

  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    # Vertical Candidate List
    Vertical Candidate List=False
    # Use Per Screen DPI
    PerScreenDPI=True
    # Use mouse wheel to go to prev or next page
    WheelForPaging=True
    # Font
    Font="Sans 10"
    # Menu Font
    MenuFont="Sans 10"
    # Tray Font
    TrayFont="Sans Bold 10"
    # Tray Label Outline Color
    TrayOutlineColor=#000000
    # Tray Label Text Color
    TrayTextColor=#ffffff
    # Prefer Text Icon
    PreferTextIcon=False
    # Show Layout Name In Icon
    ShowLayoutNameInIcon=True
    # Use input method language to display text
    UseInputMethodLangaugeToDisplayText=True
    # Theme
    Theme=default
  '';
}
