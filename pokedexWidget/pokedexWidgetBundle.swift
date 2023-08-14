//
//  pokedexWidgetBundle.swift
//  pokedexWidget
//
//  Created by Pedro Toledo on 13/8/23.
//

import WidgetKit
import SwiftUI

@main
struct pokedexWidgetBundle: WidgetBundle {
    var body: some Widget {
        pokedexWidget()
        pokedexWidgetLiveActivity()
    }
}
