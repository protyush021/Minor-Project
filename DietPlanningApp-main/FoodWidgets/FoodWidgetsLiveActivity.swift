//
//  FoodWidgetsLiveActivity.swift
//  FoodWidgets
//
//  Created by Aditya Majumdar on 07/08/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FoodWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FoodWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FoodWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FoodWidgetsAttributes {
    fileprivate static var preview: FoodWidgetsAttributes {
        FoodWidgetsAttributes(name: "World")
    }
}

extension FoodWidgetsAttributes.ContentState {
    fileprivate static var smiley: FoodWidgetsAttributes.ContentState {
        FoodWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FoodWidgetsAttributes.ContentState {
         FoodWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FoodWidgetsAttributes.preview) {
   FoodWidgetsLiveActivity()
} contentStates: {
    FoodWidgetsAttributes.ContentState.smiley
    FoodWidgetsAttributes.ContentState.starEyes
}
