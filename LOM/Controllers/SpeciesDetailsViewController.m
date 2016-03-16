//
//  SpeciesDetailsViewController.m
//  LOM
//
//  Created by Andrianavonison Ranto Tiaray on 16/12/2015.
//  Copyright © 2015 Kerty KAMARY. All rights reserved.
//

#import "SpeciesDetailsViewController.h"
#import "Tools.h"
#import "Photographs.h"
#import "Maps.h"
#import "UIImage+Resize.h"
#import "ScientificName.h"

@interface SpeciesDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnFlag;
@property (weak, nonatomic) IBOutlet UILabel *englishName;
@property (weak, nonatomic) IBOutlet UILabel *germanName;
@property (weak, nonatomic) IBOutlet UILabel *frenchName;

@property (weak, nonatomic) IBOutlet UILabel *malagasyName;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnEnglish;
@property (weak, nonatomic) IBOutlet UIButton *btnFrench;
@property (weak, nonatomic) IBOutlet UIButton *btnGerman;
@property (weak, nonatomic) IBOutlet UIButton *btnMalagasy;
@property (weak, nonatomic) IBOutlet UIButton *btnIdentity;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnWhereToSee;
@property (weak, nonatomic) IBOutlet UIButton *btnGeographic;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UITextView *txtText;
@property (weak, nonatomic) IBOutlet UIPageControl *sliderImageControl;

- (IBAction)scientificNameTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *nameView;



@end

@implementation SpeciesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareImageScroll];
    
    [self displayLemurInfos];
    
}

