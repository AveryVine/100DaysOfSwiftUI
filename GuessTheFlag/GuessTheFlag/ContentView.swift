//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Avery Vine on 2020-09-29.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black, lineWidth: 1)
            )
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    private static var numberOfFlags = 3
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "The UK", "The US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ..< numberOfFlags)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var score = 0
    
    @State private var rotationAmounts = Array(repeating: 0.0, count: numberOfFlags)
    @State private var tipForwardAmounts = Array(repeating: 0.0, count: numberOfFlags)
    @State private var opacities = Array(repeating: 1.0, count: numberOfFlags)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< Self.numberOfFlags) { number in
                    Button(action: {
                        if number == correctAnswer {
                            withAnimation(.interpolatingSpring(stiffness: 20, damping: 6)) {
                                rotationAmounts[number] += 360
                            }
                        } else {
                            withAnimation(.easeIn(duration: 1.5)) {
                                tipForwardAmounts[number] += 89.5
                            }
                        }
                        withAnimation {
                            Array(0 ..< Self.numberOfFlags).filter {
                                $0 != number
                            }.forEach {
                                opacities[$0] = 0.25
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            flagTapped(number)
                        }
                    }) {
                        FlagImage(country: countries[number])
                    }
                    .opacity(opacities[number])
                    .rotation3DEffect(
                        .degrees(rotationAmounts[number]),
                        axis: (x: 0.0, y: 1.0, z: 0.0))
                    .rotation3DEffect(
                        .degrees(tipForwardAmounts[number]),
                        axis: (x: 1.0, y: 0.0, z: 0.0),
                        anchor: .bottom
                    )
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        let isAnswerCorrect = number == correctAnswer
        score += isAnswerCorrect ? 1 : -1
        scoreTitle = isAnswerCorrect ? "Correct!" : "Incorrect"
        scoreMessage = isAnswerCorrect ? "Your score is \(score)." : "That's the flag of \(countries[number]).\nYour score is \(score)."
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ..< Self.numberOfFlags)
        rotationAmounts = Array(repeating: 0.0, count: Self.numberOfFlags)
        tipForwardAmounts = Array(repeating: 0.0, count: Self.numberOfFlags)
        opacities = Array(repeating: 1.0, count: Self.numberOfFlags)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
