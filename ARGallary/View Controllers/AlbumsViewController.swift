//
//  AlbumsViewController.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

class AlbumsViewController: UITableViewController {
    private struct Constant {
        static let albumCellID = "AlbumCellID"
    }
    
    let networkClient: APIProtocol
    let viewControllersProvider: ViewControllersProviding
    
    var albums: [Album]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var loadedAlbums: [Album] {
        guard let albums = albums else {
            preconditionFailure("We assume that albums should already be loaded when we use this property")
        }
        return albums
    }
    
    init(apiClient: APIProtocol,
         viewControllersProvider: ViewControllersProviding) {
        self.networkClient = apiClient
        self.viewControllersProvider = viewControllersProvider
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("Unimplemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Albums"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.albumCellID)
        
        networkClient.albums() { result in
            do {
                self.albums = try result.get()
            } catch {
                print("Failed to load albums: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let album = loadedAlbums[safe: indexPath.row] else {
            preconditionFailure("Tried to present missing album at indexpath: \(indexPath)")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.albumCellID, for: indexPath)
        cell.textLabel?.text = album.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRow = tableView.indexPathForSelectedRow?.row,
            let album = loadedAlbums[safe: selectedRow] else {
                assertionFailure()
                return
        }
        let viewController = viewControllersProvider.viewControllerPresenting(album: album)
        viewController.title = album.title
        self.show(viewController, sender: nil)
    }
}
