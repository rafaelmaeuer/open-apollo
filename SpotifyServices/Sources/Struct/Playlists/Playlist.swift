//
//  Playlist.swift
//  Apollo
//
//  Created by Khaos Tian on 9/30/18.
//  Copyright © 2018 Oltica. All rights reserved.
//

import Foundation

public struct Playlist: Codable {
    public let id: String
    public let name: String
    public let owner: PublicUser
    
    public let description: String?
    public let images: [Image]
    
    public let followers: Followers
    
    public let collaborative: Bool
    public let tracks: Paginated<PlaylistTrack>
    
    public init(id: String, name: String, owner: PublicUser, description: String?, images: [Image], followers: Followers, collaborative: Bool, tracks: Paginated<PlaylistTrack>) {
        self.id = id
        self.name = name
        self.owner = owner
        
        self.description = description
        self.images = images
        
        self.followers = followers
        
        self.collaborative = collaborative
        self.tracks = tracks
    }
}

extension Playlist: AnyPlaylist {}
