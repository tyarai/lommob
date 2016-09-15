//
//  Tools.h
//  EDF-RELAIS
//
//  Created by Hugo Scano on 14/04/2015.
//  Copyright (c) 2015 Madiapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LemurLifeListNode.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface Tools : NSObject

+(void) setPaddingLeft:(int) padding For:(UITextField*) textfield;
+(void) underlineTextInButton:(UIButton*) button;
+(AppDelegate *) getAppDelegate;
+(void) scaleLabel:(UILabel*) label;
+(UITableViewCell*) getCell:(UITableView*)tableView identifier:(NSString*)identifier;
+(UIViewController*) getViewControllerFromStoryBoardWithIdentifier:(NSString*) identifier;
+(void) changePlaceholderColorWith:(UIColor*) color ToTextField:(UITextField*) textField;
+(void) roundedThisImageView:(UIImageView*) imageView;
+(BOOL) isImage:(UIImage*) image1 EqualTo:(UIImage*) image2;
+(UIImage *)roundedRectImageFromImage:(UIImage *)image withRadious:(CGFloat)radious;
+(NSString*) getAlphabetLetterAtIndex:(NSInteger) index;
+(void) setUserPreferenceWithKey:(NSString*) key andStringValue:(NSString*) value;
+(NSString*) getStringUserPreferenceWithKey:(NSString*) key;
+(void) showSimpleAlertWithTitle:(NSString*) title andMessage:(NSString*) message;
+ (void) copyDatabaseIfNeeded:(NSString*) databaseName;
+ (NSString *) getDatabasePath:(NSString*) fileName;
+(NSString*) getNowDateFormated:(NSString*) dateFormat;
+(void)DownloadVideo:(NSString*) url pathFile:(NSString*)pathFile;
+(NSString*) getUdid;
+(void) setBoolUserPreferenceWithKey:(NSString*) key andValue:(BOOL) value;
+(BOOL) getBoolUserPreferenceWithKey:(NSString*) key;
+(float) getScreenWidth;
+(float) getScreenHeight;
+(BOOL)isNullOrEmptyString:(NSString*)input;
+(CGRect) generateFrame:(CGRect) frame;

// By Ranto 2016
+(UIAlertController*) createAlertViewWithTitle:(NSString*) title messsage:(NSString*)message;
+(void) showError:(JSONModelError*) err onViewController:(UIViewController*) view;
+(void) updateLemurLifeListWithNodes:(NSArray<LemurLifeListNode>*) nodes;
+(void) emptyLemurLifeListTable;

@end
