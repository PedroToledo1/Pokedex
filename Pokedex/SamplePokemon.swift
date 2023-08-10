//
//  SamplePokemon.swift
//  Pokedex
//
//  Created by Pedro Toledo on 10/8/23.
//

import Foundation
import CoreData

struct SamplePokemon {
    static let samplePokemon = {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 1
        let results = try! context.fetch(fetchRequest)
        
        return results.first!
    }()
}
