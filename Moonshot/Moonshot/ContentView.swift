//
//  ContentView.swift
//  Moonshot
//
//  Created by Avery Vine on 2020-10-26.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingAstronauts = false
    
    let astronauts = NASAData.shared.astronauts
    let missions = NASAData.shared.missions
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                        Text(isShowingAstronauts ? crewList(for: mission) : mission.formattedLaunchDate)
                            .lineLimit(1)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Moonshot")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        isShowingAstronauts.toggle()
                    }, label: {
                        Image(systemName: isShowingAstronauts ? "calendar.circle" : "person.circle")
                            .imageScale(.large)
                    })
            )
        }
    }
    
    func crewList(for mission: Mission) -> String {
        let missionAstronauts = astronauts.filter { astronaut in
            mission.crew.contains { $0.name == astronaut.id }
        }
        return missionAstronauts.map { $0.name }.joined(separator: ", ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