- (void) viewWillAppear:(BOOL)animated{
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
                
                NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", photograph._photograph];
                 //[imageView setImage:[UIImage imageNamed:imageBundleName]];
                UIImage *image = [UIImage imageNamed:imageBundleName];
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


- (void) displayLemurInfos{
    
    self.lblTitle.text = self.specy._english;
    [self activateButton:self.btnEnglish];
    
    [self btnIdentity_Touch:self.btnIdentity];
    
    self.malagasyName.text = self.specy._malagasy;
    self.frenchName.text = self.specy._french;
    self.germanName.text = self.specy._german;
    self.englishName.text =self.specy._english;
    
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
    
    
    if (_photographs && _photographs.count > 0) {
        _imagePosition++;
        
        if (_imagePosition >= _photographs.count) {
            _imagePosition = 0;
        }
        
        [self showImageAtPosition:_imagePosition];

    }
    
}




- (void) activateButton:(UIButton*) button{
    
    if ([button isEqual:self.btnEnglish]) {
        [self.btnEnglish setImage:[UIImage imageNamed:@"btn_english_on"] forState:UIControlStateNormal];
        [self.btnFrench setImage:[UIImage imageNamed:@"btn_french_off"] forState:UIControlStateNormal];
        [self.btnGerman setImage:[UIImage imageNamed:@"btn_german_off"] forState:UIControlStateNormal];
        [self.btnMalagasy setImage:[UIImage imageNamed:@"btn_malagasy_off"] forState:UIControlStateNormal];
       // [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
    }else if ([button isEqual:self.btnFrench]){
        [self.btnEnglish setImage:[UIImage imageNamed:@"btn_english_off"] forState:UIControlStateNormal];
        [self.btnFrench setImage:[UIImage imageNamed:@"btn_french_on"] forState:UIControlStateNormal];
        [self.btnGerman setImage:[UIImage imageNamed:@"btn_german_off"] forState:UIControlStateNormal];
        [self.btnMalagasy setImage:[UIImage imageNamed:@"btn_malagasy_off"] forState:UIControlStateNormal];
        //[self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
    }else if ([button isEqual:self.btnGerman]){
        [self.btnEnglish setImage:[UIImage imageNamed:@"btn_english_off"] forState:UIControlStateNormal];
        [self.btnFrench setImage:[UIImage imageNamed:@"btn_french_off"] forState:UIControlStateNormal];
        [self.btnGerman setImage:[UIImage imageNamed:@"btn_german_on"] forState:UIControlStateNormal];
        [self.btnMalagasy setImage:[UIImage imageNamed:@"btn_malagasy_off"] forState:UIControlStateNormal];
       // [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
    }else if ([button isEqual:self.btnMalagasy]){
        [self.btnEnglish setImage:[UIImage imageNamed:@"btn_english_off"] forState:UIControlStateNormal];
        [self.btnFrench setImage:[UIImage imageNamed:@"btn_french_off"] forState:UIControlStateNormal];
        [self.btnGerman setImage:[UIImage imageNamed:@"btn_german_off"] forState:UIControlStateNormal];
        [self.btnMalagasy setImage:[UIImage imageNamed:@"btn_malagasy_on"] forState:UIControlStateNormal];
       // [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
    }
    // Infos Buttons
    else if ([button isEqual:self.btnIdentity]){
        [self.btnIdentity setImage:[UIImage imageNamed:@"btn_info_lemur_on"] forState:UIControlStateNormal];
        [self.btnHistory setImage:[UIImage imageNamed:@"btn_natural_history_off"] forState:UIControlStateNormal];
        [self.btnStatus setImage:[UIImage imageNamed:@"btn_status_off"] forState:UIControlStateNormal];
        [self.btnWhereToSee setImage:[UIImage imageNamed:@"btn_where_to_see_off"] forState:UIControlStateNormal];
        [self.btnGeographic setImage:[UIImage imageNamed:@"btn_geographic_off"] forState:UIControlStateNormal];
        [self.btnMap setImage:[UIImage imageNamed:@"btn_map_off"] forState:UIControlStateNormal];
        [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
        self.nameView.hidden = YES;
    }
    else if ([button isEqual:self.btnHistory]){
        [self.btnIdentity setImage:[UIImage imageNamed:@"btn_info_lemur_off"] forState:UIControlStateNormal];
        [self.btnHistory setImage:[UIImage imageNamed:@"btn_natural_history_on"] forState:UIControlStateNormal];
        [self.btnStatus setImage:[UIImage imageNamed:@"btn_status_off"] forState:UIControlStateNormal];
        [self.btnWhereToSee setImage:[UIImage imageNamed:@"btn_where_to_see_off"] forState:UIControlStateNormal];
        [self.btnGeographic setImage:[UIImage imageNamed:@"btn_geographic_off"] forState:UIControlStateNormal];
        [self.btnMap setImage:[UIImage imageNamed:@"btn_map_off"] forState:UIControlStateNormal];
        [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
        self.nameView.hidden = YES;
    }
    else if ([button isEqual:self.btnStatus]){
        [self.btnIdentity setImage:[UIImage imageNamed:@"btn_info_lemur_off"] forState:UIControlStateNormal];
        [self.btnHistory setImage:[UIImage imageNamed:@"btn_natural_history_off"] forState:UIControlStateNormal];
        [self.btnStatus setImage:[UIImage imageNamed:@"btn_status_on"] forState:UIControlStateNormal];
        [self.btnWhereToSee setImage:[UIImage imageNamed:@"btn_where_to_see_off"] forState:UIControlStateNormal];
        [self.btnGeographic setImage:[UIImage imageNamed:@"btn_geographic_off"] forState:UIControlStateNormal];
        [self.btnMap setImage:[UIImage imageNamed:@"btn_map_off"] forState:UIControlStateNormal];
        [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
        self.nameView.hidden = YES;
    }
    else if ([button isEqual:self.btnWhereToSee]){
        [self.btnIdentity setImage:[UIImage imageNamed:@"btn_info_lemur_off"] forState:UIControlStateNormal];
        [self.btnHistory setImage:[UIImage imageNamed:@"btn_natural_history_off"] forState:UIControlStateNormal];
        [self.btnStatus setImage:[UIImage imageNamed:@"btn_status_off"] forState:UIControlStateNormal];
        [self.btnWhereToSee setImage:[UIImage imageNamed:@"btn_where_to_see_on"] forState:UIControlStateNormal];
        [self.btnGeographic setImage:[UIImage imageNamed:@"btn_geographic_off"] forState:UIControlStateNormal];
        [self.btnMap setImage:[UIImage imageNamed:@"btn_map_off"] forState:UIControlStateNormal];
        [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
        self.nameView.hidden = YES;
    }
    else if ([button isEqual:self.btnGeographic]){
        [self.btnIdentity setImage:[UIImage imageNamed:@"btn_info_lemur_off"] forState:UIControlStateNormal];
        [self.btnHistory setImage:[UIImage imageNamed:@"btn_natural_history_off"] forState:UIControlStateNormal];
        [self.btnStatus setImage:[UIImage imageNamed:@"btn_status_off"] forState:UIControlStateNormal];
        [self.btnWhereToSee setImage:[UIImage imageNamed:@"btn_where_to_see_off"] forState:UIControlStateNormal];
        [self.btnGeographic setImage:[UIImage imageNamed:@"btn_geographic_on"] forState:UIControlStateNormal];
        [self.btnMap setImage:[UIImage imageNamed:@"btn_map_off"] forState:UIControlStateNormal];
        [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
        self.nameView.hidden = YES;
    }
    else if ([button isEqual:self.btnMap]){
        [self.btnIdentity setImage:[UIImage imageNamed:@"btn_info_lemur_off"] forState:UIControlStateNormal];
        [self.btnHistory setImage:[UIImage imageNamed:@"btn_natural_history_off"] forState:UIControlStateNormal];
        [self.btnStatus setImage:[UIImage imageNamed:@"btn_status_off"] forState:UIControlStateNormal];
        [self.btnWhereToSee setImage:[UIImage imageNamed:@"btn_where_to_see_off"] forState:UIControlStateNormal];
        [self.btnGeographic setImage:[UIImage imageNamed:@"btn_geographic_off"] forState:UIControlStateNormal];
        [self.btnMap setImage:[UIImage imageNamed:@"btn_map_on"] forState:UIControlStateNormal];
        [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_off"] forState:UIControlStateNormal];
        self.nameView.hidden = YES;
    }else if ([button isEqual:self.btnFlag ]){
        [self.btnIdentity setImage:[UIImage imageNamed:@"btn_info_lemur_off"] forState:UIControlStateNormal];
        [self.btnHistory setImage:[UIImage imageNamed:@"btn_natural_history_off"] forState:UIControlStateNormal];
        [self.btnStatus setImage:[UIImage imageNamed:@"btn_status_off"] forState:UIControlStateNormal];
        [self.btnWhereToSee setImage:[UIImage imageNamed:@"btn_where_to_see_off"] forState:UIControlStateNormal];
        [self.btnGeographic setImage:[UIImage imageNamed:@"btn_geographic_off"] forState:UIControlStateNormal];
        [self.btnMap setImage:[UIImage imageNamed:@"btn_map_off"] forState:UIControlStateNormal];
        [self.btnFlag setImage:[UIImage imageNamed:@"btn_flag_on"] forState:UIControlStateNormal];
    }
     //self.nameView.hidden = YES;
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnEnglish_Touch:(id)sender {
    self.lblTitle.text = self.specy._english;
    [self activateButton:self.btnEnglish];
}

- (IBAction)btnFrench_Touch:(id)sender {
    self.lblTitle.text = self.specy._french;
    [self activateButton:self.btnFrench];
}

- (IBAction)btnGerman_Touch:(id)sender {
    self.lblTitle.text = self.specy._german;
    [self activateButton:self.btnGerman];
}

- (IBAction)btnMalagasy_Touch:(id)sender {
    self.lblTitle.text = self.specy._malagasy;
    [self activateButton:self.btnMalagasy];
}

- (IBAction)btnIdentity_Touch:(id)sender {
    
    self.txtText.text = self.specy._identification;
    
    [self activateButton:self.btnIdentity];
    
}


- (IBAction)btnHistory_Touch:(id)sender {
    
    self.txtText.text = self.specy._natural_history;
    
    [self activateButton:self.btnHistory];
}


- (IBAction)btnStatus_Touch:(id)sender {
    
    self.txtText.text = self.specy._conservation_status;
    
    [self activateButton:self.btnStatus];
}


- (IBAction)btnWhereToSee_Touch:(id)sender {
    
    self.txtText.text = self.specy._where_to_see_it;
    
    [self activateButton:self.btnWhereToSee];
}


- (IBAction)btnGeographic_Touch:(id)sender {
    
    self.txtText.text = self.specy._geographic_range;
    
    [self activateButton:self.btnGeographic];
}


- (IBAction)btnMap_Touch:(id)sender {
    
    //[self activateButton:self.btnMap];
    
    [self showMap];
}


- (IBAction)btnBack_Touch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnLemurPhotos_Touch:(id)sender {
    
    [self showPhotoBrowser];
}


- (void) showPhotoBrowser{
    
        
    self.photos = [NSMutableArray array];
    
    
    for (Photographs* photograph in _photographs) {
        
        if (![Tools isNullOrEmptyString:photograph._photograph]) {
            
            NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", photograph._photograph];
            
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

- (void) showMap{
    
    self.photos = [NSMutableArray array];
    
    Maps* map = [self.specy getSpecieMap];
        
    if (![Tools isNullOrEmptyString:map._file_name]) {
            
        NSString* imageBundleName = [NSString stringWithFormat:@"%@.jpg", map._file_name];
            
        [self.photos addObject:[MWPhoto photoWithImage:[UIImage imageNamed:imageBundleName]]];
            
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


- (IBAction)scientificNameTapped:(id)sender {
    self.nameView.hidden = NO;
    [self activateButton:self.btnFlag];

}

@end
