---
title: "Tips & Tricks 4: making keybinds"
date: "6 May 2021 12:00:00 +0000"
draft: false
---


Welcome to the fourth tips and tricks newsletter for donors! Sorry for the extreme tardiness - I moved house and lost track of time.

This newsletter is going to cover probably the most important feature of Tridactyl: the ability to have stuff happen when you press keys in a certain order, which we call binding. It's a topic with a surprising amount of depth so feel free to dip in and out of this newsletter. It's probably a bit too long and broad to tackle in one sitting.

# Binding

In Tridactyl, we bind sequences of keypresses to ex-strings (also called ex-commands) which are immediately executed. Most actions in Tridactyl - for example, scrolling down (`:scrollline`) or switching to a specific tab (`:tab [N]`) - are ex-commands. Keys which are not part of a valid key-sequence are passed through to websites and Firefox.

Firefox reserves some key-combinations such as Ctrl-T and Ctrl-W; Tridactyl binds using these key combinations will not work (and there is no easy way of finding out other than just trying them). If you're feeling intrepid you can overcome this restriction by running this script on Linux - https://github.com/alerque/que-firefox/blob/6dd5d6c9e1f60ff888cda33d8f2c198458b14a71/bin/patch-firefox.sh - but you'll need to run it each time Firefox updates.

We don't map key sequences to key sequences like Vim does (so, for example, you can't bind j to the down arrow) due to Firefox limitations.

The general syntax for binding is simply `:bind [key sequence] [ex-string]`. We'll now get into the gory details...

## Key sequence syntax

Each element of a key sequence is either:

-   a single character - such as `j` representing a keypress of `j` - or
-   a special representation enclosed by angle brackets `<>` of a set of zero or more special modifiers and a single character or a special key, for example `<C-ArrowUp>`, with a dash separating the modifiers and the character.

The special permitted modifiers are:

-   `C` for left or right ctrl
-   `A` for left alt
-   `M` for the "meta" key (splat on Macintosh - ill-defined on other OSes)
-   `S` for left or right shift. Note that characters such as `@` which require the shift key to be pressed to be entered do not need the `S` modifier to be specified.

The names of special keys can be found here: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values

A key sequence is made up of a series of elements with no separators between them.

For example, the key sequence `,<C-ArrowDown>k` would match the following interaction with your keyboard:

1. `,` pressed and released
2. `Control` pressed and held
3. `ArrowDown` pressed and released
4. `Control` released
5. `k` pressed and released

## Numeric prefixes

All binds accept numeric prefixes, such as `2gt` which would take you to the second tab. They do this by simply appending the supplied prefix to the bound ex-string before it is executed. For example, if I run

```
:bind ,j fillcmdline tabopen
10,j
```

`fillcmdline tabopen 10` will be executed and the command line will appear prefilled with `:tabopen 10 `.

This does mean that binds cannot start with a numeric prefix (but e.g. `bind ,1 [ex string]` does work).

Not all ex-strings will do anything meaningful with the supplied count - but many will. If there is a command that you would like to support counts, just file an issue - it's usually easy for us to add.

## Binding in other modes

By default, `:bind` binds key sequences to ex-strings in normal mode (the mode you are in most of the time). You can create bindings in all of the modes in Tridactyl - even `ignore` mode - very simply:

`:bind --mode=[modename] [key sequence] [ex-string]`

For example, to make `:` work in ignore mode, you could run `:bind --mode=ignore : fillcmdline_notrail`. Ex-strings that are exclusively meaningful in a specific mode have the syntax `[mode].[command name]` - for example, `ex.accept_line` is the ex-string that tells Tridactyl to execute the command that is currently written in the command line. See the "Viewing binds" section for more details on these mode-specific ex-strings.

# Unbinding

Unbound keys are passed through to the webpage or Firefox. Unbind a key sequence with `:unbind [--mode=[mode=normal] [keysequence]`, for example, `:unbind <C-f>`.

## `blacklistkeys`

Keys which are not bound in Tridactyl are passed through to websites and Firefox, so websites and Firefox can bind actions to them. If a website wants to bind to a key, usually it takes priority over Firefox except for a few special key combinations.

