//
//  Book.h
//  Library
//
//  Created by Sam Solomon on 7/30/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

//TODO: `copy` all NSString cause they have a mutable subclass
// http://vgable.com/blog/2008/11/14/prefer-copy-over-retain/

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *bookID;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) NSString *publishingHouse;

//TODO: use instanceType
- (id)initWithDictionary:(NSDictionary *)book;

@end
