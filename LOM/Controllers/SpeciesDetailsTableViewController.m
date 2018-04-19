//
//  SpeciesDetailsTableViewController.m
//  LOM
//
//  Created by Ranto Tiaray Andrianavonison on 18/04/2018.
//  Copyright © 2018 Kerty KAMARY. All rights reserved.
//

#import "SpeciesDetailsTableViewController.h"
#import "Tools.h"
#import "Constants.h"
#import "Photographs.h"
#import "Maps.h"
#import "UIImage+Resize.h"
#import "ScientificName.h"
#import "SpeciesDetailInfoTableViewController.h"

#define _ROWHEIGHT 48
#define _fixedPhotoCellHeight 311
#define _fixedMenuCellHeight 55

@interface SpeciesDetailsTableViewController ()

@end

@implementation SpeciesDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = _ROWHEIGHT;
    
    selectedMenu = -1;
    
    if(self.specy){
        [self prepareImageScroll];
        self.scientificName.text = self.specy._title;
        
    }
}
- (IBAction)frTapped:(id)sender {
    NSString * message = self.specy._french;
    UIAlertController * alert = [self getBoxWithSender:sender message:message];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)deTapped:(id)sender {
    NSString * message = self.specy._german;
    UIAlertController * alert = [self getBoxWithSender:sender message:message];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)enTapped:(id)sender {
    NSString * message = self.specy._english;
    UIAlertController * alert = [self getBoxWithSender:sender message:message];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)mgTapped:(id)sender {
    NSString * message = self.specy._malagasy;
    UIAlertController * alert = [self getBoxWithSender:sender message:message];
    [self presentViewController:alert animated:YES completion:nil];
}

-(UIAlertController*) getBoxWithSender:(id)sender message:(NSString*)message{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"", @"")
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         
                                     }];
    
    alert.view.tintColor = [UIColor blackColor];
    [alert addAction:ok];
    
    return alert;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initTimer];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if ([_timerScrollImage isValid]) {
        [_timerScrollImage invalidate];
    }
    _timerScrollImage = nil;
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
- (IBAction)showSlideShow:(id)sender {
    [self showPhotoBrowser];
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

#pragma UIScrollViewdelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_lastContentOffset < (int)scrollView.contentOffset.x) {
        // moved right
        if (self.sliderImageControl.currentPage < _photographs.count)
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

- (void) showPhotoBrowser{
    
    
    self.photos = [NSMutableArray array];
    
    
    for (Photographs* photograph in _photographs) {
        
        if (![Tools isNullOrEmptyString:photograph._photograph]) {
            
            /*NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", photograph._photograph];
             
             [self.photos addObject:[MWPhoto photoWithImage:[UIImage imageNamed:imageBundleName]]];
             */
            
            //NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", photograph._photograph];
            
            NSString* imageBundleName = photograph._photograph;
            
            
            UIImage * image = [Tools loadImage:imageBundleName];
            
            if(image == nil) {
                //TODO: Atao ilay sary default_specy no sary aseho
                // image = default_specy
            }
            
            [self.photos addObject:[MWPhoto photoWithImage:image]];
            
            
            
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



- (void) showNextImage{
    
    
    if (_photographs && _photographs.count > 0) {
        _imagePosition++;
        
        if (_imagePosition >= _photographs.count) {
            _imagePosition = 0;
        }
        
        [self showImageAtPosition:_imagePosition];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0) {
        return UITableViewAutomaticDimension;
    }else if (indexPath.row == 1){
        return _fixedPhotoCellHeight;
    }
    return _fixedMenuCellHeight;
}

- (void) prepareImageScroll{
    
    _imagePosition = 0;
    
    int x = 0;
    int y = 0;
    
    float width = [Tools getScreenWidth];
    float height = 300;
    
    _photographs = [self.specy getSpeciePhotographs];
    
    if (_photographs != nil && _photographs.count > 0) {
        
        if (_photographs.count == 1) {
            self.sliderImageControl.numberOfPages = 1;
            [self.sliderImageControl setHidden:YES];
        }else{
            self.sliderImageControl.numberOfPages = _photographs.count;
            [self.sliderImageControl setHidden:NO];
        }
        
        for (Photographs* photograph in _photographs) {
            
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width , height)];
            // imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.contentMode = UIViewContentModeScaleToFill;
            
            if (![Tools isNullOrEmptyString:photograph._photograph]) {
                
                //NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", photograph._photograph];
                
                NSString* imageBundleName =  photograph._photograph;
                
                UIImage *image = [Tools loadImage:imageBundleName];
                
                CGSize newSize = CGSizeMake(width,height);
                UIImage *scaledImage = [image scaledImageToSize:newSize];
                [imageView setImage:scaledImage];
                
            }else{
                [imageView setImage:[UIImage imageNamed:@"ico_default_specy"]];
            }
            
            [self.scrollImage addSubview:imageView];
            x += [Tools getScreenWidth];
            
        }
        
        [self.scrollImage setContentSize:CGSizeMake(x, 0)];
    }
    
}


/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SpeciesDetailInfoTableViewController* vc = (SpeciesDetailInfoTableViewController*)[segue destinationViewController];
    NSString * details = nil;
    NSString * menuTitle   = nil;
    
    switch (selectedMenu) {
        case 3:
            details     = self.specy._identification;
            menuTitle   = NSLocalizedString(@"species_identification_menu", nil);
            break;
        case 4:
            details = self.specy._natural_history;
            menuTitle   = NSLocalizedString(@"species_naturalhistory_menu", nil);
            break;
        case 5:
            details = self.specy._conservation_status;
            menuTitle   = NSLocalizedString(@"species_conservationstatus_menu", nil);
            break;
        case 6:
            details = self.specy._where_to_see_it;
            menuTitle   = NSLocalizedString(@"species_wheretoseeit_menu", nil);
            break;
        case 7:
            details = self.specy._geographic_range;
            menuTitle   = NSLocalizedString(@"species_geographicrange_menu", nil);
            break;
      
        default:
            break;
    }
    
    vc.specy = self.specy;
    vc.stringDetails = details;
    vc.menuTitle = menuTitle;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row != 8){
        selectedMenu = indexPath.row;
        [self performSegueWithIdentifier:@"showDetails" sender:self];
    }else{
         [self showMap];
    }
    
}

- (void) showMap{
    
    self.photos = [NSMutableArray array];
    
    Maps* map = [self.specy getSpecieMap];
    
    if (![Tools isNullOrEmptyString:map._file_name]) {
        
        //NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", map._file_name];
        NSString* imageBundleName =  map._file_name;
        
        //- Esorina ny extension ato satria ny an'ny MAP efa misy extension daholo ny sary --
        imageBundleName = [imageBundleName stringByDeletingPathExtension];
        
        UIImage *image = [Tools loadImage:imageBundleName];
        
        if(image == nil) {
            //TODO : Tokony ilay sary by default no aseho eto
            // image = default_specy
        }
        
        [self.photos addObject:[MWPhoto photoWithImage:image]];
        
    }else {
        
        [self.photos addObject:[MWPhoto photoWithImage:[UIImage imageNamed:@"ico_default_specy"]]];
        
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



@end
