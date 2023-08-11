//
//  ContentView.swift
//  Pokedex
//
//  Created by Pedro Toledo on 8/8/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    
    private var pokedex: FetchedResults<Pokemon>
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    var body: some View {
    
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List (pokedex){ pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite){ image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 90, height: 90)
                        Text((pokemon.name!.capitalized))
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetail()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        default:
            ProgressView()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
