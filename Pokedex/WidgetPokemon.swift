//
//  WidgetPokemon.swift
//  Pokedex
//
//  Created by Pedro Toledo on 13/8/23.
//

import SwiftUI

enum WidgetSize {
    case small, medium, large
}

struct WidgetPokemon: View {
    @EnvironmentObject var pokemon: Pokemon
    let widgetSize: WidgetSize
    var body: some View {
        ZStack{
            Color(pokemon.types![0].capitalized)
            
            switch widgetSize{
            case .small:
                FetchImage(url: pokemon.sprite)
                
            case .medium:
                HStack{
                    FetchImage(url: pokemon.sprite)
                    VStack(alignment: .leading){
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                    .padding(.trailing, 30)
                }
            case .large:
                FetchImage(url: pokemon.sprite)
                VStack{
                    HStack{
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                }
                .padding()
            }
        }
    }
}

struct WidgetPokemon_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPokemon(widgetSize: .medium)
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
