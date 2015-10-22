//
//  WsjTableViewDelegate.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "WsjTableViewDelegate.h"
#import "WsjTableViewCell.h"
#import "WsjRssItem.h"

@implementation WsjTableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (WsjTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WsjTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"WsjTableViewCell" owner:nil options:nil].firstObject;
    WsjRssItem *wri = self.tableViewData[indexPath.row];
    cell.title.text = wri.title;
    cell.itemDescription.text = wri.itemDescription;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:wri.imageUrlString]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.itemImage.image = image;
        });
        
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0f;
}

@end
