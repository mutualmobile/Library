//
//  Book.m
//  Library
//
//  Created by Sam Solomon on 7/30/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import "Book.h"

@implementation Book

-(Book *)initWithDictionary:(NSDictionary *)book {
    if(self) {
        _title = [book valueForKey:@"bookTitle"];
        _author = [book valueForKey:@"author"];
        _bookID = [book valueForKey:@"bookID"];
        _genre = [book valueForKey:@"genre"];
        _publishingHouse = [book valueForKey:@"publishingHouse"];
    }
    return self;
}

@end
