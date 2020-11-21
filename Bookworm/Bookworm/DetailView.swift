//
//  DetailView.swift
//  Bookworm
//
//  Created by Avery Vine on 2020-11-21.
//

import CoreData
import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    
                    VStack(alignment: .trailing) {
                        Text(book.genre?.uppercased() ?? "FANTASY")
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Capsule())
                        
                        if book.date != nil {
                            Text("Added \(dateFormatter.string(from: book.date ?? Date()))")
                                .font(.caption)
                                .fontWeight(.black)
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Capsule())
                        }
                    }
                    .offset(x: -5, y: -5)
                }
                
                Text(book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text((book.review?.isEmpty ?? true) ? "No Review" : book.review!)
                    .foregroundColor((book.review?.isEmpty ?? true) ? .secondary : .primary)
                    .padding()
                
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"),
                  message: Text("Are you sure you want to delete \(book.title ?? "this book")?"),
                  primaryButton: .destructive(Text("Delete")) { deleteBook() },
                  secondaryButton: .cancel())
        }
        .toolbar {
            Button(action: {
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
            }
        }
    }
    
    private func deleteBook() {
        viewContext.delete(book)
        try? viewContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let previewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: previewContext)
        book.title = "The Wizard of Oz"
        book.author = "L. Frank Baum"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        book.date = Date()
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
