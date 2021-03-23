//
//  PopupMenuCollectionViewDataSource.swift
//  Moviefy
//
//  Created by Vladimir Yanakiev on 17.03.21.
//  Copyright © 2021 Vladimir Yanakiev. All rights reserved.
//

import Foundation
import UIKit
class PopupMenuTableViewDataSource/* now that's a long name*/: NSObject, UITableViewDataSource {
    
    let categories = ["All", "Favourite", "Watched", "To-Watch"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupMenuTableViewCell", for: indexPath) as! PopupMenuTableViewCell
        cell.setData(labelText: categories[indexPath.row])
        return cell
    }
}
