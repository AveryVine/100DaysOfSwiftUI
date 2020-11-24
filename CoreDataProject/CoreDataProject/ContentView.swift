//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Avery Vine on 2020-11-24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var lastNameFilter = "A"
    @State private var predicate: FilteredListPredicate = .beginsWith(isCaseSensitive: false)
    @State private var isPredicateCaseSensitive: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                FilteredList(filterKey: "lastName", predicate: predicate, filterValue: lastNameFilter, content: { (singer: Singer) in
                    Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
                })

                Button("Add Examples") {
                    let taylor = Singer(context: viewContext)
                    taylor.firstName = "Taylor"
                    taylor.lastName = "Swift"

                    let ed = Singer(context: viewContext)
                    ed.firstName = "Ed"
                    ed.lastName = "Sheeran"

                    let adele = Singer(context: viewContext)
                    adele.firstName = "Adele"
                    adele.lastName = "Adkins"

                    try? viewContext.save()
                }

                Button("Show A") {
                    lastNameFilter = "A"
                }

                Button("Show S") {
                    lastNameFilter = "S"
                }
                
                Button("Toggle Predicate (currently \(predicate.formattedName))") {
                    if case .contains = predicate {
                        predicate = .beginsWith(isCaseSensitive: isPredicateCaseSensitive)
                    } else {
                        predicate = .contains(isCaseSensitive: isPredicateCaseSensitive)
                    }
                }
                
                Button("Toggle Case Sensitive (currently \(isPredicateCaseSensitive ? "Yes" : "No"))") {
                    isPredicateCaseSensitive.toggle()
                }
            }
            .navigationBarTitle("Singer Last Names")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
