//
//  WsjTableViewDelegate.h
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSUInteger const kWsjTblVwStartTag;

@interface WsjTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tableViewData;

+ (WsjTableView *)tableViewFactory:(int)placement;

@end
