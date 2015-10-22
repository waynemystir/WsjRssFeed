//
//  WsjRssItem.h
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WsjRssItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSString *imageUrlString;

@end
