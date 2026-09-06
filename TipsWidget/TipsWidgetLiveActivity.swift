//
//  TipsWidgetLiveActivity.swift
//  TipsWidget
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TipsWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var recipeName: String
}

struct TipsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TipsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Recipe: \(context.attributes.recipeName)")
                Text("Emoji: \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading: \(context.attributes.recipeName)")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing: \(context.state.emoji)")
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

extension TipsWidgetAttributes {
    fileprivate static var preview: TipsWidgetAttributes {
        TipsWidgetAttributes(recipeName: "Kimichi")
    }
}

extension TipsWidgetAttributes.ContentState {
    fileprivate static var smiley: TipsWidgetAttributes.ContentState {
        TipsWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TipsWidgetAttributes.ContentState {
         TipsWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TipsWidgetAttributes.preview) {
   TipsWidgetLiveActivity()
} contentStates: {
    TipsWidgetAttributes.ContentState.smiley
    TipsWidgetAttributes.ContentState.starEyes
}
