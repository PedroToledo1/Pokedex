//
//  TempPokemon.swift
//  Pokedex
//
//  Created by Pedro Toledo on 9/8/23.
//

import Foundation

struct TempPokemon: Codable{
    let id: Int
    let name: String
    let type: [String]
    var hp: Int = 0
    var attack: Int = 0
    var defense: Int = 0
    var specialAttack: Int = 0
    var specialDefense: Int = 0
    var speed: Int = 0
    let sprite: URL
    let shiny: URL
    
    enum PokemonKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        
        enum TypeDictionaryKeys: String, CodingKey {
            case type
            
            
            
            enum typeKeys: String, CodingKey {
                case name
            }
        }
        
        enum StatsDictionaryKeys: String, CodingKey {
            case stat
            case value = "base_stat"
            
            
            enum statKeys: String, CodingKey {
                case name
            }
        }
        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        var decodedTypes: [String] = []
        
        
        var typeContainer = try container.nestedUnkeyedContainer(forKey:  .types)
        
        while !typeContainer.isAtEnd {
            let typesDictionaryContainer = try typeContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            let typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.typeKeys.self, forKey: .type)
            
            let type = try typeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
            
            
        }
        type = decodedTypes
        
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        
        while statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatsDictionaryKeys.statKeys.self, forKey: .stat)
            
            switch try statContainer.decode(String.self, forKey: .name){
            case "hp":
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
                
            case "special-defense":
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            default:
                print("It will never get here so...")
            }
        }
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self, forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self, forKey: .shiny)
    }
}
