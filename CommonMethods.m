//
//  CommonMethods.m
//
//  Created by Sahil Kamboj on 25/09/19.
//  Copyright © 2019 Sahil Kamboj. All rights reserved.
//

#import "CommonMethods.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation CommonMethods

+ (NSString *)appBuildNumber {
    NSString *buildNumber =  [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] ];
    return buildNumber;
}

+ (NSString *)appVersionNumber {
    NSString *versionNumber =  [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    return versionNumber;
}

+ (void)configureNavigationBarForViewController:(UIViewController *)viewController withTitle:(NSString *)title {
    if (IDIOM != IPAD)
    {
        [viewController navigationController].navigationBar.barTintColor = [UIColor colorWithRed:0.98 green:0.40 blue:0.02 alpha:1.0];
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.navigationController.view.backgroundColor = [UIColor clearColor];
        viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [viewController.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        viewController.navigationItem.title = [NSString stringWithFormat:@"%@",NSLocalizedString(title,@"")];
        [[viewController navigationController] setNavigationBarHidden:NO animated:NO];
    }
}

+(void)addTitleLabelForNavigationBarForViewController:(UIViewController *)viewController withTitle:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize: 14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%@",NSLocalizedString(title,@"")];
    viewController.navigationItem.titleView = label;
}

+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

+ (NSString *)getDeviceID {
    NSString *result = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    return result;
}

+ (CGSize)getSizeforText:(NSString *)label_text withWidth:(CGFloat)label_width forLabelFont:(UIFont *)label_font
{
	CGSize lblSize;
	
	
	lblSize = [label_text boundingRectWithSize:CGSizeMake(label_width, MAXFLOAT)
									   options:NSStringDrawingUsesLineFragmentOrigin
									attributes:@{
												 NSFontAttributeName : label_font
												 }
									   context:nil].size;
	
	return lblSize;
}

+ (NSAttributedString *)createAttributedTextForMealPrice:(NSString *)mealPrice forDiscountPrice:(NSString *)discountPrice forOfferType:(OfferType)offerType {
	
	NSDictionary *oldPriceAttributes = [NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName];
	
	NSAttributedString *oldPriceAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",kEuroCurrencySmybol,mealPrice] attributes:oldPriceAttributes];
	
	
	NSMutableAttributedString *oldPrice = [[NSMutableAttributedString alloc] initWithAttributedString:oldPriceAttributedString];
	
	[oldPrice addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [oldPriceAttributedString length])];
	
	NSDictionary *discountPriceAttributes  = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:0.98 green:0.40 blue:0.02 alpha:1.0] forKey:NSForegroundColorAttributeName];
	
	NSAttributedString *discountPriceAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",kEuroCurrencySmybol,discountPrice] attributes:discountPriceAttributes];
	NSMutableAttributedString *result;
	
	if (offerType == OfferTypeNone) {
		result  = [[NSMutableAttributedString alloc] initWithAttributedString:discountPriceAttributedString];
	}
	else {
		
		result  = [[NSMutableAttributedString alloc] initWithAttributedString:oldPriceAttributedString];
		NSAttributedString *str = [[NSAttributedString alloc] initWithString:@" "];
		[result appendAttributedString:str];
		[result appendAttributedString:discountPriceAttributedString];
	}
	return result;
}

+ (CGFloat)getTextHeight : (NSString *)text {
	CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.95;
//	UIFont *font = [UIFont systemFontOfSize:10.0];
	UIFont *font;
	if(IDIOM == IPAD) {
		font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];//[UIFont systemFontOfSize:10.0];
	}
	else {
		font = [UIFont systemFontOfSize:10.0];
	}
	NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
	CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
	CGSize size = rect.size;
	return ceilf(size.height);
}

+ (NSMutableAttributedString *)getHTMLDataintoString : (NSString *)htmlStr {
	NSString *htmlString = htmlStr;
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
											initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
											options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding) }
											documentAttributes: nil
											error: nil
											];
	UIFont *font;
	if(IDIOM == IPAD) {
		font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];//[UIFont systemFontOfSize:10.0];
	}
	else {
		font = [UIFont systemFontOfSize:10.0];
	}
	
	[attributedString addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, attributedString.length)];
	
	return attributedString;
}

+(CGFloat)TextViewHeight : (NSMutableAttributedString *)attrStr {
	UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.95, 20)];
	tv.attributedText = attrStr;
//	tv.font = [UIFont systemFontOfSize:10.0];
	if(IDIOM == IPAD) {
		tv.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
	}
	else {
		tv.font = [UIFont systemFontOfSize:10.0];
	}
	CGFloat fixedWidth = tv.frame.size.width;
	CGSize newSize = [tv sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
	CGRect newFrame = tv.frame;
	newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
	return newSize.height;
}

+ (NSString *)changeStringCases : (NSString *)string {
	NSString *change = [string stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	return [change capitalizedString];
}

//Alert Controller

+ (void)ShowAlertWithTitle: (NSString *)title andMessage: (NSString *)message OK: (NSString *)okTitle Cancel: (NSString *)cancelTitle completion : (void (^) (BOOL response))completion {
	
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	
	if (![okTitle isEqual:@""]) {
		UIAlertAction *ok = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			completion(YES);
		}];
		[alertController addAction:ok];
	}
	
	if (![cancelTitle isEqual:@""]) {
		UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			completion(NO);
		}];
		[alertController addAction:cancel];
	}
	
	[[[UIApplication sharedApplication].keyWindow rootViewController] presentViewController:alertController animated:YES completion:nil];
	
}

@end
