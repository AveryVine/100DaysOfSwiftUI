//
//  MissionView.swift
//  Moonshot
//
//  Created by Avery Vine on 2020-10-26.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    init(mission: Mission) {
        let astronauts = NASAData.shared.astronauts
        
        self.mission = mission
        self.astronauts = mission.crew.map { member in
            guard let astronaut = astronauts.first(where: { $0.id == member.name }) else {
                fatalError("Missing \(member)")
            }
            return CrewMember(role: member.role, astronaut: astronaut)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                    
                    if mission.launchDate != nil {
                        Text("Launch Date")
                            .font(.subheadline)
                            .padding(.top)
                        Text(mission.formattedLaunchDate)
                            .font(.title3)
                    }
                    
                    Text(mission.description)
                        .padding()
                    
                    ForEach(astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.primary, lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    
                                    HStack {
                                        if crewMember.role == "Commander" {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                        Text(crewMember.role)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(mission: NASAData.shared.missions[1])
            .previewLayout(.sizeThatFits)
    }
}
