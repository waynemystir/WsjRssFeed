//
//  LoadWsjData.h
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LOAD_DATA_TYPE) {
    WORLD = 0,
    OPINION = 1,
    BUSINESS = 2,
    MARKETS = 3,
    TECH = 4,
    LIFE = 5
};

@protocol LoadWsjDataDelegate <NSObject>

@required

- (void)loadedWorldNews:(NSArray *)wsjItems;
- (void)loadedOpinion:(NSArray *)wsjItems;
- (void)loadedBusiness:(NSArray *)wsjItems;
- (void)loadedMarkets:(NSArray *)wsjItems;
- (void)loadedTech:(NSArray *)wsjItems;
- (void)loadedLife:(NSArray *)wsjItems;
- (void)requestTimedOut:(NSNumber *)dataType;
- (void)requestFailedOffline:(NSNumber *)dataType;
- (void)requestFailed:(NSNumber *)dataType;

@end

@interface LoadWsjData : NSObject

@property (nonatomic, weak) NSObject<LoadWsjDataDelegate> *wsjDelegate;

+ (LoadWsjData *)manager;
+ (void)loadWorldNews;
+ (void)loadOpinion;
+ (void)loadBusiness;
+ (void)loadMarkets;
+ (void)loadTech;
+ (void)loadLife;

@end
