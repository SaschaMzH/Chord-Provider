# Chord Provider

## A Cordpro file parser and editor in SwiftUI 4

There are many "chordpo" parsers in this world, however, none are *really* native in the Apple world.

I mean, in the macOS world, it is often an afterthought... Not for me. I'm mainly a mac user; the iPad version is my afterthought...

![Chord Provider](screenshot.png)

Written in SwiftUI 4, so macOS Ventura or iPadOS 16 only.

The branch 'SwiftUI-3' has an older version for macOS Monterey or iOS 15, however, I don't update that version anymore.

### macOS

- It has a 'browser' for your songs if you select a folder.
- It can export your songs to PNG images. Can't get PDF done yet; work in progess.
- It has a 'quick view' plugin for ChordPro files.

### Limitations

Well, Chord Provider a simple application. There are a lot better 'chord' applications and I wrote this just for fun. It serves me well but I know it's not that great. It might serve you well, as a 'chord' programm or as a sample for a 'document based SwiftUI' application. SwiftUI is fun and great, however, also limited and challenging; especialy on macOS. There are many 'workarounds' in the code; especialy for 'window handling'.'

### iCloud

The iOS app will make an iCloud folder named "Chord Provider"; that's where your songs should be stored. In the macOS app, you can select a folder with your songs. If you use the same iCloud folder; updates are instantly.

### Known issues

- When you switch from light to dark mode and visa-versa; the chord diagrams are not updated.
- SwiftUI 'DocumentGroup', used to show the songs, is very buggy and limited.
- 'Pinch to zoom' is buggy on macOS. Sometimes it just stops working. There is a 'zoon' toggle in the toolbar.
- The 'Browser' for macOS is not too smart; it does not update when you add or delete files in the Finder while Chord Provider is open.
- The 'song' is rendered in a SwiftUI View, so, a bit sluggisch... But fancy!

### Thanks

Stole code (and ideas) from:

- [SongPro for Swift](https://github.com/SongProOrg/songpro-swift)
- [Conscriptor](https://github.com/dbarsamian/conscriptor)

### Used packages

The chord diagrams are made with [Swifty Guitar Chords](https://github.com/BeauNouvelle/SwiftyGuitarChords)

The macOS editor is [HighlightedTextEditor](https://github.com/kyle-n/HighlightedTextEditor)

## How to compile

1. Clone the project.
2. Change the signing certificate to your own.
2. Build and run!
