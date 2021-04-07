//
//  ContentViewCells.swift
//  DemoDay Random (iOS)
//
//  Created by labsallday labsallday on 07.04.2021.
//

import SwiftUI

// Show presentation in list
struct PresentationCell: View {
    let presentation : Presentation
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(presentation.name != "" ? presentation.name : "Unnamed")
                    .font(.headline)
                Text("Speakers: \(presentation.speakersCount)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            Text("\(presentation.assumedTime.stringTime)")
                .font(.subheadline)
        }
    }
}

// Show total time of all presentations
struct TotalTime: View {
    @ObservedObject var store : PresentationsStore
    
    var body: some View {
        HStack {
            Text("Total time:")
            Spacer()
            
            let totalTime = store.calcTotalTime()
            Text(totalTime.stringTime)
        }
        .foregroundColor(.secondary)
        .font(.subheadline)
    }
}

// Create new presentation and add it to store
struct CreatePresentation: View {
    @ObservedObject var store : PresentationsStore
    @Binding var editing : Bool
    
    @State var name : String = ""
    @State var speakersCount = 1
    
    var body: some View {
        VStack {
            TextField("New presentation...",
                      text: $name,
                      onCommit: {
                        withAnimation() {
                            editing = false
                            
                            let ret = Presentation(name: name, speakersCount: speakersCount)
                            store.presentations.append(ret)
                            store.saveData()
                            
                            reset()
                        }
                      })
                .font(.title)
                .keyboardType(.webSearch)
            
            Stepper(value: $speakersCount, in: 1...10) {
                Text("Speakers count: \(speakersCount)")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 5.0)
        
    }
    
    func reset() {
        name = ""
        speakersCount = 1
    }
}
