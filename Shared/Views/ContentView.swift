//
//  ContentView.swift
//  Shared
//
//  Created by labsallday labsallday on 05.04.2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var store = PresentationsStore()
    @State var addingNew = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if isEmpty && !addingNew {
                        Text("No presentations found")
                            .foregroundColor(.secondary)
                    }
                    
                    // list of all presentations
                    ForEach(store.presentations) { demo in
                        PresentationCell(presentation: demo)
                    }
                    .onMove(perform: moveProjects)
                    .onDelete(perform: deleteProjects)
                    
                    // New element view
                    if addingNew {
                        CreatePresentation(store: store, editing: $addingNew)
                    }
                    // add new presentation
                    else {
                        Button("Add new...", action: addNewProject)
                            .foregroundColor(.accentColor)
                            .font(.headline)
                    }
                    
                    // total demo day count
                    if !isEmpty {
                        TotalTime(store: store)
                    }
                }
                
                if store.presentations.count >= 2 {
                    HStack {
                        Button("Shuffle") {
                            shufflePresentations()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Presentations")
            .navigationBarItems(leading:
                                    HStack {
                                        if addingNew {
                                            Button("Cancel") {
                                                addingNew = false
                                            }
                                        }
                                        else {
                                            if !isEmpty {
                                                Button(action: shareProjects, label: {
                                                    Image(systemName: "square.and.arrow.up")
                                                        .frame(width: 50.0, height: 50.0)
                                                })
                                            }
                                        }
                                    },
                                trailing: HStack {
                                    if !isEmpty {
                                        EditButton()
                                            .frame(width: 50.0, height: 50.0)
                                    }
                                })
            .listStyle(PlainListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ContentView {
    var isEmpty : Bool {
        return store.presentations.isEmpty
    }
    
    func moveProjects(indices : IndexSet, newOffset : Int) {
        store.presentations.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func deleteProjects(indices : IndexSet) {
        store.presentations.remove(atOffsets: indices)
    }
    
    func addNewProject() {
        withAnimation() {
            addingNew = true
        }
    }
    
    func shufflePresentations() {
        withAnimation() {
            store.presentations.shuffle()
        }
    }
    
    func shareProjects() {
        let data = store.createTextReport()
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(store: PresentationsStore())
            ContentView(store: testStore)
            ContentView(store: testStore, addingNew: true)
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
    let store : PresentationsStore
    
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
