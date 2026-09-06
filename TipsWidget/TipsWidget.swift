//
//  TipsWidget.swift
//  TipsWidget
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import WidgetKit
import SwiftUI

struct Tip : Codable{
    let tips : [String]
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> TipEntry {
        TipEntry(date: Date(), configuration: ConfigurationAppIntent(), tip : readFromFile(), recipeImage: UIImage(systemName: "frying.pan.fill")!)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> TipEntry {
        TipEntry(date: Date(), configuration: configuration, tip: readFromFile(), recipeImage: UIImage(systemName: "frying.pan.fill")!)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TipEntry> {
        var entries: [TipEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = TipEntry(date: entryDate, configuration: configuration,tip: readFromFile(),recipeImage: UIImage(systemName: "frying.pan.fill")!)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    func readFromFile() -> String {
        if let url = Bundle.main.url(forResource: "tips", withExtension: "json"){
            do{
                let data = try Data(contentsOf: url)
                let tipsData = try JSONDecoder().decode(Tip.self, from: data)
                let tips = tipsData.tips
                return tips.randomElement() ?? "No tip found"
            }catch{
                print("Failed to load tips: \(error.localizedDescription)")
            }
        }
        return "No tip found"
    }
}

struct TipEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let tip : String
    let recipeImage : UIImage
}

struct TipsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Cooking Tip of the Hour").font(.system(size: 15))
            Text(entry.tip).font(.system(size: 12))
            //Text(entry.date, style: .time)
            Image(uiImage: entry.recipeImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)

//            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
        }
        .padding()
    }
}

struct TipsWidget: Widget {
    let kind: String = "RecipeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TipsWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var sampleRecipe: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteRecipe = "Sample Tip"
        return intent
    }
    
    fileprivate static var featuredRecipe : ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteRecipe = "Featured Tip"
        return intent
    }
}

//#Preview(as: .systemSmall) {
//    TipsWidget()
//} timeline: {
//    TipEntry(date: .now, configuration: .sampleRecipe,tip: "Sample Tip",recipeImage: UIImage(systemName: "frying.pan.fill")!)
//    TipEntry(date: .now, configuration: .featuredRecipe,tip: "Featured Tip",recipeImage: UIImage(systemName: "frying.pan.fill")!)
//}
