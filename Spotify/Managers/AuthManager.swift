//
//  AuthManager.swift
//  Spotify
//
//  Created by Alex on 2024/6/28.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "84d7462c4a6a444cbb44347d2f18ebde"
        static let clientSecret = "3a9a14adb61648de94699666c628e7ec"
    }
    
    private init(){}
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirect_uri = "https://dev.meos.center/tenantrepair/home"
        let base = "https://accounts.spotify.com/authorize"
        let signUrl = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirect_uri)"
        
        return URL(string: signUrl)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
