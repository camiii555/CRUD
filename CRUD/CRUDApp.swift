//
//  CRUDApp.swift
//  CRUD
//
//  Created by MacBook J&J  on 28/01/22.
//

import SwiftUI

@main
struct CRUDApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
