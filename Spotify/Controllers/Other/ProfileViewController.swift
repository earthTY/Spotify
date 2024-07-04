//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Alex on 2024/6/28.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "个人中心"
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
                case .success(let model):
                    break
                case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}
