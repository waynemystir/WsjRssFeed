//
//  ParseWsjItemOperation.h
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseWsjDocOperation : NSOperation

@property (nonatomic, strong, readonly) NSArray *wsjItems;

- (id)initWithData:(NSData *)parseData;

@end
