//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Avery Vine on 2020-11-24.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
