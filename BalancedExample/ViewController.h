//
//  ViewController.h
//  BalancedExample
//
//  Created by Ben on 7/8/13.
//  Copyright (c) 2013 Balanced. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIButton *btnPerformOperation;
    IBOutlet UITextField *tfCardNumber;
    IBOutlet UITextField *tfName;
    IBOutlet UITextField *tfExpMonth;
    IBOutlet UITextField *tfExpYear;
    IBOutlet UITextField *tfCVV;
    IBOutlet UITextView *tvResponseView;
    IBOutlet UIActivityIndicatorView *loadingIndicator;
    IBOutlet UIImageView *cardImage;
    NSUInteger previousCardType;
}

@end
