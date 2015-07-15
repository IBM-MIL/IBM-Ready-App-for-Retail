/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class CarouselCollectionViewController: UICollectionViewController, UIScrollViewDelegate {

    var dataArray : [ItemMetaDataObject] = []
    var currentIndex : CGFloat = 0
    var timer : NSTimer!
    var pageControl : UIPageControl!
    var finishedSetup : Bool = false;
    
    
    /**
    This method sets up the dataArray with placeholder items while it waits for data from Worklight by calling setUpPlaceHolderItem
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        self.resetTimer()
        
        self.setUpPlaceHolderItem()
    }
    
    
    /**
    This method sets up the collectionView by calling the setUpCollectionView() method when the view is about to appear
    
    :param: animated
    */
    override func viewWillAppear(animated: Bool) {
        
    }
    
    /**
    This method is called when the view has finished laying out the subviews. Within this method it offsets the collectionView's contentOffset.x by the width of the collectionView so the collectionView starts at the correct "0th index" rather than the "last index" or "-1th index" it starts at by default. This is needed because the last item in the original dataArray has been duplicated and put at the beginning of the newly updated dataArray to achieve a circular carousel effect when scrolling through the carouselCollectionView's pages. As well this method sets up the UIPageControl by calling the setUpPageControl() method.
    */
    override func viewDidLayoutSubviews() {
        //check to see if this is the first time viewDidLayoutSubviews has been called
        if(finishedSetup == false){
            //offset the collectionView's contentOffset.x by the collectionView's width
            self.collectionView!.setContentOffset(CGPointMake(self.collectionView!.frame.size.width, 0), animated: false);
            finishedSetup = true
        }
    }
    
    /**
    This method stops the timer whenever the view disappears.
    
    :param: animated
    */
    override func viewDidDisappear(animated: Bool) {
        self.stopTimer()
    }
    
    /**
    This method sets up the placeholder item for the carouselCollectionView as it waits for data from Worklight
    */
    private func setUpPlaceHolderItem(){
        self.dataArray.append(ItemMetaDataObject())
        setUpDataForCarouselCollectionView()
    }
    
    
    /**
    This method is called when there has been data recieved and parsed from Worklight. It sets up the collectionview to handle this new data.
    
    :param: newDataArray the new dataArray to populate the collectionView with
    */
    func refresh(newDataArray : [ItemMetaDataObject]){
        if(newDataArray.count > 0){
            self.dataArray = newDataArray
            self.setUpDataForCarouselCollectionView()
            self.setUpPageControl()
            self.collectionView!.reloadData()
            self.resetTimer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    This method updates the dataArray needed to populate the carouselCollectionView. What this method does is takes a copy of the first item in the data array and appends it to the end of the dataArray. As well it takes a copy of the last item in the data array and inserts it at the beginning of the dataArray. This is needed to achieve a circular carousel effect when scrolling through the carouselCollectionView's pages. How this works is explained in more detail in the description for the scrollViewDidScroll method.
    */
    private func setUpDataForCarouselCollectionView(){
        var workingArray = self.dataArray
        
        if(workingArray.count > 0){
            var arraySize = workingArray.count
            var firstItem = workingArray[0]
            var lastItem  = workingArray[arraySize - 1]
        
            workingArray.insert(lastItem, atIndex: 0)
            workingArray.append(firstItem)
            
            self.dataArray = workingArray
        }
    }
    

    /**
    This method sets up the collectionView
    */
    private func setUpCollectionView(){
        
        //hide collectionView horizontal scroll bar
        self.collectionView!.showsHorizontalScrollIndicator = false;
        
        //create new instance of CarouselCollectionViewFlowLayout (needed to set up the carouselCollectionView's unique characteristics)
        var carouselCollectionViewFlowLayout : CarouselCollectionViewFlowLayout = CarouselCollectionViewFlowLayout()
        
        //set the collectionView's collectionViewLayout to the carouselCollectionViewFlowLayout
        self.collectionView!.setCollectionViewLayout(carouselCollectionViewFlowLayout, animated: false)
        
        //create an instance of the CarouselCollectionViewCell.xib file
        var nib : UINib = UINib(nibName: "CarouselCollectionViewCell", bundle:nil)
        
        //register the collectionview with this nib file
        self.collectionView!.registerNib(nib,
            forCellWithReuseIdentifier: "carouselcell")
        
    }
    
    
    /**
    This method sets up the UIPageControl and adds it the self.view
    */
    private func setUpPageControl(){
      
        self.pageControl = UIPageControl(frame: CGRectMake(0,  self.view.frame.size.height - 30,  self.view.frame.size.width, 30))
        
        self.pageControl.numberOfPages = self.dataArray.count - 2
        self.pageControl.currentPage = 0

        self.pageControl.autoresizingMask = .None;
        self.view.addSubview(self.pageControl)
        self.view.bringSubviewToFront(self.pageControl)
    
    }
    
    
    /**
    This method is called as the timer's selector every 4 seconds. This method changes the "current page" visible in the collectionView by changing the collectionViews contentOffset to be equal to the (nextPage to be shown) * (the collectionView's pageWidth)
    */
    func nextItem(){
        
        var nextIndex : CGFloat = self.currentIndex + 1.0
        
        var pageWidth :CGFloat = self.collectionView!.frame.size.width;
        
        var contentOffset : CGFloat = self.collectionView!.contentOffset.x;
   
        var nextPage : CGFloat = (contentOffset / pageWidth) + 1;
        
        var newOffset : CGPoint = CGPointMake(pageWidth * nextPage, 0);
        
        //update the collectionView's contentOffset.x to the newly calculated offset.
        self.collectionView!.setContentOffset(newOffset, animated: true);
        
        //reset the timer everytime the page is changed
        self.resetTimer()
        
    }
    
    
    /**
    This method starts the timer and sets it to go off every 4 seconds. When the timer goes off it calls the nextItem() method.
    */
    private func startTimer(){
        self.timer =  NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("nextItem"), userInfo: nil, repeats: true);
    }
    
    /**
    This method resets the timer by stopping the timer and then starting it again
    */
    private func resetTimer(){
        stopTimer()
        startTimer()
    }
    
    
    /**
    This method stops the timer by invalidating the timer
    */
    private func stopTimer(){
        if(self.timer != nil){
            self.timer.invalidate()
        }
    }
    

    
    /**
    This method is called everytime the scrollView scrolls. It first resets the timer. Then it calls the checkPage method to check what page the UIPageControl should be set to and then it calls the checkContentOffsetXForCircularCarouselLogic method to check to see if any special logic needs to be handled to make the carousel collectionView circular
    
    :param: scrollView
    */
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //only execute if all the subviews have finished setting up
        if(finishedSetup == true){
            self.resetTimer()
            checkPage(scrollView)
            self.checkContentOffsetXForCiruclarCarouselLogic(scrollView)
        }
    }
    
    
    /**
    This method is called within the scrollViewDidScroll method. This method checks to see if any special logic needs to be handled to make the carousel collectionView circular
    
    :param: scrollView the scrollView of the collectionView
    */
    private func checkContentOffsetXForCiruclarCarouselLogic(scrollView: UIScrollView){
        var lastContentOffsetX : CGFloat =  0
        
        //grab the current X and Y offsets of the collectionView's scrollView
        var currentOffsetX = scrollView.contentOffset.x
        var currentOffsetY = scrollView.contentOffset.y
        
        var pageWidth = scrollView.frame.size.width
        var offset = pageWidth * CGFloat(self.dataArray.count - 2)
        
        
        if(currentOffsetX < pageWidth && lastContentOffsetX > currentOffsetX){
            lastContentOffsetX = currentOffsetX + offset
            scrollView.contentOffset = CGPoint(x: lastContentOffsetX, y: currentOffsetY);
        }
        else if(currentOffsetX > offset && lastContentOffsetX < currentOffsetX){
            lastContentOffsetX = currentOffsetX - offset
            scrollView.contentOffset = CGPoint(x: lastContentOffsetX, y: currentOffsetY)
        }
        else{
            lastContentOffsetX = currentOffsetX
        }
    }
    
    
    /**
    This method checks to see if the UIPageControl needs to be updated. If it does, then it updates the UIPageControl's currentPage
    
    :param: scrollView the scrollView of the collectionView
    */
    func checkPage(scrollView: UIScrollView){
        var pageWidth = scrollView.frame.size.width
        var currentPageFloat = scrollView.contentOffset.x / pageWidth;
        var currentPageInt = Int(round(currentPageFloat - 1))
        
        //If the current page isn't a duplicated item from the dataArray
        if(currentPageInt >= 0){
            if(self.pageControl != nil){
                self.pageControl.currentPage = currentPageInt
            }
        }
            
         //If the currentPage is negative then this means it is the duplicated last item from the original dataArray and this we hard code the currentPage to be the actual last item's index from the original dataArray
        else{
            if(self.pageControl != nil){
                self.pageControl.currentPage = self.dataArray.count - 3
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    /**
    This method sets the number of sections in the collection view. Since the carouselCollectionView is a single horizontal row, we only want one section
    
    :param: collectionView
    
    :returns:
    */
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    /**
    This method sets the number of items in a section, in this case, its the number of items in the dataArray
    
    :param: collectionView
    :param: section
    
    :returns:
    */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return dataArray.count
    }

    /**
    This method prepares the current cell for item at the current indexPath.
    
    :param: collectionView
    :param: indexPath
    
    :returns: 
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("carouselcell", forIndexPath: indexPath) as! CarouselCollectionViewCell
        
        var itemMetaDataObject : ItemMetaDataObject = dataArray[indexPath.row] as ItemMetaDataObject
       
        let url = NSURL(string: itemMetaDataObject.imageUrl as String)
        cell.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Featured-PlaceHolder"))

        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
     
        
    }


}
