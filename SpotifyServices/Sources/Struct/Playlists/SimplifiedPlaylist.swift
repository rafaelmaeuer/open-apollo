//
//  SimplifiedPlaylist.swift
//  Apollo
//
//  Created by Khaos Tian on 9/30/18.
//  Copyright © 2018 Oltica. All rights reserved.
//

import Foundation

public struct SimplifiedPlaylist: Codable {
    public let id: String
    public let name: String
    
    public let images: [Image]
    
    public let collaborative: Bool
    public let tracks: TracksLink
    
    public init(id: String, name: String, images: [Image], collaborative: Bool, tracks: SimplifiedPlaylist.TracksLink) {
        self.id = id
        self.name = name
        
        self.images = images
        
        self.collaborative = collaborative
        self.tracks = tracks
    }
}

extension SimplifiedPlaylist {
    
    public struct TracksLink: Codable {
        public let href: URL
        public let total: Int
        
        public init(href: URL, total: Int) {
            self.href = href
            self.total = total
        }
    }
}

extension SimplifiedPlaylist: AnyPlaylist {}
