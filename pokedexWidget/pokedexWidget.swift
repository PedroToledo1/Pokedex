//
//  pokedexWidget.swift
//  pokedexWidget
//
//  Created by Pedro Toledo on 13/8/23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    
    var randomPokemon: Pokemon{
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        var result: [Pokemon] = []
        
        do{
            result = try context.fetch(fetchRequest)
        }catch{
            print("Couldnt fetch: \(error)")
        }
        if let randomPokemon = result.randomElement() {
            return randomPokemon
        }
        return SamplePokemon.samplePokemon
    }
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, pokemon: randomPokemon)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let pokemon: Pokemon
}

struct pokedexWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {
        case .systemSmall:
            WidgetPokemon(widgetSize: .small)
                .environmentObject(entry.pokemon)
        case .systemMedium:
            WidgetPokemon(widgetSize: .medium)
                .environmentObject(entry.pokemon)
        case .systemLarge:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        default:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        }
    }
}

struct pokedexWidget: Widget {
    let kind: String = "pokedexWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            pokedexWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct pokedexWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            pokedexWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            pokedexWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            pokedexWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
