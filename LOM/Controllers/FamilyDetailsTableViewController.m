//
//  FamilyDetailsTableViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 13/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import "FamilyDetailsTableViewController.h"
#import "Tools.h"
#import "Illustrations.h"

#define _ROWHEIGHT 48
#define _fixedPhotoCellHeight 359

@interface FamilyDetailsTableViewController ()

@end

@implementation FamilyDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareImageScroll];
    
    self.lblText.text = self.families._family_description;
    
    self.lblTitle.text = self.families._family;
    
    self.scrollImage.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = _ROWHEIGHT;
    
    
    self.navigationItem.titleView = nil;
    self.navigationItem.title = self.families._family;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor] }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.row == 1) {
        return UITableViewAutomaticDimension;
    }
    return _fixedPhotoCellHeight;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initTimer];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.txtText scrollRangeToVisible:NSMakeRange(0, 0)];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if ([_timerScrollImage isValid]) {
        [_timerScrollImage invalidate];
    }
    _timerScrollImage = nil;
}

- (void) prepareImageScroll{
    
    _imagePosition = 0;
    
    int x = 0;
    int y = 0;
    
    float width = [Tools getScreenWidth];
    float height = 150;
    
    _illustrations = [self.families getIllustrations];
    
    if (_illustrations != nil && _illustrations.count > 0) {
        
        if (_illustrations.count == 1) {
            self.sliderImageControl.numberOfPages = 1;
            [self.sliderImageControl setHidden:YES];
        }else{
            self.sliderImageControl.numberOfPages = _illustrations.count;
            [self.sliderImageControl setHidden:NO];
        }
        
        for (Illustrations* illustration in _illustrations) {
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width , height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            if (![Tools isNullOrEmptyString:illustration._illustration]) {
                
                NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", illustration._illustration];
                
                [imageView setImage:[UIImage imageNamed:imageBundleName]];
                
            }else{
                [imageView setImage:[UIImage imageNamed:@"ico_default_specy"]];
            }
            
            [self.scrollImage addSubview:imageView];
            x += [Tools getScreenWidth];
            
        }
        
        [self.scrollImage setContentSize:CGSizeMake(x, 0)];
    }
    
}


- (void) initTimer{
    _imagePosition = 0;
    
    _timerScrollImage = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                         target:self
                                                       selector:@selector(showNextImage)
                                                       userInfo:nil
                                                        repeats:YES];
    
    
    self.sliderImageControl.userInteractionEnabled = YES;
    [self.sliderImageControl addTarget:self action:@selector(changeLemurPhoto) forControlEvents:UIControlEventValueChanged];
    self.sliderImageControl.hidesForSinglePage = YES;
    
}

- (void) showNextImage{
    
    
    if (_illustrations && _illustrations.count > 0) {
        _imagePosition++;
        
        if (_imagePosition >= _illustrations.count) {
            _imagePosition = 0;
        }
        
        [self showImageAtPosition:_imagePosition];
        
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma UIScrollViewdelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_lastContentOffset < (int)scrollView.contentOffset.x) {
        // moved right
        if (self.sliderImageControl.currentPage < _illustrations.count)
        {
            self.sliderImageControl.currentPage = self.sliderImageControl.currentPage + 1;
        }
        else
        {
            self.sliderImageControl.currentPage = self.sliderImageControl.currentPage;
        }
    }
    else if (_lastContentOffset > (int)scrollView.contentOffset.x) {
        // moved left
        if (self.sliderImageControl.currentPage > 0) {
            self.sliderImageControl.currentPage = self.sliderImageControl.currentPage - 1;
        }else{
            self.sliderImageControl.currentPage = self.sliderImageControl.currentPage;
        }
    }
    
    [self showImageAtPosition:self.sliderImageControl.currentPage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.x;
}


- (void) changeLemurPhoto{
    
    _imagePosition = self.sliderImageControl.currentPage;
    [self showImageAtPosition:_imagePosition];
    
}

- (void) showImageAtPosition: (NSInteger) position{
    
    _imagePosition = position;
    
    [self.scrollImage setContentOffset:CGPointMake(_imagePosition * [Tools getScreenWidth], 0) animated:YES];
    
    self.sliderImageControl.currentPage = _imagePosition;
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}*/

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma UIScrollViewdelegate



- (IBAction)btnLemurPhotos_Touch:(id)sender {
    
    [self showPhotoBrowser];
}


- (void) showPhotoBrowser{
    
    
    self.photos = [NSMutableArray array];
    
    
    for (Illustrations* illustration in _illustrations) {
        
        if (![Tools isNullOrEmptyString:illustration._illustration]) {
            
            NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", illustration._illustration];
            
            [self.photos addObject:[MWPhoto photoWithImage:[UIImage imageNamed:imageBundleName]]];
            
        }else {
            
            [self.photos addObject:[MWPhoto photoWithImage:[UIImage imageNamed:@"ico_default_specy"]]];
            
        }
    }
    
    
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    [browser setCurrentPhotoIndex:_imagePosition];
    
    
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
}

#pragma mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}


@end
