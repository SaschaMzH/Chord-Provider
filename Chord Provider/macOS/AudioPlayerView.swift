//
//  AudioPlayerView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import AVKit

/// A very simple audio player that is part of the Header View
struct AudioPlayerView: View {
    var song: Song
    @State var audioPlayer: AVAudioPlayer!
    @State var isPlaying: Bool = false
    @State private var showingAlert = false
    var body: some View {
        HStack {
            Button {
                /// Sandbox stuff: get path for selected folder
                if let persistentURL = FileBrowser.getPersistentFileURL("pathSongs") {
                    _ = persistentURL.startAccessingSecurityScopedResource()
                    // todo: move check to song loading
                    // let isReachable = try! persistentURL.checkResourceIsReachable()
                    do {
                        if isPlaying {
                            audioPlayer.stop()
                            audioPlayer = AVAudioPlayer.init()
                        }
                        audioPlayer = try AVAudioPlayer(contentsOf: song.musicpath!)
                        audioPlayer.play()
                        /// For the button state
                        isPlaying = true
                    } catch let error {
                        print(error)
                        showingAlert = true
                    }
                    persistentURL.stopAccessingSecurityScopedResource()
                }            }
                label: {
                    Image(systemName: "play.circle.fill").foregroundColor(.secondary)
                }
                .padding(.leading)
            Button {
                if audioPlayer.isPlaying == true {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play()
                }
            }
            label: {
                Image(systemName: "pause.circle.fill").foregroundColor(.secondary)
            }
            .disabled(!isPlaying)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Ooops..."), message: Text("The audio file was not found."), dismissButton: .default(Text("OK")))
        }
    }
}
