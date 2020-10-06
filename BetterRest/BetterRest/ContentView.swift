//
//  ContentView.swift
//  BetterRest
//
//  Created by Avery Vine on 2020-10-05.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    static var defaultBedtime: Date {
        var components = DateComponents()
        components.hour = 23
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var bedtimeString: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        do {
            let model = try SleepCalculator(configuration: .init())
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            return formatter.string(from: sleepTime)
        } catch let error {
            print("Something went wrong: \(error.localizedDescription)")
            return formatter.string(from: Self.defaultBedtime)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Desired Wake Time")) {
                        DatePicker("Select a time.", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    }

                    Section(header: Text("Desired Amount of Sleep")) {
                        Stepper(value: $sleepAmount, in: 0.25 ... 16, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                    }

                    Section(header: Text("Daily Coffee Intake")) {
                        Stepper(value: $coffeeAmount, in: 1 ... 20) {
                            Text(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups")
                        }
                    }
                }
                Text("Your ideal bedtime is")
                    .font(.title2)
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                Text(bedtimeString)
                    .font(.title)
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
