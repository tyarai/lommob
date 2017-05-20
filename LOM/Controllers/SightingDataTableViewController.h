//
//  SightingDataTableViewController.h
//  LOM
//
//  Created by Ranto Andrianavonison on 10/10/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Species.h"
#import "Publication.h"
#import "CameraViewController.h"
#import "SpeciesSelectorViewController.h"
#import "WatchingSitesSelectorViewController.h"
#import "LemursWatchingSites.h"

@protocol SightingDataTableViewControllerDelegate <NSObject>
@optional
- (void) cancelSightingData;
- (void) saveSightingInfo:(Publication*) Publication
                  species:(Species*) species
              observation:(NSInteger) observation
                placeName:(NSString*) placeName
             placeNameRef:(LemursWatchingSites*)placeReference
                     date:(NSDate*) date
                 comments:(NSString*) comments
            photoFileName:(NSString*) photoFileName;



@end



@interface SightingDataTableViewController : UITableViewController <UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CameraViewControllerDelegate,UIPopoverPresentationControllerDelegate,SpeciesSelectorDelegate,WatchingSitesSelectorDelegate>{
    
    BOOL didSelectNewSite;
    
}

@property (nonatomic, retain) id<SightingDataTableViewControllerDelegate> delegate;
- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberObserved;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneBUtton;
@property (weak, nonatomic) IBOutlet UIImageView *speciesImage;

@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UITextField *placename;

@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (weak, nonatomic) IBOutlet UIPickerView *species;

@property (weak, nonatomic) IBOutlet UILabel *speciesLabel;

@property  (strong,nonatomic) id UIViewDelegate;
@property (strong,nonatomic) NSString * takenPhotoFileName;
@property BOOL isAdding;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIButton *chooseSpeciesButton;
- (IBAction)chooseSpeciesTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *scientificName;
@property (weak, nonatomic) IBOutlet UILabel *malagasyName;
@property (weak, nonatomic) IBOutlet UIButton *delteBtn;

//@property (strong,nonatomic) Species* currentSpecies;
@end
