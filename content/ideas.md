---
title: "Google Summer of Code 2020 ideas page"
date: 2020-01-30T14:56:08Z
draft: false
---

**NB: Unfortunately, Google could not find room for Tridactyl in GSoC 2020**. We would still be happy for anyone to take up any of the projects below, with the caveat that we wouldn't be able to pay them. An invitation (and subsidised travel) to the next Tridactyl retreat would probably be the best we could do.

Tridactyl is a big project with lots of interesting areas where students could make a contribution. This page lists some of the ideas the maintainers have had. Most of them are projects we ourselves would like to undertake but have not had the time to dedicate to them.

General prerequisites for all applicants:

- Some experience of a programming language
    - Tridactyl is predominantly written in TypeScript which is "JavaScript with extra bits". Almost none of our contributors wrote much in it before Tridactyl; you should not be concerned if you haven't either.

Non-mandatory recommendations:

- Some knowledge of Vim (e.g. [the openvim tutorials](https://www.openvim.com/)) or vim-like browser extensions (e.g. [Tridactyl for Firefox](https://addons.mozilla.org/en-US/firefox/addon/tridactyl-vim/), [Vimium for Chrome](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en) or [Qutebrowser](https://www.qutebrowser.org/)).

- Some experience with Linux - building Tridactyl on Windows is possible via Cygwin or the Windows Subsystem for Linux but isn't recommended

- Some experience with `git` and `Git{Hub,Lab}`

## Challenging

The following few projects would be quite challenging (and proportionately rewarding).

### Port Tridactyl to other browsers

Google Chrome has many more users than Firefox. We could get Tridactyl into the hands of many more people if we ported it to Chrome. Many browsers use the same (or similar) WebExtension API as Firefox and can be supported using [webextension-polyfill](https://github.com/mozilla/webextension-polyfill).

The challenges would be:

- Falling back gracefully where a browser doesn't support an API that is used by Tridactyl for an additional feature (i.e. adding a compatibility layer and re-engineering Tridactyl to expect its commands to fail sometimes)

- Complying with all the policies on all of the extension repositories at once

- Testing on all platforms

- Making release and "beta" builds as easy as possible for the maintainers

Rewards:

- Experience refactoring a medium-sized software project (~20k LOC) with thousands of users

- Get to grips with multi-platform support

- Potentially substantially increase the reach of a software project

Prerequisites:

- Some experience with any programming language

We briefly explored this in the past - this [pull request](https://github.com/tridactyl/tridactyl/pull/1683) could be a good place for interested students to start.


Potential mentors: glacambre, saulrh, bovine3dom

### Write a "Keyboard API" for Firefox

Tridactyl is a keyboard-driven interface for Firefox. The most common complaint amongst our users is that Tridactyl cannot accept commands while web pages are loading, while the Firefox UI is focused, or while a "privileged" page such as "about:preferences" is being used.

A simple extension to the WebExtension API would allow Tridactyl to listen for key-events in these scenarios. [Work was started](https://github.com/tridactyl/keyboard-api) on such an API a few years ago. Mozilla, in principle, accepted that such an API could be merged into Firefox. Enough time has passed, however, that consensus will have to be rebuilt with Mozilla about both the detail and the broad structure of the API. In the event that agreement cannot be reached with Mozilla regarding the new API, it could still be used with Tridactyl in Developer, Nightly and custom builds of Firefox.

Such an API would be useful for all extensions like Tridactyl.

Challenges ahead:

- Have to persuade Mozilla that API does not introduce a large attack surface for security issues and that it will not be much work to maintain

- API must be designed such that it is useful for the maximum number of extensions

- API should be designed such that it can be extended in the future

- The API needs to be renamed as Chrome has released a completely unrelated API with [the same name](https://developer.mozilla.org/en-US/docs/Web/API/Keyboard_API). It is a well-known fact that naming things is [a hard computer science problem](https://martinfowler.com/bliki/TwoHardThings.html)

Rewards:

- Potentially get your code into a _huge_ open source project used by hundreds of millions of people

- Improve the health of the WebExtension ecosystem

- Gain experience with dealing with the bureaucracy that comes with such a large project.

Prerequisites:

- Some experience with any programming language

- Some experience with using an API

Potential mentors: saulrh, glacambre, cmcaine, bovine3dom

### Integrate a new parser into Tridactyl

Tridactyl has its own rudimentary vim-style scripting language. The current design was not designed; it emerged as new features were added. It is therefore _bad_.

ELLIOTTCABLE has been working on [a real parser](https://github.com/ELLIOTTCABLE/excmd.js) on and off for about 18 months. It is now nearly ready to be integrated into Tridactyl. Your task would be to integrate it with his help and fix any issues that emerged.

Challenges:

- The messy world of human-computer interaction; we want to drop as much of the crazy stuff from the previous language as possible without upsetting users by breaking their [workflows](https://xkcd.com/1172/).

Rewards:

- A real application of computer science theory - all that stuff about parsers you are learning at University won't be totally useless!

- If you do it right, Tridactyl's maintainers will be very happy as they won't have to roll their own argument parser every time they write a new function

Prerequisites:

- Some experience with any programming language

- Some experience with using an API

- Some knowledge of parsers


## Minor

### Use TreeStyleTab's API

Another highly requested feature is to interoperate with TreeStyleTab. This would be a shorter task than the others. [There is already a PR](https://github.com/tridactyl/tridactyl/pull/1646) that goes some of the way to providing this. The main remaining work is to determine which sorts of features users would like and improve error handling.

Rewards:

- One of our most requested features. Lots of happy users.

Prerequisites: 

- Some experience with using TreeStyleTabs or a similar extension

Potential mentors: saulrh, bovine3dom

### Lazy iframe injection

The way we inject our iframe which contains our command line and most of our interface currently [breaks quite a few websites](https://github.com/tridactyl/tridactyl/issues/639). We should instead insert it only when it is required. We attempted this [about a year ago](https://github.com/tridactyl/tridactyl/pull/1331) but ran into an issue where the command had to be executed twice to work.

Challenges:

- There is a race condition somewhere (which is always lost) which prevents the iframe from being displayed until it is asked for a second time

- Tridactyl is a large project; we don't know how many (if any) parts of it rely on the iframe being present on each page

Rewards:

- Fix the issue that prevents Tridactyl from working on quite a few pages

- Experience with debugging race conditions in real-world asynchronous code

Prerequisites:

- Some experience with a programming language

- Some experience with asynchronous code

Potential mentors: bovine3dom, glacambre, saulrh

## Just for fun

### Gamepadactyl

We have [an open pull request](https://github.com/tridactyl/tridactyl/pull/1814) that adds limited gamepad support to Tridactyl. After getting detection, hinting and text input to work well (for example, see Steam's Xbox 360 flower keyboard) with a decent theme it could turn Tridactyl into a good way of browsing the net on a big screen.

Challenges:

- A good test suite must be set up as it will be unlikely to see much real-world usage unless heavily advertised (perhaps as a separate extension)

Rewards:

- Make progress in a little-explored area (controlling a web browser with a gamepad)

Prerequisites:

- Some experience with a programming language

- Ownership of a gamepad (preferably, a variety of gamepads)

Potential mentors: bovine3dom, glacambre


## Moonshots

The following project has a slim chance of success.

### Port GeckoView to x86_64

GeckoView is Mozilla's answer to Chrome's WebView - it is a lightweight web browser that is intended to be embedded in Android applications. Given enough willpower, it could be ported to desktop computers with bindings written in a popular language (e.g. Python, or, as the maintainers would like, Julia). It could then serve as an alternative to Electron and Tridactyl could be ported to it. GeckoView itself already supports a subset of the WebExtension API so it could be somewhat straightforward.

GeckoView itself is under active development and so is something of a moving target.

The mentors are somewhat reluctant to mentor this project; a student would need to be very persuasive to be accepted.

Challenges:

- None of the mentors have much experience with Android

- GeckoView is not yet finalised; it is a moving target

- The resulting project should require minimal maintenance

Rewards:

- Create an alternative to Electron and help to reduce the dominance of KHTML/WebKit/Blink based browser engines

Prerequisites:

- In-depth knowledge of C++

- Willingness for a project to "fail"

Potential mentors: saulrh, bovine3dom, cmcaine

## Your own idea!

We'd be delighted to hear from students who have an idea completely of their own. Be sure to [contact us first](/chat/) to get a feel for how achievable we think your idea is. You might also wish to look at the [GitHub issue where we came up with the ideas that made this page](https://github.com/tridactyl/tridactyl/issues/2107) or any of our [GitHub issues](https://github.com/tridactyl/tridactyl/issues/).
