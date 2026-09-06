# YumBox

YumBox is an iOS recipe application built with UIKit. It includes recipe browsing, favourites, a cooking timer, nearby supermarket search, recipe sharing, YouTube videos, and a cooking-tips widget.

## Requirements

- Xcode 15.4 or newer
- iOS 17.5 or newer
- A Google Maps Platform API key with the Maps SDK for iOS and Places API enabled

Swift Package Manager resolves these dependencies automatically:

- Alamofire
- Google Maps SDK for iOS
- Google Places SDK for iOS
- SDWebImage

## Configuration

Set the `GOOGLE_MAPS_API_KEY` build setting before running the application. From the command line:

```sh
xcodebuild \
  -project YumBox.xcodeproj \
  -scheme YumBox \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  GOOGLE_MAPS_API_KEY='your-key' \
  build
```

Do not commit API keys. Restrict the key to the required Google APIs and the application bundle identifier.

## Backend

Recipe loading and image uploads currently depend on the endpoints configured in `RecipeViewModel.swift`. Replace them with active endpoints if the original service is unavailable.
