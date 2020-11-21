//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Avery Vine on 2020-11-21.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
