//
//  HomeInterfaceController.swift
//  Watch Extension
//
//  Created by Khaos Tian on 10/7/18.
//  Copyright © 2018 Oltica. All rights reserved.
//

import WatchKit
import SpotifyServices

class HomeInterfaceController: WKInterfaceController {

    private var nowPlayingItemController: NowPlayingItemController?
    @IBOutlet weak var nowPlayingItemGroup: WKInterfaceGroup!
    
    @IBOutlet weak var nowPlayingAnimationView: WKInterfaceImage!
    @IBOutlet weak var nowPlayingImageView: WKInterfaceGroup!
    @IBOutlet weak var nowPlayingNameLabel: WKInterfaceLabel!
    
    @IBOutlet weak var playlistTable: WKInterfaceTable!
    
    @IBOutlet weak var playlistsButton: WKInterfaceButton!
    @IBOutlet weak var playlistsButtonImage: WKInterfaceImage!
    @IBOutlet weak var playlistsButtonText: WKInterfaceLabel!
    
    @IBOutlet weak var exploreButton: WKInterfaceButton!
    @IBOutlet weak var searchButton: WKInterfaceButton!
    @IBOutlet weak var downloadsButton: WKInterfaceButton!
    @IBOutlet weak var settingsButton: WKInterfaceButton!
    
    @IBOutlet weak var noPlaylistGroup: WKInterfaceGroup!
    
    private var lastUpdatedAt: Date?
    
    private var playlists: [AnyPlaylist]?
    private var hasPendingPlaylistsRequest = false
    
    private var searchSuggestions = [
        "Taylor Swift",
        "Aether",
        "Iron & Wine",
        "Sigur Rós"
    ]
    
    override func willActivate() {
        super.willActivate()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDownloadManagerUpdate),
            name: .downloadManagerTaskChanges,
            object: DownloadManager.shared
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateMenuItems),
            name: .appStateOfflineChange,
            object: nil
        )
        
        if nowPlayingItemController == nil {
            nowPlayingItemController = NowPlayingItemController(
                itemGroup: nowPlayingItemGroup,
                animationView: nowPlayingAnimationView,
                imageView: nowPlayingImageView,
                nameLabel: nowPlayingNameLabel
            )
            
            updateMenuItems()
        }
        
        SpotifyPlayer.shared.registerPlayerEventProcessor(nowPlayingItemController!)
        updateIfNecessary()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NotificationCenter.default.removeObserver(
            self,
            name: .downloadManagerTaskChanges,
            object: DownloadManager.shared
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: .appStateOfflineChange,
            object: SettingsInterfaceController.self
        )
        
        SpotifyPlayer.shared.unregisterPlayerEventProcessor(nowPlayingItemController!)
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        guard table == playlistTable else {
            return nil
        }
        
        return playlists?[rowIndex]
    }
}

// MARK: - Actions

extension HomeInterfaceController {
    
    @IBAction func didTapPlaylistButton() {
        guard let playlists = playlists, !playlists.isEmpty else {
            playlistsButtonText.setText("Loading…")
            hasPendingPlaylistsRequest = true
            return
        }
        playlistTable.performSegue(forRow: 0)
    }
    
    @IBAction func didLongPressPlaylistButton() {
        NSLog("Update playlists…")
        updatePlaylists(autoUpdate: false)
    }
    
    @IBAction func didTapExploreButton() {
        hasPendingPlaylistsRequest = false
        pushController(withName: "Explore", context: nil)
    }
    
    @IBAction func didTapSearchButton() {
        hasPendingPlaylistsRequest = false
        presentTextInputController(
            withSuggestions: searchSuggestions,
            allowedInputMode: .plain,
            completion: { [weak self] result in
                guard let inputText = result?.first as? String, let strongSelf = self else {
                    return
                }
                
                strongSelf.pushController(withName: "Search", context: inputText)
            }
        )
    }
    
    @IBAction func didTapDownloadsButton() {
        pushController(withName: "Downloads", context: nil)
    }
    
    @IBAction func didTapSettingsButton() {
        pushController(withName: "Settings", context: nil)
    }
    
    @objc
    private func toggleMode() {
        AppSession.shared.offline.toggle()
        lastUpdatedAt = nil
        //updateMenuItems()
        updateIfNecessary()
    }
    
