//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Avery Vine on 2020-11-24.
//

import CoreData
import SwiftUI

enum FilteredListPredicate {
    case beginsWith(isCaseSensitive: Bool)
    case contains(isCaseSensitive: Bool)
    
    var rawValue: String {
        switch self {
        case .beginsWith(isCaseSensitive: let isCaseSensitive):
            return "BEGINSWITH\(isCaseSensitive ? "" : "[c]")"
        case .contains(isCaseSensitive: let isCaseSensitive):
            return "CONTAINS\(isCaseSensitive ? "" : "[c]")"
        }
    }
    
    var formattedName: String {
        switch self {
        case .beginsWith:
            return "Begins With"
        case .contains:
            return "Contains"
        }
    }
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    typealias Predicate = FilteredListPredicate
    
    var fetchRequest: FetchRequest<T>
    var entities: FetchedResults<T> { fetchRequest.wrappedValue }
    var content: (T) -> Content
    
    var body: some View {
        List(entities, id: \.self) { entity in
            content(entity)
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    init(filterKey: String, predicate: Predicate, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K \(predicate.rawValue) %@", filterKey, filterValue))
        self.content = content
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(filterKey: "lastName", predicate: .beginsWith(isCaseSensitive: false), filterValue: "S", content: { (singer: Singer) in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        })
    }
}
