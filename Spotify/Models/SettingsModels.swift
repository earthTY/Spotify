//
//  SettingsModels.swift
//  Spotify
//
//  Created by Alex on 2024/7/9.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}

