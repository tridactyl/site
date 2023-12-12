---
title: "Tips & Tricks 3: custom ex-commands"
date: "2 Mar 2021 12:00:00 +0100"
draft: false
---


Welcome to the third tips & tricks newsletter for donors!

To really unlock the power of Tridactyl, you'll want to write your own ex-commands to automate actions that you do frequently. This clearly is a very broad topic, so in this tutorial I'm just going to cover how to create an ex-command that accepts arguments, `:composite` for combining ex-commands, and how to use `:js` and `:jsb` to create more complex commands.

# Ex-aliases: naming commands

`:command [alias] [ex string]` is a very simple way of creating your own ex-command for convenience. Once an alias is set, any time that alias is used as an ex-command it is replaced with the ex string that it represents, with any subsequent arguments left unmodified. For example, `:command tbb tabpen -b` would mean that `:tbb news.bbc.co.uk` would open BBC news in a background tab. Aliases automatically get completions for their underlying ex-command.

# Stringing commands together with `:composite`

If you want to use multiple commands you can use `:composite [ex string]; [ex string] ...` to chain them together. A classic example is the default `D` bind of `:composite tabclose; tabprev` which closes a tab and then takes you to the tab to the left rather than the default Firefox behaviour of going to the right.

In some circumstances ex-commands return useful values. These can be passed as strings as the last argument to the next ex-string in the sequence by separating the commands with pipes, `|`, rather than semi-colons. Very few default ex-commands do this - `:current_url` is one, as is `:shellescape` - but it is quite common for custom commands that use `:js` or :`jsb` to do this.

For example, the following two lines are equivalent:

```
composite current_url | fillcmdline_notrail open
composite js document.location.href | fillcmdline_notrail open
```

**NB:** `:composite` steals semi-colons from `:js`, etc. If you need to use a semi-colon in `:js`, simply make it into a `:command` first and use that instead.

# `:js` and `:jsb` for more flexibility

But what if you want to supply arguments to an ex-string in a place other than the start? This is where you need to each for `:js` or its counterpart for the background script (more on that later), `:jsb`. These commands execute scripts in JavaScript in the current tab or background script respectively.

There are two ways to supply an argument to a `:js{,b}` command: you may provide a `-p` flag, which accepts a single argument and stores it in the magic variable `JS_ARG`, or `-d[char]` where you supply a terminating character which you will use in your script, and then space separated arguments are stored in a magic `JS_ARGS` array. Note that both of these flags only make sense if you don't execute them immediately; the most common usage is via an ex-alias of `:command js -p ...`, which merely stores the ex string for later execution.

Here are a couple of examples:

```
:command loudecho_oneword js -p window.alert(JS_ARG)
:loudecho_oneword LOUD
:command loudecho_morewords js -dŐ window.alert(JS_ARGS.join(" "))Ő
:loudecho_morewords THIS IS LOUD
```

I don't want to get into too much detail about what things are available with `:js` and `:jsb`. If you want to explore it you'll find most interesting things are available on the `tri` and `browser` objects. Run `:js console.log(tri)` and look in the Firefox web console to see it interactively.

Particularly of note is `tri.excmds` which contains all of the ex-commands in Tridactyl. For example, the following lines are identical:

```
:tabopen search meaning of life
:js tri.excmds.tabopen("search", "meaning", "of", "life")
```

If you need to write an async function in `:js` simply use a closure:

```
:js (async () => {...})()
```

`:composite` automatically awaits the result of any promises returned, so you can pipe the results into other ex-commands if you wish.

# Content `:js` versus background `:jsb`

To understand the difference between `:js` and `:jsb` you unfortunately are going to have to learn more about the architecture of WebExtensions than you may have otherwise wished. `:js` runs in Tridactyl's content script in the current active tab. `:jsb` runs in Tridactyl's background script.

The content script has access to the page you are on - with a real `window` object - but very few `browser` functions, such as those for opening new tabs. Tridactyl provides a `tri.browserBg` proxy that allows you to access almost all of these. Additionally, all ex-commands are accessible via `tri.excmds` in both content and background scripts. However, `:js` requires Tridactyl to be running in the active tab - so running things in `:js` from your RC file, which often runs before Tridactyl has loaded in any tabs, is a bad idea. Errors and logs from the content script appear in the normal Firefox Web Console, accessible by pressing ctrl-shift-k.

The background script has access to many more `browser` functions and is much longer lived that the content scripts, which typically reload with every page navigation, but it has no direct access to any web pages. If you need to pass information between `:js` and `:jsb`, simply use `:composite`. Errors and output from the background script only appears in the Browser Console, accessible via `about:debugging` and clicking on "Inspect" next to Tridactyl on the "This Firefox" tab.

There is an extra caveat here in that content scripts on Tridactyl's own pages - the new tab page, the help pages etc. - have access to many of the objects that are otherwise only available in the background script. This can be useful - it means you can explore the objects available in the background scripts without having to open `about:debugging` to access the Browser Console in Tridactyl's background context - but more often it just catches people out who craft `:js` commands which only work on the new tab pages. I'd suggest firmly that you develop your scripts on "real" pages therefore.

# Getting further help

The best place to find information on how to use the WebExtension API is the [MDN website](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions). Usually simply searching for e.g. "create tab MDN" on your favourite search engine will be enough to get you to the right page.

Otherwise, `:help composite`, `:help command` and `:help js` all contain useful information.

# Final thoughts

I hope this tutorial was useful. I'm hoping to add custom completions for custom ex-commands within the next few months but I can't promise anything yet.

The next tips & tricks newsletter is going to be on modes and key binds; the one after that will be on using the native messenger. After those two the future of this newsletter is a little uncertain - I'm going to have to seriously consider whether it's the best use of my time. Tridactyl donations have actually fallen from a peak of 800 EUR a month to about 200 EUR a month currently; if that continues to the case I'll have to reduce the amount of time I spend on Tridactyl. I suspect writing these newsletters is one of the least productive things I can do for Tridactyl so it probably makes sense to cut back on these rather than other more directly important things such as bug fixes. I'll tell you all what I've decided as soon as I've decided it.

Feedback as usual is welcome (desired, even!) - you can contact me at oliver@blanthorn.com or on Matrix.

Thanks as always for your continued support, bovine3dom
