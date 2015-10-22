//
//  ViewController.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "ViewController.h"
#import "LoadWsjData.h"
#import "WsjTableViewDelegate.h"

@interface ViewController () <LoadWsjDataDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *headerScroller;
@property (weak, nonatomic) IBOutlet UIView *headersContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIView *tablesContainer;
@property (nonatomic, strong) UITableView *tvWorldNews;
@property (nonatomic, strong) UITableView *tvOpinion;
@property (nonatomic, strong) UITableView *tvBusiness;
@property (nonatomic, strong) UITableView *tvMarkets;
@property (nonatomic, strong) UITableView *tvTech;
@property (nonatomic, strong) UITableView *tvLife;
@property (nonatomic, strong) WsjTableViewDelegate *worldNewsTvDelegate;
@property (nonatomic, strong) WsjTableViewDelegate *opinionTvDelegate;
@property (nonatomic, strong) WsjTableViewDelegate *businessTvDelegate;
@property (nonatomic, strong) WsjTableViewDelegate *marketsTvDelegate;
@property (nonatomic, strong) WsjTableViewDelegate *techTvDelegate;
@property (nonatomic, strong) WsjTableViewDelegate *lifeTvDelegate;

@property (nonatomic, strong) UIColor *headerLblBgClr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblcContainerCenterXConstr;

@property (weak, nonatomic) IBOutlet UILabel *worldL;
@property (weak, nonatomic) IBOutlet UILabel *opinesL;
@property (weak, nonatomic) IBOutlet UILabel *BizL;
@property (weak, nonatomic) IBOutlet UILabel *marketsL;
@property (weak, nonatomic) IBOutlet UILabel *techL;
@property (weak, nonatomic) IBOutlet UILabel *lifeL;

@end

@implementation ViewController

- (id)init {
    if (self = [super initWithNibName:@"View" bundle:nil]) {
        [LoadWsjData manager].wsjDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Wall Street Journal"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect s = [[UIScreen mainScreen] bounds];
    CGFloat sw = s.size.width;
    CGFloat sh = s.size.height;
    CGFloat sha = sh - 108;    
    
    self.worldNewsTvDelegate = [WsjTableViewDelegate new];
    self.tvWorldNews = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, sw, sha)];
    self.tvWorldNews.dataSource = self.worldNewsTvDelegate;
    self.tvWorldNews.delegate = self.worldNewsTvDelegate;
    [self.tablesContainer addSubview:self.tvWorldNews];
    
    int pm = 1;
    
    self.opinionTvDelegate = [WsjTableViewDelegate new];
    self.tvOpinion = [[UITableView alloc] initWithFrame:CGRectMake(sw * pm++, 0, sw, sha)];
    self.tvOpinion.dataSource = self.opinionTvDelegate;
    self.tvOpinion.delegate = self.opinionTvDelegate;
    [self.tablesContainer addSubview:self.tvOpinion];
    
    self.businessTvDelegate = [WsjTableViewDelegate new];
    self.tvBusiness = [[UITableView alloc] initWithFrame:CGRectMake(sw * pm++, 0, sw, sha)];
    self.tvBusiness.dataSource = self.businessTvDelegate;
    self.tvBusiness.delegate = self.businessTvDelegate;
    [self.tablesContainer addSubview:self.tvBusiness];
    
    self.marketsTvDelegate = [WsjTableViewDelegate new];
    self.tvMarkets = [[UITableView alloc] initWithFrame:CGRectMake(sw * pm++, 0, sw, sha)];
    self.tvMarkets.dataSource = self.marketsTvDelegate;
    self.tvMarkets.delegate = self.marketsTvDelegate;
    [self.tablesContainer addSubview:self.tvMarkets];
    
    self.techTvDelegate = [WsjTableViewDelegate new];
    self.tvTech = [[UITableView alloc] initWithFrame:CGRectMake(sw * pm++, 0, sw, sha)];
    self.tvTech.dataSource = self.techTvDelegate;
    self.tvTech.delegate = self.techTvDelegate;
    [self.tablesContainer addSubview:self.tvTech];
    
    self.lifeTvDelegate = [WsjTableViewDelegate new];
    self.tvLife = [[UITableView alloc] initWithFrame:CGRectMake(sw * pm++, 0, sw, sha)];
    self.tvLife.dataSource = self.lifeTvDelegate;
    self.tvLife.delegate = self.lifeTvDelegate;
    [self.tablesContainer addSubview:self.tvLife];
    
    [self.scroller removeConstraint:self.tblcContainerCenterXConstr];
    self.tablesContainer.translatesAutoresizingMaskIntoConstraints = YES;
    self.tablesContainer.frame = CGRectMake(0, 0, sw * pm, sha);
    self.scroller.contentSize = CGSizeMake(sw * pm, sha);
    
    self.scroller.delegate = self;
    
    self.worldL.backgroundColor = self.headerLblBgClr;
    
    self.tvWorldNews.separatorStyle = self.tvOpinion.separatorStyle = self.tvBusiness.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tvWorldNews.separatorColor = self.tvOpinion.separatorColor = self.tvBusiness.separatorColor = [UIColor clearColor];
    
    [LoadWsjData loadWorldNews];
    [LoadWsjData loadOpinion];
    [LoadWsjData loadBusiness];
    [LoadWsjData loadMarkets];
    [LoadWsjData loadTech];
    [LoadWsjData loadLife];
}

