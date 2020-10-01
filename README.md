# Apollo

A Spotify player for watchOS with streaming mode and offline playback.

The goal of open sourcing this project is to motivate Spotify to add playback support to their watchOS app. I'm not planning to offering any support on building/installing the app to your Apple Watch so please avoid opening issue around these topics.

![Apollo](Images/Simulator-v1.1.0.png)

## Setup

1. Figure out an implementation for the [server](Server.md) e.g. [open-apollo-server](https://github.com/lgruen/open-apollo-server)

2. Register an App at https://developer.spotify.com/dashboard/applications

   - Enter your App Bundle ID and App Redirect URI under settings

3. Replace all the placeholders in the project with real information.

   - Go to Apollo/Configuration
   - In `DefaultServiceConfiguration.swift` enter your server endpoints
   - In `SpotifyAuthorizationContext.swift` enter your Spotify Client ID, App URL-Scheme and App Redirect URI

4. Build & Run :)

## Functions

- Online-Playback (Streaming Mode)
- Offline-Playback (Offline-Mode)
- Explore Playlists, Artists and Tracks
- Search for Playlists, Artists and Tracks
- Configuration in Settings

## Interaction

- Offline Mode: enable/disable in Settings
- Shuffle Mode: enable/disable in Settings
- Update Playlists: longPress on Playlists
- Download Playlists: longPress on Playlist
- Delete Cache: in Settings -> Local Storage
- Delete Downloads: in Settings -> Local Storage
- Volume: turn Digital Crown while in playback

_Note: Playlists only appear if they are marked as favorite_

## Improvements

### TODO

- [ ] Add option to update downloaded playlists
- [ ] Set audio quality in settings (320/160 kbits)
- [ ] Add cover art in background of audio player
- [ ] Fix buttons in download confirmation prompt

### Done

- [x] Add playback info in large complication
- [x] Downloads in foreground mode (speed)
- [x] Fix Downloads appearance after completion
- [x] Updated menu icons
- [x] Replacement of Force-Touch (deprecation)
- [x] Update for iOS 14 and watchOS 7
- [x] New spinner animation while loading
- [x] Invert colors of logout buttons
- [x] Handle error if FileID is not found
- [x] Confirmation popups on local storage deletion
- [x] Update playlists with long press on playlists button
- [x] Add Feedback view for update or deletion
- [x] Update for iOS 13 and watchOS 6
