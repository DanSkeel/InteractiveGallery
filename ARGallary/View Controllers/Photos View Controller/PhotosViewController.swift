//
//  PhotosViewController.swift
//  ARGallary
//
//  Created by Danila Shikulin on 09/05/2019.
//  Copyright © 2019 Danila Shikulin. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController {
    private struct Constant {
        static let photoCellID = "PhotoCellID"
    }
    
    let networkClient: APIProtocol
    let imageLoader: ImageLoading
    let viewControllersProvider: ViewControllersProviding
    
    var album: Album? {
        didSet {
            guard let album = self.album else { return }
            
            self.title = album.title
            networkClient.photos(in: album) { result in
                do {
                    self.photos = try result.get()
                } catch {
                    print("Failed to load photos: \(error)")
                }
            }
        }
    }
    
    private var photos: [Photo]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var loadedPhotos: [Photo] {
        guard let photos = photos else {
            preconditionFailure("We assume that photos should already be loaded when we use this property")
        }
        return photos
    }
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 2
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInsetReference = .fromSafeArea
        return layout
    }()
    
    init(apiClient: Networking & APIProtocol,
         imageLoader: ImageLoading,
         viewControllersProvider: ViewControllersProviding) {
        
        self.networkClient = apiClient
        self.imageLoader = imageLoader
        self.viewControllersProvider = viewControllersProvider
        
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("Unimplemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: String(describing: PhotoCollectionViewCell.self), bundle: nil),
                                forCellWithReuseIdentifier: Constant.photoCellID)
        registerForPreviewing(with: self, sourceView: collectionView)
    }
    
    private func itemsSize(for size: CGSize, columnsCount: Int = 4) -> CGSize {
        precondition(columnsCount > 0)
        
        let count = CGFloat(columnsCount)
        let side = (size.width - flowLayout.minimumInteritemSpacing * (count-1)) / count
        return CGSize(width: side, height: side)
    }
    
    private func viewControllerPresentingDetailPhoto(at index: Int) -> UIViewController {
        return viewControllersProvider.viewControllerPresentingDetail(photos: loadedPhotos, selectedIndex: index)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photo = loadedPhotos[safe: indexPath.row] else {
            preconditionFailure("Tried to present missing photo at indexpath: \(indexPath)")
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.photoCellID, for: indexPath)
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            preconditionFailure("dequeued wrong cell")
        }
        
        let key = photoCell
        imageLoader.cancelLoading(for: key)
        imageLoader.loadImage(at: photo.thumbnailUrl, key: key) { image in
            if let image = image {
                photoCell.set(image: image, animated: true)
            }
        }

        return photoCell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout.invalidateLayout()
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemsSize(for: collectionView.safeAreaLayoutGuide.layoutFrame.size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = viewControllerPresentingDetailPhoto(at: indexPath.row)
        show(viewController, sender: nil)
    }
}

extension PhotosViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) else {
                return nil
        }
        previewingContext.sourceRect = cell.frame
        
        return viewControllerPresentingDetailPhoto(at: indexPath.row)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: nil)
    }
}
