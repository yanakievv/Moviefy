//
//  PopupMenyCollectionViewDelegate.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 17.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit

class PopupMenuTableViewDelegate: NSObject, UITableViewDelegate {
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row)")
        let userInfo = ["indexPath": indexPath]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeCategory"), object: nil, userInfo: userInfo)
    }
}
