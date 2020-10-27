//
//  AstronautView.swift
//  Moonshot
//
//  Created by Avery Vine on 2020-10-26.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    var missions: [Mission] {
        NASAData.shared.missions.filter { mission in
            mission.crew.contains { $0.name == astronaut.id }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                    
                    Group {
                        Text(astronaut.description)
                            .padding([.top, .bottom])
                        
                        ForEach(missions) { mission in
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                Text(mission.displayName)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding([.leading, .trailing])
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautView(astronaut: NASAData.shared.astronauts[10])
            .previewLayout(.sizeThatFits)
    }
}
