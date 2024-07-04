//
//  AuthManager.swift
//  Spotify
//
//  Created by Alex on 2024/6/28.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refershingToken = false // 正在刷新token中
    
    struct Constants {
        static let clientID = "84d7462c4a6a444cbb44347d2f18ebde"
        static let clientSecret = "3a9a14adb61648de94699666c628e7ec"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20user-library-modify%20user-library-read%20user-read-email"
        static let redirect_uri = "https://dev.meos.center/tenantrepair/home"
    }
    
    private init(){}
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let signUrl = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirect_uri)&show_dialog=TRUE"
        
        return URL(string: signUrl)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchengeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ){
        // get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        print("code test:", code)
        
        var componets = URLComponents()
        componets.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: Constants.redirect_uri),
            URLQueryItem(name: "code", value: code)
        ]
        
        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        let base64String = basicToken.data(using: .utf8)?.base64EncodedString() ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = componets.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request)  {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do{
//                let json = try JSONSerialization.jsonObject(
//                    with: data,
//                    options:.allowFragments
//                )
//                
//                print("SUCCESS:\(json)")
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.catchToken(result: result)
                completion(true)
            }catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private var onRefershBlocks = [((String) -> Void)]()
    
    // 判断调用api时是否需要刷新token
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refershingToken else {
            onRefershBlocks.append(completion)
            return
        }
        
        // 判断当前需要刷新token时
        if shouldRefreshToken {
            // 调用刷新token
            refreshAccessToken { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        }else if let token = accessToken {
            completion(token)
        }
    }
    
    /**
     刷新token
     */
    public func refreshAccessToken(completion: @escaping (Bool) -> Void){
        guard !refershingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // refresh Access Token
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refershingToken = true
        
        
        var componets = URLComponents()
        componets.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        let base64String = basicToken.data(using: .utf8)?.base64EncodedString() ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = componets.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request)  {[weak self] data, _, error in
            self?.refershingToken = false
            
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(
                    with: data,
                    options:.allowFragments
                )

                print("SUCCESS RefreshToken:\(json)")
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefershBlocks.forEach { $0(result.access_token) }
                self?.onRefershBlocks.removeAll()
                self?.catchToken(result: result)
                completion(true)
            }catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private func catchToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
