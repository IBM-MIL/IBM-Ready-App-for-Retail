/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class CarouselCollectionViewFlowLayout: UICollectionViewFlowLayout {
   
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
    This method sets up various properties of the carousel collectionview
    */
    override func prepareLayout() {
        if let collectionView = self.collectionView {
            collectionView.pagingEnabled = true
            self.scrollDirection = .Horizontal
            self.minimumLineSpacing = 0
            
            let viewSize = collectionView.bounds.size
            setItemSize(viewSize)
        }
    }
    
    /**
    This method sets the item size for each cell of the carousel collectionview.
    
    :param: viewSize <#viewSize description#>
    */
    private func setItemSize(viewSize: CGSize){
        let itemSize = CGSize(width: viewSize.width - minimumLineSpacing, height: viewSize.height)
        self.itemSize = itemSize
    }
    
}
