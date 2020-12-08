//
//  BuildHtml.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 03/12/2020.
//

import SwiftUI

func BuildSong(song: Song, chords: Bool) -> String {
    
    var html = """
               <!DOCTYPE html>
               <html lang="en">
               <head>
                 <meta charset="utf-8">
                 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=yes">
               <style>
               :root {
                 supported-color-schemes: light dark;
               """
    /// Add system cpoulors to the css
    html += "--accentColor: " + GetAccentColor() + ";"
    html += "--highlightColor: " + GetHighlightColor() + ";"
    html += "}"
    /// Add the main CSS
    if let filepath = Bundle.main.path(forResource: "style", ofType: "css") {
        do {
            let contents = try String(contentsOfFile: filepath)
            html += contents
        } catch {
            print(error)
        }
    }
    html += "</style><script>"
    /// Add Chords javascript
    if let jspath = Bundle.main.path(forResource: "chords", ofType: "js") {
        do {
            let contents = try String(contentsOfFile: jspath)
            html += contents
        } catch {
            print(error)
        }
    }
    html += """
            </script>
            </head>
            <body>
            <div id="container">
            """

    /// List of chords
    if chords {
        html += ChordsList(song)
    }
    html += "<div id=\"grid\">"
    song.sections.forEach { section in
        html += SectionView(section)
        if !section.lines.isEmpty {
            html += "<div class=\"lines\">"
            section.lines.forEach { (line) in
                if !line.measures.isEmpty {
                    html += MeasuresView(line)
                } else if line.tablature != nil {
                    html += "<div class=\"tablature\">" +  line.tablature! + "</div>"
                } else if line.comment != nil {
                    html += "<div class=\"comment\">" +  line.comment! + "</div>"
                } else if (section.type == nil) {
                    html += "<div class=\"plain\">"
                    html += PlainView(line)
                    html += "</div>"
                } else {
                    html += PartsView(line)
                }
            }
            html += "</div>"
        }
    }
    html += "</div>"
    html += "<script>chords.replace()</script>"
    html += "</body></html>"

    return html
}

func SectionView(_ section: Section) -> String {
    var html = ""

    html += "<div class=\"section "
    if section.lines.isEmpty {
        html += "empty "
    }
    html += (section.type != nil ? section.type! : "")
    html += "\">"
    html += (section.name != nil ? section.name! : "&nbsp;")
    html += "</div>"
    
    return html
}

func MeasuresView(_ line: Line) -> String {

    var html = "<div class=\"measures\">"
    line.measures.forEach { (measure) in
        html += "<div class=\"measure\">"
        measure.chords.forEach { (chord) in
            html += "<div class=\"chord\">" + chord + "</div>"
        }
        html += "</div>"
    }
    html += "</div>"
    
    return html
}

func PartsView(_ line: Line) -> String {
    
    var html = "<div class=\"line\">"
    line.parts.forEach { (part) in
        html += "<div class=\"part\"><div class=\"chord\">"
        html += (part.chord != "" ? part.chord!: "&nbsp;")
        html += "</div><div class=\"lyric\">\(part.lyric!)</div></div>"
    }
    html += "</div>"
    
    return html
}

func PlainView(_ line: Line) -> String {
    
    var html = "<div class=\"line\">"
    line.parts.forEach { (part) in
        html += "<div class=\"plain\">\(part.lyric!)</div>"
    }
    html += "</div>"
    
    return html
}

func ChordsList(_ song: Song) -> String {

    let sortedChords = song.chords.sorted(by: { $0.0 < $1.0 })
    
    var html = "<div id=\"chords\">"
    
    if !song.chords.isEmpty {
    
    sortedChords.forEach { (chord) in
        let match = processChord(chord: chord.key, baseFret: chord.value)
        if !match.isEmpty {
            let result = cleanChord(match.first!)
            html += "<div>"
            html += "<chord accentColor=\"\(GetAccentColor())\" highlightColor=\"\(GetSystemBackground())\" chordColor=\"\(GetTextColor())\" name=\"\(chord.key)\" positions=\"\(result.frets)\" fingers=\"\(result.fingers)\" size=\"3\" ></chord>"
            html += "</div>"
        }
        else {
            html += "<div class=\"warning\"><div class=\"warningkey\">\(chord.key)</div>"
            if !chord.value.isEmpty {
                html += "base fret \(chord.value.prefix(1))</br>"
            }
            html += "is unknown."
            html += "</div>"
        }
    }
    }
    else {
        html += "No chords"
        print("No chords")
    }
    html += "</div>"
    
    return html
}
