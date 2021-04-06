//
//  ContentView.swift
//  Shared
//
//  Created by labsallday labsallday on 05.04.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var presentations : [Presentation] = []
    @State var addingNew = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // list of all presentations
                    ForEach(presentations) { demo in
                        PresentationCell(presentation: demo)
                        .onTapGesture {
                                editProject(presentation: demo)
                            }
                    }
                    .onMove(perform: moveProjects)
                    .onDelete(perform: deleteProjects)
                             
                    // New element view
                    if addingNew {
                        CreatePresentation(presentations: $presentations, editing: $addingNew)
                    }
                    // add new presentation
                    else {
                        Button("Add new...", action: addNewProject)
                            .foregroundColor(.accentColor)
                            .font(.headline)
                    }
               
                    // total demo day count
                    TotalTime(presentations: presentations)
                }
            }
            .navigationTitle("Presentations")
            .navigationBarItems(trailing: EditButton())
            .listStyle(PlainListStyle())
        }
    }
}

extension ContentView {
    func moveProjects(indices : IndexSet, newOffset : Int) {
        presentations.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func deleteProjects(indices : IndexSet) {
        presentations.remove(atOffsets: indices)
    }
    
    func addNewProject() {
        addingNew = true
    }
    
    func editProject(presentation : Presentation) {
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(presentations: testProjects)
            ContentView(presentations: testProjects, addingNew: true)
        }
    }
}

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
                //.foregroundColor(.secondary)
        }

    }
}

struct TotalTime: View {
    let presentations : [Presentation]
    
    var body: some View {
        HStack {
            Text("Total time:")
            Spacer()
            
            let totalTime = calcTotalTime(presentations)
            Text(totalTime.stringTime)
        }
        .foregroundColor(.secondary)
        .font(.subheadline)
    }
}

struct CreatePresentation: View {
    @Binding var presentations : [Presentation]
    @Binding var editing : Bool
    
    @ObservedObject var presentation = Presentation(name: "")
    
    var body: some View {
        VStack {
            TextField("New presentation...",
                      text: $presentation.name,
                onCommit: {
                    editing = false
                    presentations.append(presentation)
                })
                .font(.title)
                .keyboardType(.webSearch)
            
            Stepper(value: $presentation.speakersCount, in: 1...10) {
                Text("Speakers count: \(presentation.speakersCount)")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 5.0)
        
    }
}
