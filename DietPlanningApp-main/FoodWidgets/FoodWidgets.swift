//
//  FoodWidgets.swift
//  FoodWidgets
//
//  Created by Aditya Majumdar on 07/08/24.
//

import WidgetKit
import SwiftData
import SwiftUI


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct FoodWidgetsEntryView : View {
    @Query var dietData: [CalorieModel]
    var entry: Provider.Entry
    
    var body: some View {
        
            VStack{
                HStack{
                    Text("Calories")
                        .font(.system(size: 16))
                        .bold()
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                    Spacer()
                    Image("IconApp").resizable().scaledToFit()
                }
                
                Text("")
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .foregroundStyle(Color.orange)
                    .minimumScaleFactor(0.2)
        }
       
    }
    
}

struct FoodWidgets: Widget {
    let kind: String = "FoodWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            FoodWidgetsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    FoodWidgets()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
