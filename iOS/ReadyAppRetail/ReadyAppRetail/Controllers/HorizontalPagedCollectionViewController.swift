/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class HorizontalPagedCollectionViewController: UICollectionViewController {

    var dataArray : [ItemMetaDataObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpPlaceHolderItems()
        self.setUpCollectionView()
    }
    
    
    /**
    This method sets up the collectionview to have 3 placeholder products while it waits for a call back from Worklight
    */
    private func setUpPlaceHolderItems(){
        for(var i = 0; i<3; i++){
            self.dataArray.append(ItemMetaDataObject())
        }
    }
    
    /**
    This method is called when there has been data recieved and parsed from Worklight. It sets up the collectionview to handle this new data.
    
    :param: newDataArray
    */
    func refresh(newDataArray : [ItemMetaDataObject]){
        
        if(newDataArray.count > 0){
            self.dataArray = newDataArray
        
            self.collectionView!.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
    This method sets up the collectionview with various settings.
    */
    private func setUpCollectionView(){
        self.collectionView!.showsHorizontalScrollIndicator = false;
        
        var collectionPageViewLayout : HorizontalPagedCollectionViewFlowLayout = HorizontalPagedCollectionViewFlowLayout()
        
        self.collectionView!.setCollectionViewLayout(collectionPageViewLayout, animated: false);
        
        var nib : UINib = UINib(nibName: "HorizontalPagedCollectionViewCell", bundle:nil)
        
        self.collectionView!.registerNib(nib,
            forCellWithReuseIdentifier: "horizontalpagedcell");
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return dataArray.count
    }

    
    
    /**
    This method generates the cell for item at indexPath
    
    :param: collectionView
    :param: indexPath
    
    :returns:
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("horizontalpagedcell", forIndexPath: indexPath) as! HorizontalPagedCollectionViewCell
        
        var itemMetaDataObject : ItemMetaDataObject = dataArray[indexPath.row] as ItemMetaDataObject
    
        let url = NSURL(string: itemMetaDataObject.imageUrl as String)
    
         cell.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Product_PlaceHolder"))

        return cell
    }
    //
    
    /**
    This method determines the action that is taken when an items is tapped. It tells the browseViewController what item was tapped. 
    
    :param: collectionView
    :param: indexPath
    */
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var browseViewController : BrowseViewController = self.parentViewController as! BrowseViewController
        
        var itemMetaDataObject : ItemMetaDataObject = dataArray[indexPath.row] as ItemMetaDataObject
        
        if(itemMetaDataObject.type == "product"){
            browseViewController.showProductDetail(itemMetaDataObject.id)
        }
    }

 

}
