//
//  NASAData.swift
//  Moonshot
//
//  Created by Avery Vine on 2020-10-26.
//

import Foundation

struct NASAData {
    static let shared = NASAData()
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    private init() {}
}
