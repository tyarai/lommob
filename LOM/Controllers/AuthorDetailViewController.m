//
//  AuthorDetailViewController.m
//  LOM
//
//  Created by Ranto Andrianavonison on 16/03/2016.
//  Copyright © 2016 Kerty KAMARY. All rights reserved.
//

#import "AuthorDetailViewController.h"
#import "UIImage+Resize.h"

@interface AuthorDetailViewController ()

@end

@implementation AuthorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.selectedAuthor != nil){
        self.navigationItem.title = self.selectedAuthor._name;
        UIImage *image = [UIImage imageNamed:self.selectedAuthor._photo];
        CGSize newSize = self.photo.frame.size;
        //CGRect rect = CGRectMake(0,166, self.photo.frame.size.width,self.photo.frame.size.height );
        //[self.photo setFrame:rect];
        //UIImage*newImage = [image scaledImageToSize:newSize ];
        //UIImage*newImage = [UIImage imageByScalingAndCroppingForSize:newSize image:image];
       // UIImage*newImage = [image resizedImageWithContentMode:UIViewContentModeScaleToFill  bounds:newSize interpolationQuality:0.5];
        //[self.photo setImage:newImage];
        [self.photo setImage:image];
        self.detail.text  = self.selectedAuthor._details;
        
        
        
        
        
    }
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

@end
