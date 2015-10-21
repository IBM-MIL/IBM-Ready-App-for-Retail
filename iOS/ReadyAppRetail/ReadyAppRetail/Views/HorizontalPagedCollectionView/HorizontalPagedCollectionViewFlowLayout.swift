/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/
import UIKit

class HorizontalPagedCollectionViewFlowLayout: UICollectionViewFlowLayout {
   
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    This method sets up various properties of the horizontal paged collection view
    */
    override func prepareLayout() {
        if let collectionView = self.collectionView {
            collectionView.pagingEnabled = false
            self.minimumLineSpacing = 5
            self.scrollDirection = .Horizontal

            self.sectionInset = UIEdgeInsets(top: 0, left: minimumLineSpacing, bottom: 0, right: minimumLineSpacing)
            
            let viewSize = CGSizeMake(160, 160);
            setItemSize(viewSize)
        }
    }
    
    /**
    This method defines the size of each item in the horizontal paged collection view
    
    - parameter viewSize: 
    */
    private func setItemSize(viewSize: CGSize){
        
        let itemSize = CGSize(width: viewSize.width - minimumLineSpacing, height: viewSize.height)
        self.itemSize = itemSize
        
    }
    
    /**
    This method defines the flick velocity
    
    - returns:
    */
    func flickVelocity() -> CGFloat{
        return 0.0
    }
    
    /**
    This method defines the size of each page needed for the  targetContentOffsetForProposedContentOffset
    
    - returns:
    */
    func pageWidth() ->CGFloat{
        return self.itemSize.width + self.minimumLineSpacing;
    }
    
    /**
    This method defines the behavior of how many cells the collectionview scrolls past when the user flicks the horizontal paged collection view.
    */
    override func targetContentOffsetForProposedContentOffset(var proposedContentOffset: CGPoint, withScrollingVelocity  velocity: CGPoint) -> CGPoint {
        
        let rawPageValue : CGFloat = self.collectionView!.contentOffset.x / self.pageWidth();
        let currentPage : CGFloat = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
        let nextPage : CGFloat = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
        
        let pannedLessThanAPage : Bool = fabs(1 + currentPage - rawPageValue) > 0.5;
        let flicked : Bool = fabs(velocity.x) > self.flickVelocity();
        if (pannedLessThanAPage && flicked) {
            proposedContentOffset.x = nextPage * self.pageWidth();
        } else {
            proposedContentOffset.x = (round(rawPageValue) * self.pageWidth());
        }
        
        return proposedContentOffset;
        
    }
    
}
