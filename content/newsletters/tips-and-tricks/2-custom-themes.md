---
title: "Tips & Tricks 2: custom themes"
date: "31 Jan 2021 12:00:00 +0100"
draft: false
---

Hi, and welcome to the second Tridactyl tips and tricks newsletter. This is the first paywalled one going out to sponsors paying 10$ a month or more, so thanks!

# Custom themes

Themes have a lot of control over Tridactyl's appearance - just try `:colours halloween` versus `:colours shydactyl` and `:colours quake` to see what I mean. (Protip: press Ctrl-Enter with a completion selected to execute it without closing the command line to test out themes quickly.)

Unfortunately, themes have long been a poorly documented and slightly bizarre part of Tridactyl. While writing this guide, I ended up going back to Tridactyl and simplifying how themes are made and written several times rather than try to explain and justify our idiosyncrasies.

NB: this is for the current Tridactyl Beta or yet-to-be-released stable 1.21.0+. Themes in Tridactyl Stable are still confusing : )

# Loading custom themes

When you run `:colours [themename]`, if `themename` is not a built-in theme, Tridactyl uses `:native` to try to read `themes/themename/themename.css` from the same directory where your RC file is located. If you don't have an RC file Tridactyl will throw an error. It then stores this CSS file as a string in your Tridactyl configuration as `customthemes.[themename]`. Regardless of whether the theme is built-in or not, it then runs `:set theme [themename]` which tells Tridactyl to refresh the theme on the current page. If loading the theme from disk doesn't work, Tridactyl tries to load the theme from its internal storage instead.

Similarly to reading themes from disk, you can run `:colours --url [url] [theme name]` to download and install a theme from the internet with no need for `:native`. After you have downloaded it once you can switch back to the theme with `:colours [theme name]`.

# Writing your own theme

There are many tutorials online on how to use CSS to style web pages. Styling Tridactyl is very similar.

The one key difference is that our default theme uses lots of variables specifically designed to make theming Tridactyl simpler. These variables set the colour of various elements of Tridactyl which are similar. For example, `--tridactyl-bg` sets the background colour of most parts of Tridactyl. You can find these variables and their default settings in the default theme, located in the [Tridactyl themes folder](https://github.com/tridactyl/tridactyl/tree/1d9380d183679e09d9db83d62e6a01b5d3b210e3/src/static/themes/default/default.css). The default theme is loaded into every page so every other theme can fall back to it if there is nothing defined for a variable.

One simple theme, then, is to just change the colours of a few things in Tridactyl, like this excerpt from the default `greenmat` theme does:

```
:root {
    --tridactyl-fg: #00eb00;
    --tridactyl-bg: #001500;
    --tridactyl-cmdl-fg: #00eb00;
    --tridactyl-cmdl-bg: #001500;
}
```

Simply put that in a file in the folder specified earlier, e.g. `~/.config/tridactyl/themes/mydark/mydark.css` and run `:colours mydark` in Tridactyl to set it.

We strongly recommend you use the CSS variables we provide where possible as it means that if we add a new element to Tridactyl, it is very likely that it will have colours that fit with your theme with no need for you to update it.

If you want to change Tridactyl's appearance more drastically, the best way to learn more is to look at the included default themes, for example the quakelight theme: https://github.com/tridactyl/tridactyl/blob/master/src/static/themes/quakelight/quakelight.css. The base Tridactyl theme is located at `src/static/css/` in the [Tridactyl source](https://github.com/tridactyl/tridactyl/tree/1d9380d183679e09d9db83d62e6a01b5d3b210e3/src/static/css) and is always loaded into every page as a base theme.

... and that's pretty much it for this newsletter, I think!

I don't want to get deep into how you can use CSS for controlling how elements are displayed - there are plenty of tutorials online for doing that. [MDN's tutorial](https://developer.mozilla.org/en-US/docs/Learn/CSS/First_steps/Getting_started) is good.

# Final thoughts

I hope no-one feels shortchanged from this shorter tutorial - a lot of time went into making creating and installing new themes less weird. If anyone has any specific questions I'd be delighted to answer them.

Thank you all for your support as always. Next months' tutorial will probably be on creating custom ex-commands.

Cheers,
bovine3dom
