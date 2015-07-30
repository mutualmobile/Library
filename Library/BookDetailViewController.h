//
//  BookDetailViewController.h
//  Library
//
//  Created by Sam Solomon on 7/30/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import "BookTableViewCell.h"
#import "Book.h"

@interface BookDetailViewController : UIViewController

@property (strong,nonatomic) Book *book;

@end
