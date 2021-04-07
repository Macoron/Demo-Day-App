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
            .navigationBarItems(leading: ShareCancelButton(store: store, addingNew: $addingNew),trailing: SmartEditButton(store: store))
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

struct SmartEditButton : View {
    @Environment(\.editMode) var editMode
    
    @StateObject var store : PresentationsStore
    
    var body: some View {
        HStack {
            if (store.presentations.count > 0 || editMode?.wrappedValue.isEditing == true)  {
                EditButton()
            }
        }
    }
}

struct ShareCancelButton : View {
    @StateObject var store : PresentationsStore
    @Binding var addingNew : Bool
    
    var body: some View {
        HStack {
            if addingNew {
                Button("Cancel") {
                    addingNew = false
                }
            }
            else {
                if store.presentations.count > 0  {
                    Button(action: shareProjects, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                }
            }
        }
    }
    
    func shareProjects() {
        let data = store.createTextReport()
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        
        let vc = UIApplication.shared.windows.first?.rootViewController
        vc?.present(av, animated: true, completion: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            av.popoverPresentationController?.sourceRect = CGRect(
                x: 0,y: UIScreen.main.bounds.height,
                width: UIScreen.main.bounds.width / 2,
                height: UIScreen.main.bounds.height / 2
            )
        }
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
