//
//  ContentView.swift
//  Shared
//
//  Created by Alex Evgrashin on 05.04.2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var store = PresentationsStore()
    @State var addingNew = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Placeholder for empty list
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
                    
                    // New element creation view
                    if addingNew {
                        CreatePresentation(store: store, editing: $addingNew)
                    }
                    // add new presentation button
                    else {
                        Button("Add new...", action: addNewProject)
                            .foregroundColor(.accentColor)
                            .font(.headline)
                            .onTapGesture {
                                addNewProject()
                            }
                    }
                    
                    // total demo day time
                    if !isEmpty {
                        TotalTime(store: store)
                    }
                }
                
                // shuffle all presentations
                if store.presentations.count >= 2 {
                    Button("Shuffle") {
                        shufflePresentations()
                    }
                    .padding()
                }
            }
            .navigationTitle("Presentations")
            .toolbar(content: {
                SmartEditButton(store: store)
            })
            .navigationBarItems(leading: ShareCancelButton(store: store, addingNew: $addingNew))
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
        store.saveData()
    }
    
    func deleteProjects(indices : IndexSet) {
        store.presentations.remove(atOffsets: indices)
        store.saveData()
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
        store.saveData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(store: PresentationsStore())
            ContentView(store: testStore)
            ContentView(store: testStore, addingNew: true)
            ContentView(store: testStore, addingNew: true)
                .environment(\.locale, .init(identifier: "ru"))
        }
    }
}
