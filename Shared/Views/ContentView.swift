//
//  ContentView.swift
//  Shared
//
//  Created by labsallday labsallday on 05.04.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var presentations : [Presentation] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // list of all presentations
                List {
                    ForEach(presentations) { demo in
                        PresentationCell(presentation: demo)
                        .onTapGesture {
                                editProject(presentation: demo)
                            }
                    }
                    .onMove(perform: moveProjects)
                    .onDelete(perform: deleteProjects)
                                        
                    // total demo day count
                    TotalTime(presentations: presentations)
                }

                // add new presentation
                Button("Add new...", action: addNewProject)
                    .foregroundColor(.accentColor)
                    .padding()
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
        
    }
    
    func editProject(presentation : Presentation) {
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(presentations: testProjects)
    }
}

struct PresentationCell: View {
    let presentation : Presentation
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(presentation.name)
                    .font(.headline)
                Text("Members: \(presentation.membersCount)")
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
