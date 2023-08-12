//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Pedro Toledo on 10/8/23.
//

import Foundation
import CoreData

@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private (set) var status = Status.notStarted
    
    private let controller: FetchController
    
    init(controller: FetchController){
        self.controller = controller
        Task {
            await getPokemon()
        }
    }
    func getPokemon() async {
        status = .fetching
        
        do{
            guard var pokedex = try await controller.fetchAllPokemon() else {
                print("pokemon is already gotten. good")
                status = .success
                return 
            }
            pokedex.sort{$0.id < $1.id}
            
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.organizedTypes()
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
                
                try PersistenceController.shared.container.viewContext.save()
            }
            status = .success
        } catch{
            status = .failed(error: error)
        }
    }
    
    private func havePokemon() -> Bool {
        let context = PersistenceController.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1, 386])
        
        do{
            let checkPokemon = try context.fetch(fetchRequest)
            if checkPokemon.count == 2{
                return true
            }
        }catch{
            print("Fetch failed: \(error)")
            return false
        }
        return false
    }
}
