//
//  ContentView.swift
//  WordScramble
//
//  Created by Avery Vine on 2020-10-11.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var multiplier = 1
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var isShowingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                .listStyle(InsetGroupedListStyle())
                
                Text("Multiplier: \(multiplier)x")
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                Text("Score: \(score)")
                    .font(.title)
                    .padding(.bottom, 20)
            }
            .navigationTitle(rootWord)
            .navigationBarItems(trailing: Button(action: startGame) {
                Image(systemName: "arrow.clockwise")
            })
            .onAppear(perform: startGame)
            .alert(isPresented: $isShowingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func startGame() {
        guard let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"),
              let startWords = try? String(contentsOf: startWordsUrl) else {
            fatalError("Could not load start.txt from bundle.")
        }
        let allWords = startWords.components(separatedBy: "\n")
        rootWord = allWords.randomElement() ?? "silkworm"
        usedWords.removeAll()
        calculateScore()
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !answer.isEmpty else { return }
        
        guard isWordUnique(answer) else {
            setWordError(title: "Word Already Used", message: "Be more original!")
            return
        }
        
        guard isWordPossible(answer) else {
            setWordError(title: "Word Not Recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isWordValid(answer) else {
            setWordError(title: "Word Not Possible", message: "That isn't a real word!")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
        
        calculateScore()
    }
    
    func isWordUnique(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isWordPossible(_ word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isWordValid(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isWordAllowed(_ word: String) -> Bool {
        return word.count > 2 && word != rootWord
    }
    
    func setWordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        isShowingError = true
    }
    
    func calculateScore() {
        multiplier = usedWords.count / 5 + 1
        score = usedWords.reduce(0, { score, word in
            score + word.count
        }) * multiplier
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
