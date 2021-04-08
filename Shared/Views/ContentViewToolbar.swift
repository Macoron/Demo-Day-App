//
//  ContentViewToolbar.swift
//  DemoDay Random (iOS)
//
//  Created by Alex Evgrashin on 07.04.2021.
//

import SwiftUI

// Conditional edit button
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

// Share and cancel view
// Implements sharing logic
struct ShareCancelButton : View {
    @StateObject var store : PresentationsStore
    @Binding var addingNew : Bool
    
    var body: some View {
        HStack {
            if addingNew {
                Button("Cancel") {
                    withAnimation() {
                        addingNew = false
                    }
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
        
        // iPad has a nasty crash, this will protect from it
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