- (UIColor *)headerLblBgClr {
    return _headerLblBgClr ? : (_headerLblBgClr = [UIColor colorWithRed:0.79f green:0.79f blue:0.79f alpha:1.0f]);
}

#pragma mark LoadWsjDataDelegate methods

- (void)loadedWorldNews:(NSArray *)wsjItems {
    self.worldNewsTvDelegate.tableViewData = wsjItems;
    [self.tvWorldNews reloadData];
}

- (void)loadedOpinion:(NSArray *)wsjItems {
    self.opinionTvDelegate.tableViewData = wsjItems;
    [self.tvOpinion reloadData];
}

- (void)loadedBusiness:(NSArray *)wsjItems {
    self.businessTvDelegate.tableViewData = wsjItems;
    [self.tvBusiness reloadData];
}

- (void)loadedMarkets:(NSArray *)wsjItems {
    self.marketsTvDelegate.tableViewData = wsjItems;
    [self.tvMarkets reloadData];
}

- (void)loadedTech:(NSArray *)wsjItems {
    self.techTvDelegate.tableViewData = wsjItems;
    [self.tvTech reloadData];
}

- (void)loadedLife:(NSArray *)wsjItems {
    self.lifeTvDelegate.tableViewData = wsjItems;
    [self.tvLife reloadData];
}

#pragma mark Scroll View Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float pageWidth = [[UIScreen mainScreen] bounds].size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    long currentPageNumber = 1 + lround(fractionalPage);
    
    UILabel *sl = nil;
    
    switch (currentPageNumber) {
        case 1:
            sl = self.worldL;
            break;
            
        case 2:
            sl = self.opinesL;
            break;
            
        case 3:
            sl = self.BizL;
            break;
            
        case 4:
            sl = self.marketsL;
            break;
            
        case 5:
            sl = self.techL;
            break;
            
        case 6:
            sl = self.lifeL;
            break;
            
        default:
            break;
    }
    
    [self.headerScroller scrollRectToVisible:sl.frame animated:YES];
    [self returnHeaderLabelBackGroundColor];
    sl.backgroundColor = [self headerLblBgClr];
}

- (void)returnHeaderLabelBackGroundColor {
    self.worldL.backgroundColor = self.opinesL.backgroundColor = self.BizL.backgroundColor = self.marketsL.backgroundColor = self.techL.backgroundColor = self.lifeL.backgroundColor = [UIColor clearColor];
}

@end
