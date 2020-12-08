//
//  RealView.swift
//  Make chords (macOS)
//
//  Created by Nick Berendsen on 29/11/2020.
//

import SwiftUI

struct SongView: View {
    var song = Song()
    
    @StateObject var metro = Metronome()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showMetronome") var showMetronome: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        let html = BuildSong(song: song, chords: showChords)
        VStack {
            HtmlView(html: html)
        }
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showEditor.toggle()
                        
                }
                } ) {
                    HStack {
                        //Image(systemName: "pencil").foregroundColor(.accentColor)
                        Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle").foregroundColor(.accentColor)
                        Text(showEditor ? "Hide editor" : "Edit song")
                        
                    }
                }
            }
            #if os(iOS)
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showMetronome.toggle()
                        self.metro.resetTimer()
                        metro.beep = false
                }
                } ) {
                    HStack {
                        Image(systemName: showMetronome ? "metronome.fill" : "metronome").foregroundColor(.accentColor)
                        Text(showMetronome ? "Hide metronome" : "Show metronome")
                        
                    }
                }
            }
            #endif
            ToolbarItem() {
                Button(action: {
                    withAnimation {
                        showChords.toggle()
                }
                } ) {
                    HStack {
                        Image(systemName: showChords ? "number.square.fill" : "number.square").foregroundColor(.accentColor)
                        Text(showChords ? "Hide chords" : "Show chords")
                        
                    }
                }
            }
            #if os(macOS)
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                } ) {
                    Image(systemName: "sidebar.left").foregroundColor(.accentColor)
                }
            }
            #endif
        }
    }
}


