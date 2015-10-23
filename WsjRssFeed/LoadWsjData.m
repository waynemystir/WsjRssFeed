//
//  LoadWsjData.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "LoadWsjData.h"
#import "ParseWsjDocOperation.h"

NSString * const kBaseUrl = @"http://www.wsj.com/xml/rss";
NSString * const kWorldNews = @"3_7085.xml";
NSString * const kOpinion = @"3_7041.xml";
NSString * const kBusiness = @"3_7014.xml";
NSString * const kMarkets = @"3_7031.xml";
NSString * const kTech = @"3_7455.xml";
NSString * const kLife = @"3_7201.xml";

NSURL * urlRssFeed(NSString *feed) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kBaseUrl, feed]];
}

@implementation LoadWsjData

+ (LoadWsjData *)manager {
    static LoadWsjData *_lwd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lwd = [LoadWsjData new];
    });
    
    return _lwd;
}

+ (NSOperationQueue *)parseOperationQueue {
    static NSOperationQueue *_oq = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _oq = [NSOperationQueue new];
    });
    return _oq;
}

+ (void)loadWorldNews {
    [self dataTaskWithURL:urlRssFeed(kWorldNews) completionSelector:@selector(loadedWorldNews:) dataType:WORLD];
}

+ (void)loadOpinion {
    [self dataTaskWithURL:urlRssFeed(kOpinion) completionSelector:@selector(loadedOpinion:) dataType:OPINION];
}

+ (void)loadBusiness {
    [self dataTaskWithURL:urlRssFeed(kBusiness) completionSelector:@selector(loadedBusiness:) dataType:BUSINESS];
}

+ (void)loadMarkets {
    [self dataTaskWithURL:urlRssFeed(kMarkets) completionSelector:@selector(loadedMarkets:) dataType:MARKETS];
}

+ (void)loadTech {
    [self dataTaskWithURL:urlRssFeed(kTech) completionSelector:@selector(loadedTech:) dataType:TECH];
}

+ (void)loadLife {
    [self dataTaskWithURL:urlRssFeed(kLife) completionSelector:@selector(loadedLife:) dataType:LIFE];
}

+ (void)dataTaskWithURL:(NSURL *)url
     completionSelector:(SEL)selector
               dataType:(LOAD_DATA_TYPE)dataType {
    
    __weak LoadWsjData *lwd = [self manager];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error || ((NSHTTPURLResponse *) response).statusCode != 200) {
            SEL sel = nil;
            switch (error.code) {
                case NSURLErrorTimedOut:
                    sel = @selector(requestTimedOut:);
                    break;
                    
                case NSURLErrorNotConnectedToInternet:
                    sel = @selector(requestFailedOffline:);
                    break;
                    
                default:
                    sel = @selector(requestFailed:);
                    break;
            }
            
            [lwd performDelegateSelector:sel withObject:[NSNumber numberWithInt:dataType]];
            return;
        }
        
        ParseWsjDocOperation *op = [[ParseWsjDocOperation alloc] initWithData:data];
        __weak ParseWsjDocOperation *wop = op;
        
        op.completionBlock = ^{
            [lwd performDelegateSelector:selector withObject:wop.wsjItems];
        };
        
        [[self parseOperationQueue] addOperation:op];
        
    }] resume];
}

- (void)performDelegateSelector:(SEL)selector withObject:(NSObject *)parameter {
    if (self.wsjDelegate && [self.wsjDelegate respondsToSelector:selector])
        [self.wsjDelegate performSelectorOnMainThread:selector withObject:parameter waitUntilDone:NO];
}

@end
