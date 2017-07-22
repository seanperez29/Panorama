//
//  FavoritesViewController.swift
//  Panorama
//
//  Created by Sean Perez on 7/22/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var imageResults: Results<ImageRealmObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let realm = try Realm()
            imageResults = realm.objects(ImageRealmObject.self)
        } catch {
            showAlert("We experienced a problem loading favorites")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.FavoritesCell, for: indexPath) as! FavoritesTableViewCell
        let imageResult = imageResults[indexPath.row]
        cell.configureCell(imageResult)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try imageResults.realm?.write {
                    let imageResult = imageResults[indexPath.row]
                    imageResults.realm?.delete(imageResult)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                showAlert("We experienced a problem deleting your image")
            }
        }
    }
}
