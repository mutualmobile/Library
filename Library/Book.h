//
//  Book.h
//  Library
//
//  Created by Sam Solomon on 7/30/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *bookID;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) NSString *publishingHouse;

- (id)initWithDictionary:(NSDictionary *)book;

@end