If a page is stealing a key that you want Firefox to claim, for example, `'` (Firefox's "focus link matching text" mode), run `:set blacklistkeys ["'","/"]`. Note that you must use JavaScript array syntax and that you need to include all the keys you wish to protect, including `/` which is protected by default. If you omitted `/` it would no longer be protected.

NB: this works on most but not all pages. See [issue #904](https://github.com/tridactyl/tridactyl/issues/904).

# Resetting a bind to default

`reset [key sequence]` resets the key sequence to its default value. Not to be confused with `:unset` which does the same thing but for settings (the insanity in the naming comes from the fact that we had keybinds before we had general settings - sorry!).

# Per-site binds

`:bindurl [url regex]` and `:unbindurl` allow you to bind keys on sites that match the supplied regex. This is often used to control which links have hints displayed on them, as was explored extensively in [the first newsletter](https://github.com/tridactyl/tridactyl/blob/master/doc/newsletters/tips-and-tricks/1-hint-css-selectors.md).

Unbinding keys per site works similarly with `:unbindurl`. For example, it is common to unbind `f` on YouTube so that YouTube's own bind for `f` to toggle fullscreen video can be used: `:unbindurl ^http(s?)://youtube\.com f`.

# Special modes

Most modes are just collections of key sequences bound to ex-strings. There are some exceptions to this; sometimes keys perform some other action and sometimes modes have other properties.

Here I'll list each of the slightly weird modes and what is weird about them.

## Hint mode

In hint mode, keys being fed to the hint filter are not done so using an ex-string - see `:set hintchars` instead to control which keys perform filtering. The rest of the commands in the mode are bound to ex-strings - for example, `<Enter>` is bound to `hint.selectFocusedHint`.

## Insert mode

There's nothing special about keys in this mode. Insert mode is entered automatically once a text area is focused, unless you're already in `input` mode (e.g. from `gi`). You are returned to normal mode once a text area loses focus.

You may find the `text.` ex-strings useful for manipulating text - they can be viewed by clicking the link at the top of the `:help` page where it says "Tridactyl also provides a few functions to manipulate text in the command line or text areas that can be found _here_.".

## Ex-mode

Ex-mode, the mode you are in when the command line is open, is a fairly standard mode where key sequences are bound to ex-strings. For example, `<C-o>yy` is bound to `:ex.execute_ex_on_completion_args clipboard yank` which copies the highlighted completion to the clipboard. The exception to this is that the command line is a normal text-area - there are no key-sequences associated with characters entered into the text-area. Filtering is done on the contents of this text-area (and so, e.g., pasting text works normally there).

## Browser mode

This mode is unlike any other. Rather than binding key sequences to ex-strings, it binds "octopus-style" Mozilla-approved keyboard shortcuts firstly to "user actions" and, if it finds none, ex-strings. It has two advantages to the other modes: it is available everywhere in the browser, including protected pages such as `about:addons`, and it can perform user-actions (actions which Mozilla will only allow to happen if we can prove that a user instigated it) which our usual binds cannot. For now, the only user-action we have is `escapehatch` which opens and closes the sidebar to get focus back to the page, bound to `<C-,>` by default.

Valid keyboard shortcuts consist of one or more modifiers (such as control) and a normal key, so long as that combination of modifiers and key is not on a blacklist of binds that are Mozilla thinks are too important for you to redefine. No errors are provided by Mozilla if the shortcut you choose is on the blacklist - it just won't work when you press the shortcut.

This blacklist varies per system - see https://searchfox.org/mozilla-central/rev/1f4e023df8ff04b893ca792492f1e2e9629bfddb/toolkit/modules/ShortcutUtils.jsm#315 and https://searchfox.org/mozilla-central/rev/1f4e023df8ff04b893ca792492f1e2e9629bfddb/toolkit/modules/ShortcutUtils.jsm#287 if you want to get an idea of how complicated it is. My personal approach is this: try binding it. If it doesn't work, assume it's on the blacklist and try a different shortcut.

A workaround if your desired shortcut is on the blacklist is to use an external program to map that shortcut to another one which can be used. For example, you could use `xkeysnail` under X11/Linux, `AutoHotKey` under Windows, or `karabiner` under OSX.

If you wanted to bind `<C-t>` to `:tabopen` to avoid focus on the address bar, with `xkeysnail`'s `config.py` you might do:

```
# ~/.config/xkeysnail/config.py
from xkeysnail.transform import *

define_keymap(re.compile("Firefox|Google-chrome"), {
    # Rebind ctrl-t to ctrl-. so it can be rebound
    K("C-t"): K("C-."),
}, "Firefox and Chrome")
```

```
# ~/.config/tridactyl/tridactylrc
bind --mode=browser <C-.> tabopen
```

## Visual mode

As with insert mode, visual mode is entered and left automatically. This happens when text is selected or deselected and can be controlled with `:set visual{enter,exit}auto`.

## N-mode mode

This is a special "meta" mode. It accepts `N` key sequences, regardless of validity, in the underlying mode and then executes the final command provided. There is only one explicit bind in `nmode`: pressing `<Esc>` executes the final command immediately.

E.g. `:nmode [underlying mode] [key sequences to accept] [final ex-string]`. For example, in ignore mode, `<C-o>` is bound to `nmode normal 1 mode ignore`, which allows you to execute one bind in normal mode before returning to ignore mode. In normal mode, `<C-v>` similarly runs `:nmode ignore 1 mode normal` which lets you pass a single key through to a website. I personally find this particularly useful on YouTube: `<C-v>f` toggles fullscreen video by using the default YouTube bind.

# Mapping keys to keys for Tridactyl

You can map single characters to other characters within Tridactyl with `keymap [source] [dest]`.

This is mostly useful for non-QWERTY users who want to be able to use Tridactyl binds without having to rebind lots of them manually. See the wiki for example usage for Cyrillic and bépo layouts: https://github.com/tridactyl/tridactyl/wiki/Internationalisation.

# Getting the command line back

There's nothing in Tridactyl that prevents you from unbinding `:`, the key which lets you access the command line. If this happens to you, you can get it back easily by using the Firefox address bar to run `tri reset :`. In general `tri [ex-command]` is mostly equivalent to running the supplied ex-command in the command line and is very handy in a pinch.

# Viewing binds

You can see binds with bind completions (e.g. `:bind --mode=visual`) or, en masse, with `:viewconfig [name of bind store]`. All of these "store" names end with the word `maps`. For sentimental reasons the most common modes have irregular names. These are:

-   normal mode: `nmaps`
-   insert mode: `imaps`
-   visual mode: `vmaps`

Every other mode, including custom modes, follows the convention `[mode name]maps`. For example, ignore mode has the store `ignoremaps`.

So to view the ignore mode bindings you can run `:viewconfig ignoremaps`. If you wish to only view the bindings that you have set, run `:viewconfig --user ignoremaps`.

For normal mode you can also do `:help [key sequence]`.

There is currently a bug in Tridactyl where the help for ex-strings for other modes, e.g. `hint.` is not available. Follow https://github.com/tridactyl/tridactyl/issue/3626 and https://github.com/tridactyl/tridactyl/issue/2926 for updates.

# Shadowing

If you try to bind to a key sequence for which there already exists a bind to a prefix of that key sequence, you will get a warning and you will be unable to use the bind (although it will still be made).

For example, if you have a bind for `j` and add a bind `jk`, you will get a warning that `jk` is shadowed by `j` - you won't be able to execute `jk` as the bind for `j` will immediately be executed when you press `j`. However, you would be able to bind to `,jk` and execute that bind. If you wished to be able to use `jk` you would first need to run `:unbind j`.

# Custom modes

Creating a new mode is very straightforward: simply add a bind with `:bind --mode=[new modename]`. It's wise to make this first bind be a way to return to normal mode, e.g. `:bind --mode=mynewmode <Esc> mode normal`. You can enter the mode with `:mode [new modename]`. You might want to run this from a bind or in an autocmd, e.g. `:autocmd DocStart ^https://mysite.com mode mysitemode`.

Custom modes can serve a similar purpose to `:bindurl`, but are easier to apply to multiple sites or across parts of a site. For example, you might want a special `video` mode that you trigger on `:autocmd FullscreenEnter`.

## Inheritance

Custom modes are often existing modes plus a few extra binds - by default, for example, `visual` mode is based on `normal` mode and `input` mode (where you can press `<Tab>` to cycle through text boxes) is based on `insert` mode.

We have made this marginally less painful by adding a special optional `🕷🕷INHERITS🕷🕷` field to the bind stores, which tells a mode that it should add its bindings on top of the specified mode. For now, only default bindings are inherited - bindings you make to modes are not inherited - but we'd like to fix that someday.

You can set the field with `set [mode name]maps.🕷🕷INHERITS🕷🕷 [mode name to inherit from]maps`. E.g. `set youtubemaps.🕷🕷INHERITS🕷🕷 ignoremaps` if I had made a `youtube` mode. NB: the `[mode name]maps` follow the naming conventions specified in the "Viewing binds" section.

# Final remarks

The next tips and tricks newsletter will be on the native messenger, but the next newsletter you will receive will be the quarterly newsletter. I'll probably finish that within a week or two. And apologies once again for the lateness of this newsletter!

Thanks for your support, bovine3dom
