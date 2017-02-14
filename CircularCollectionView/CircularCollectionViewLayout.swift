//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by WeiShengkun on 2/14/17.
//  Copyright © 2017 Rounak Jain. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var anchorPoint = CGPoint(x: 0.5, y: 0.5)
  var angle: CGFloat = 0 {
    didSet {
      zIndex = Int(angle * 1000000)
      transform = CGAffineTransform(rotationAngle: angle)
      
    }
  }
  
  override func copy(with zone: NSZone? = nil) -> Any {
    let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
    
    copiedAttributes.anchorPoint = self.anchorPoint
    copiedAttributes.angle = self.angle
    return copiedAttributes
  }
}


class CircularCollectionViewLayout: UICollectionViewLayout {
  
  let itemSize = CGSize(width: 133, height: 173)
  
  var angleAtExtreme: CGFloat {
    let itemsCount = collectionView!.numberOfItems(inSection: 0)
    return itemsCount > 0 ? -CGFloat(itemsCount - 1) * anglePerItem : 0
    
  }
  
  var angle: CGFloat {
    return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
  }
  
  var radius: CGFloat = 900 {
    didSet {
      invalidateLayout()
    }
  }
  
  var anglePerItem: CGFloat {
    
    return atan(itemSize.width / radius)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width, height: collectionView!.bounds.height)
  }
  
  override class var layoutAttributesClass: AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }
  
  
  var attributesList = [CircularCollectionViewLayoutAttributes]()
  
  override func prepare() {
    super.prepare()
    let centerX = collectionView!.contentOffset.x + collectionView!.bounds.width / 2
    let anchorPointY = (itemSize.height / 2 + radius) / itemSize.height
    
    let theta = atan2(collectionView!.bounds.width / 2.0,
                      radius + (itemSize.height / 2.0) - collectionView!.bounds.width / 2.0)
    var startIndex = 0
    var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
   
    if (angle < -theta) {
      startIndex = Int(floor((-theta - angle) / anglePerItem))
    }
    
    endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
    
    if (endIndex < startIndex) {
      endIndex = 0
      startIndex = 0
    }
    
    attributesList = (startIndex...endIndex).map({ (i) -> CircularCollectionViewLayoutAttributes in
      let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
      attributes.size = self.itemSize
      attributes.center = CGPoint(x: centerX, y: collectionView!.bounds.midY)
      attributes.angle = angle + anglePerItem * CGFloat(i)
      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      return attributes
      
    })
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  
  
}
