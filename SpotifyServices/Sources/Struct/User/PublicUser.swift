//
//  PublicUser.swift
//  Apollo
//
//  Created by Khaos Tian on 9/30/18.
//  Copyright © 2018 Oltica. All rights reserved.
//

import Foundation

public struct PublicUser: Codable {
    public let id: String
    public let displayName: String?
    public let images: [Image]?
    public let followers: Followers?
    
    public init(id: String, displayName: String?, images: [Image]?, followers: Followers?) {
            self.id = id
            self.displayName = displayName
            self.images = images
            self.followers = followers
        }
}
