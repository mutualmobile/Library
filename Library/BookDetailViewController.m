//
//  BookDetailViewController.m
//  Library
//
//  Created by Sam Solomon on 7/30/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import "BookDetailViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import "BookTableViewCell.h"
#import "Book.h"

@interface BookDetailViewController () {
    __weak IBOutlet UILabel *bookTitle;
    __weak IBOutlet UILabel *author;
    __weak IBOutlet UILabel *publisher;
    __weak IBOutlet UILabel *genre;
    __weak IBOutlet UILabel *bookID;
}

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bookTitle.text = self.book.title;
    author.text = self.book.author;
    publisher.text = self.book.publishingHouse;
    genre.text = self.book.genre;
    bookID.text = self.book.bookID;
}

- (void)dismissSelfAnimated:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:animated];
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