    func showPopup(context: String, success: Bool){

        let title = success ? "Success" : "Error"
        let text = context + (success ? " updated" : " update failed")
        let h0 = { print(text) }
        let action = WKAlertAction(title: "Ok", style: .cancel, handler:h0)

        presentAlert(withTitle: title, message: "\n" + text, preferredStyle: .actionSheet, actions: [action])
    }
}

// MARK: - Menu Items

extension HomeInterfaceController {
    
    @objc
    private func updateMenuItems() {
        
        // Toggle if state is offline and settings set online
        if (AppSession.shared.offline && !UserPreferences.offline) {
            toggleMode()
        }
        
        // Toggle if state is online and settings set offline
        if (!AppSession.shared.offline && UserPreferences.offline) {
            toggleMode()
        }

    }
}

// MARK: - Update

extension HomeInterfaceController {
    
    @objc
    private func handleDownloadManagerUpdate() {
        updateDownloadManagerState()
    }
    
    private func updateIfNecessary() {
        updateDownloadManagerState()
        
        guard !AppSession.shared.offline else {
            
            playlists = SpotifyServiceProvider.shared.downloadedPlaylists()
            playlistTable.setNumberOfRows(playlists!.count, withRowType: "PlaylistRow")
            playlistsButtonText.setText("Playlists")

            if playlists!.isEmpty {
                playlistsButton.setHidden(true)
                noPlaylistGroup.setHidden(false)
            } else {
                playlistsButton.setHidden(false)
                noPlaylistGroup.setHidden(true)
            }
            
            if hasPendingPlaylistsRequest {
                didTapPlaylistButton()
                hasPendingPlaylistsRequest = false
            }
            
            exploreButton.setHidden(true)
            searchButton.setHidden(true)
            
            return
        }
        
        exploreButton.setHidden(false)
        searchButton.setHidden(false)
        
        if let lastUpdatedAt = lastUpdatedAt, lastUpdatedAt.timeIntervalSinceNow > -1800 {
            return
        }
        
        playlistsButton.setHidden(false)
        noPlaylistGroup.setHidden(true)
        
        lastUpdatedAt = Date()
        updatePlaylists(autoUpdate: true)
        updateSearchSuggestions()
    }
    
    private func updateDownloadManagerState() {
        DownloadManager.shared.getCurrentTasks { [weak self] tasks in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.downloadsButton.setHidden(tasks.isEmpty)
        }
    }
    
    private func updatePlaylists(autoUpdate: Bool) {
        SpotifyServiceProvider.shared.getPlaylists { [weak self] result in
            guard let strongSelf = self, case .success(let playlists) = result else {
                if (!autoUpdate) {
                    self?.showPopup(context:"Playlists", success:false)
                }
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.playlists = playlists.items
                strongSelf.playlistTable.setNumberOfRows(playlists.items.count, withRowType: "PlaylistRow")
                strongSelf.playlistsButtonText.setText("Playlists")

                if playlists.items.isEmpty {
                    strongSelf.playlistsButton.setHidden(true)
                    strongSelf.noPlaylistGroup.setHidden(false)
                } else {
                    strongSelf.playlistsButton.setHidden(false)
                    strongSelf.noPlaylistGroup.setHidden(true)
                }
                
                if strongSelf.hasPendingPlaylistsRequest {
                    strongSelf.didTapPlaylistButton()
                    strongSelf.hasPendingPlaylistsRequest = false
                }
                NSLog("Playlists updated")
                if (!autoUpdate) {
                    self?.showPopup(context:"Playlists", success:true)
                }
            }
        }
    }
    
    private func updateSearchSuggestions() {
        SpotifyServiceProvider.shared.getNewReleases { [weak self] result in
            guard let strongSelf = self, case .success(let newReleases) = result, !newReleases.albums.items.isEmpty else {
                return
            }
            
            DispatchQueue.main.async {
                var suggestions: [String] = []
                for album in newReleases.albums.items {
                    if !suggestions.contains(album.name) {
                        suggestions.append(album.name)
                    }
                }
                
                strongSelf.searchSuggestions = suggestions
            }
        }
    }
}
