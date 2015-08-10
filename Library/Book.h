//
//  Book.h
//  Library
//
//  Created by Sam Solomon on 7/30/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, copy) NSString *genre;
@property (nonatomic, copy) NSString *publishingHouse;

- (Book *)initWithDictionary:(NSDictionary *)book;

@end
