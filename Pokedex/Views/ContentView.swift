//
//  ContentView.swift
//  Pokedex
//
//  Created by Pedro Toledo on 8/8/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favorite: FetchedResults<Pokemon>
    
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    @State var filterByFavorites = false
    
    var body: some View {
    
    switch pokemonVM.status {
        case .success:
            NavigationStack {
                List (filterByFavorites ? favorite : pokedex){ pokemon in
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
                        if pokemon.favorite{
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetail()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (action: {
                                filterByFavorites.toggle()
                        }, label: {
                            Label("Favorites By Filter", systemImage: (filterByFavorites ? "star.fill" : "star"))
                                .foregroundColor(.yellow)
                        })
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
