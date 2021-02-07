//
//  Image.swift
//  Apollo
//
//  Created by Khaos Tian on 9/30/18.
//  Copyright © 2018 Oltica. All rights reserved.
//

import Foundation

public struct Image: Codable {
    public let url: URL
    public let width: Double?
    public let height: Double?
    
    public init(url: URL, width: Double?, height: Double?) {
        self.url = url
        self.width = width
        self.height = height
    }
}
