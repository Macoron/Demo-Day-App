//
//  DemoDay_RandomApp.swift
//  Shared
//
//  Created by labsallday labsallday on 05.04.2021.
//

import SwiftUI

@main
struct DemoDay_RandomApp: App {
        
    fileprivate func main() -> ContentView {
        
        // load data from library folder
        let store = PresentationsStore()
        store.loadData()
        
        return ContentView(store: store)
    }
    
    var body: some Scene {
        WindowGroup {
            main()
        }
    }
}
