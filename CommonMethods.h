//
//  CommonMethods.h
//
//  Created by Sahil Kamboj on 25/09/19.
//  Copyright © 2019 Sahil Kamboj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LIGHT_BACKGROUND [[UIColor alloc] initWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.5]
#define MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define LANGUAGE(a) NSLocalizedString(a, @"Cancel")

@interface CommonMethods : NSObject
+ (NSString *)appBuildNumber;
+ (NSString *)appVersionNumber;
+ (NSString *)getIPAddress;

+ (void)configureNavigationBarForViewController:(UIViewController *)viewController withTitle:(NSString *)title;
+ (void)addTitleLabelForNavigationBarForViewController:(UIViewController *)viewController withTitle:(NSString *)title ;
+ (CGSize)getSizeforText:(NSString *)label_text withWidth:(CGFloat)label_width forLabelFont:(UIFont *)label_font;
+ (NSAttributedString *)createAttributedTextForMealPrice:(NSString *)mealPrice forDiscountPrice:(NSString *)discountPrice forOfferType:(OfferType)offerType;
+ (CGFloat)getTextHeight : (NSString *)text;
+ (NSMutableAttributedString *)getHTMLDataintoString : (NSString *)htmlStr;
+ (CGFloat)TextViewHeight : (NSMutableAttributedString *)attrStr;
+ (NSString *)changeStringCases : (NSString *)string;

//Alert Controller
+ (void)ShowAlertWithTitle: (NSString *)title andMessage: (NSString *)message OK: (NSString *)okTitle Cancel: (NSString *)cancelTitle completion : (void (^) (BOOL response))completion;
@end
