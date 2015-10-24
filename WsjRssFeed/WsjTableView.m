//
//  WsjTableViewDelegate.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "WsjTableView.h"
#import "WsjTableViewCell.h"
#import "WsjRssItem.h"
#import "AppDelegate.h"
#import "ArticleViewController.h"
#import "LoadWsjData.h"

@implementation WsjTableView

+ (WsjTableView *)tableViewFactory:(int)placement {
    
    CGRect s = [[UIScreen mainScreen] bounds];
    CGFloat sw = s.size.width;
    CGFloat sh = s.size.height;
    CGFloat sha = sh - 108;
    
    WsjTableView *tv = [[WsjTableView alloc] initWithFrame:CGRectMake(sw * placement, 0, sw, sha)];
    tv.dataSource = tv;
    tv.delegate = tv;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.separatorColor = [UIColor clearColor];
    
    return tv;
}

- (void)setTableViewData:(NSArray *)tableViewData {
    _tableViewData = tableViewData;
    [self reloadData];
}

#pragma mark UITableViewDataSource methods

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

#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WsjRssItem *wri = self.tableViewData[indexPath.row];
    AppDelegate *ad = [[UIApplication sharedApplication] delegate];
    UINavigationController *nc = (UINavigationController *) ad.window.rootViewController;
    ArticleViewController *avc = [[ArticleViewController alloc] initWithUrl:wri.urlString];
    [nc pushViewController:avc animated:YES];
}

@end
