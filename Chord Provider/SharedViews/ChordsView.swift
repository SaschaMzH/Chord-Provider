//
//  ChordsView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

/// The View with chord diagrams
struct ChordsView: View {
    let song: Song
    let frame = CGRect(x: 0, y: 0, width: 100, height: 150)
    /// Sheet with chords
    @State var showChordSheet = false
    @State var selectedChord: Song.Chord?
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(song.chords.sorted { $0.name < $1.name }) { chord in
                    Group {
                        HStack(alignment: .top, spacing: 0) {
                            Text("\(chord.display)")
                                .foregroundColor(.accentColor)
                                .font(.title2)
                            if chord.isCustom {
                                Text("*")
                            }
                        }
                        let showFingers = !chord.chordPosition.fingers.dropFirst().allSatisfy({ $0 == chord.chordPosition.fingers.first })
                        let layer = chord.chordPosition.chordLayer(rect: frame, showFingers: showFingers)
                        if let image = layer.image() {
#if os(macOS)
                            Image(nsImage: image)
#endif
#if os(iOS)
                            Image(uiImage: image)
#endif
                        } else {
                            VStack {
                                Image(systemName: "music.note")
                                Text("Unknown chord")
                            }
                            .frame(width: 100, alignment: .center)
                            .padding(.vertical)
                        }
                    }
                    .onTapGesture {
                        /// Only show a sheet if the chord is not custom defined
                        if !chord.isCustom {
                            selectedChord = chord
                            showChordSheet = true
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.trailing)
        }
        .sheet(isPresented: $showChordSheet) {
            Sheet(chord: $selectedChord)
        }
    }
}

extension ChordsView {
    
    /// View all chords of a certain key in a sheet
    struct Sheet: View {
        @Environment(\.presentationMode) var presentationMode
        @Binding var chord: Song.Chord?
        var body: some View {
            let chordPosition = chord!.getChordPostions()
            VStack {
                Text("Chord: \(chord!.display)")
                    .font(.title)
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 110))],
                        alignment: .center,
                        spacing: 4,
                        pinnedViews: [.sectionHeaders, .sectionFooters]
                    ) {
                        ForEach(chordPosition) { chord in
                            let frame = CGRect(x: 0, y: 0, width: 120, height: 180)
                            let layer = chord.chordLayer(rect: frame, showFingers: true)
                            let image = layer.image()
#if os(macOS)
                            Image(nsImage: image!)
#endif
#if os(iOS)
                            Image(uiImage: image!)
#endif
                        }
                    }
                }
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("Close")
                    }
                )
                .keyboardShortcut(.defaultAction)
            }
            .padding()
            .frame(minWidth: 400, idealWidth: 400, minHeight: 400, idealHeight: 400)
        }
    }
}
