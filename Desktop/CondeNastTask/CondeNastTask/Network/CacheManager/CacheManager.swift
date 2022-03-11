//
//  CacheManager.swift
//  MachineTest
//
//  Created by Lokesh Vyas on 10/03/22.
//

import Foundation
import UIKit

class CacheManager {
    
    struct Constants {
        // Cache Names
        static let kAvatarCacheName = "AvatarCache"
    }
    static let shared = CacheManager()
    
    private let avatarCache = Cache<Int, Data>(withName: Constants.kAvatarCacheName)
    
    func avatarImage(avatarSourceURL: URL, _ completion: @escaping ((UIImage?) -> Void)) {
        
        NetworkManager.shared.fetchAvatar(from: avatarSourceURL, { [weak self] (data: Data?) in
            
            if let imageData = data {
                completion(UIImage(data: imageData))
            }
            else {
                completion(nil)
            }
        })
    }
}
