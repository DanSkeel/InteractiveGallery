//
//  AlbumsViewController.swift
//  ARGallary
//
//  Created by Danila Shikulin on 08/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

/// View controller that shows albums of the user
class AlbumsViewController: UITableViewController {
    private struct Constant {
        static let albumCellID = "AlbumCellID"
    }
    
    let networkClient: APIProtocol
    let viewControllersProvider: ViewControllersProviding
    
    var albums: [Album] = [] {
        didSet {
            tableView.reloadData()
        }
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.albumCellID)
        registerForPreviewing(with: self, sourceView: tableView)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControllDidChangeValue), for: .valueChanged)
        self.refreshControl = refreshControl
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isMovingToParent {
            downloadAlbums()
        }
    }
    
    private func downloadAlbums() {
        if refreshControl?.isRefreshing == false {
            refreshControl?.beginRefreshing()
            setupTitle()
        }
        
        networkClient.albums() { [weak self] result in
            guard let self = self else { return }
            
            do {
                self.albums = try result.get()
            } catch {
                print("Failed to load albums: \(error)")
            }
            
            self.refreshControl?.endRefreshing()
            self.setupTitle()
        }
    }
    
    private func setupTitle() {
        self.title = (albums.count != 0 || refreshControl?.isRefreshing == true) ? "Albums" : "Pull to get albums"
    }
    
    @objc private func refreshControllDidChangeValue() {
        if refreshControl?.isRefreshing == true {
            downloadAlbums()
        }
    }
    
    private func viewControllerPresentingAlbum(at index: Int) -> UIViewController {
        guard let album = albums[safe: index] else {
            preconditionFailure()
        }
        return viewControllersProvider.viewControllerPresenting(album: album)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let album = albums[safe: indexPath.row] else {
            preconditionFailure("Tried to present missing album at indexpath: \(indexPath)")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.albumCellID, for: indexPath)
        cell.textLabel?.text = album.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = viewControllerPresentingAlbum(at: indexPath.row)
        self.show(viewController, sender: nil)
    }
}

extension AlbumsViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                return nil
        }

        previewingContext.sourceRect = cell.frame
    
        return viewControllerPresentingAlbum(at: indexPath.row)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: nil)
    }
}
