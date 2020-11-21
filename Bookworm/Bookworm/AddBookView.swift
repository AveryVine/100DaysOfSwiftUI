//
//  AddBookView.swift
//  Bookworm
//
//  Created by Avery Vine on 2020-11-21.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 4
    @State private var genre = "Fantasy"
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: viewContext)
                        newBook.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        newBook.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review.trimmingCharacters(in: .whitespacesAndNewlines)
                        newBook.date = Date()
                        
                        try? viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                || author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
