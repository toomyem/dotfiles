# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os, subprocess

mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "left",  lazy.layout.left(),  desc="Move focus to left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "down",  lazy.layout.down(),  desc="Move focus down"),
    Key([mod], "up",    lazy.layout.up(),    desc="Move focus up"),

    #Key([mod], "tab",    lazy.layout.next(),  desc="Move window focus to other window"),

    Key([mod, "shift"], "left",  lazy.layout.shuffle_left(),  desc="Move window to the left"),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "down",  lazy.layout.shuffle_down(),  desc="Move window down"),
    Key([mod, "shift"], "up",    lazy.layout.shuffle_up(),    desc="Move window up"),

    Key([mod, "control"], "left",  lazy.layout.grow_left(),  desc="Grow window to the left"),
    Key([mod, "control"], "right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "down",  lazy.layout.grow_down(),  desc="Grow window down"),
    Key([mod, "control"], "up",    lazy.layout.grow_up(),   desc="Grow window up"),

    Key([mod], "equal", lazy.layout.grow(), desc="Grow"),
    Key([mod], "minus", lazy.layout.shrink(), desc="Shrink"),

    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle maxmize"),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "tab", lazy.layout.next(), desc="Switch to next window"),

    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    #Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Spawn app runner"),
    Key([mod], "p", lazy.spawn("rofi -show run"), desc="Spawn programms runner"),
    Key([mod], "backspace", lazy.next_screen(), desc="Move to next screen"),
    Key([mod, "shift"], "s", lazy.spawn("make_screenshot"), desc="Take a screen shot"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            #Key(
            #    [mod, "shift"],
            #    i.name,
            #    lazy.window.togroup(i.name, switch_group=True),
            #    desc="Switch to & move focused window to group {}".format(i.name),
            #),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                 desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.MonadTall(border_focus=['#ff0000', '#ff0000'], border_normal='#808080', border_width=3, margin=8, ratio=0.6),
    layout.Tile(margin=5, border_width=4, border_focus='#ff0000', border_normal='#808080', add_after_last=True),
    layout.Columns(border_focus="#ff0000", border_normal="#808080", border_width=4, border_on_single=True, margin=5),
    layout.Max(margin=5, border_width=4, border_focus='#ff0000', border_normal='#808080'),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="NotoMono NFP",
    fontsize=16,
    padding=5,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(),
                widget.GroupBox(highlight_method="block", disable_drag=True, use_mouse_wheel=False, inactive='808080', margin_x=0),
                widget.WindowName(for_current_screen=True, max_chars=30),
                #widget.Chord(
                #    chords_colors={
                #        "launch": ("#ff0000", "#ffffff"),
                #    },
                #    name_transform=lambda name: name.upper(),
                #),
                #widget.TextBox("default config", name="default"),
                #widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                #widget.Systray(),
                widget.Mpris2(display_metadata=["xesam:title", "xesam:artist"], playing_text="󰐊 {track}", paused_text="󰏤 {track}", scroll=False, max_chars=50),
                widget.CPU(fmt=" {}", format="{load_percent:.1f}%", update_interval=5),
                widget.Memory(fmt="󰍛 {}", format="{MemUsed:.0f}G/{MemTotal:.0f}G", measure_mem='G', update_interval=5),
                widget.DF(fmt="󱛟 {}", format="{uf}{m}/{r:.0f}%", measure="G", visible_on_warn=False),
                widget.CheckUpdates(fmt=" {}", custom_command="xbps-install -un", display_format="{updates}", no_update_string="0", colour_have_updates="ff0000", execute="alacritty --class Scratchpad -e sudo xbps-install -u"),
                widget.Clock(fmt="󰃭 {}", format="%a %d %b %H:%M:%S"),
                #widget.QuickExit(),
            ],
            24,
            # border_width=[0, 0, 2, 0],
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        #wallpaper = "~/Pobrane/fantasy-mosque-cityscape-w46ob7a2u2l9gphy.jpg",
    ),
    Screen(
        #wallpaper = "~/Pobrane/fantasy-mosque-cityscape-w46ob7a2u2l9gphy.jpg",
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="Scratchpad"),
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    border_focus = "#ff0000",
    border_normal = "#808080",
    border_width = 3
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

wmname = "qtile"

