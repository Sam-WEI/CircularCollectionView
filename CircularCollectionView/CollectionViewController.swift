//
//  CollectionViewController.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 10/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"


class CollectionViewController: UICollectionViewController {
  
  let images: [String] = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Images") 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Register cell classes
    collectionView!.register(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    let imageView = UIImageView(image: UIImage(named: "bg-dark.jpg"))
    imageView.contentMode = UIViewContentMode.scaleAspectFill
    collectionView!.backgroundView = imageView

//    installsStandardGestureForInteractiveMovement = true
    
    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
    
    collectionView!.addGestureRecognizer(longGesture)
  }
  
  @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      guard let selectedIndexPath = self.collectionView!.indexPathForItem(at: gesture.location(in: collectionView!)) else {
        break
      }
      collectionView!.beginInteractiveMovementForItem(at: selectedIndexPath)
    case .changed:
      collectionView!.updateInteractiveMovementTargetPosition(gesture.location(in: self.collectionView!))
    case .ended:
      collectionView!.endInteractiveMovement()
    default:
      collectionView!.cancelInteractiveMovement()
    }
  }
  
}

extension CollectionViewController {
  
  // MARK: UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CircularCollectionViewCell
      cell.imageName = images[indexPath.row]
      return cell
  }
  
}

extension CollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    
  }
  
}
