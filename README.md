# Apollo

A Spotify player for watchOS.

The goal of open sourcing this project is to motivate Spotify to add playback support to their watchOS app. I'm not planning to offering any support on building/installing the app to your Apple Watch so please avoid opening issue around these topics.

## Setup
1. Figure out an implementation for the [server](Server.md).
2. Register an App at https://developer.spotify.com/dashboard/applications
	- Enter your App Bundle ID and App Redirect URI under settings
2. Replace all the placeholders in the project with real information.
	- Go to Apollo/Configuration
	- In `DefaultServiceConfiguration.swift` enter your server endpoints
	- In `SpotifyAuthorizationContext.swift` enter your Spotify Client ID, App URL-Scheme and App Redirect URI
3. Build & Run :)