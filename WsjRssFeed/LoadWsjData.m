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

NSString * dataTypeName(LOAD_DATA_TYPE dataType) {
    switch (dataType) {
        case WORLD:
            return @"World News";
            
        case OPINION:
            return @"Opinions";
            
        case BUSINESS:
            return @"Business News";
            
        case MARKETS:
            return @"Markets";
            
        case TECH:
            return @"Technology News";
            
        case LIFE:
            return @"Lifestyle Section";
            
        default:
            break;
    }
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
    [self dataTaskWithURL:urlRssFeed(kWorldNews) dataType:WORLD];
}

+ (void)loadOpinion {
    [self dataTaskWithURL:urlRssFeed(kOpinion) dataType:OPINION];
}

+ (void)loadBusiness {
    [self dataTaskWithURL:urlRssFeed(kBusiness) dataType:BUSINESS];
}

+ (void)loadMarkets {
    [self dataTaskWithURL:urlRssFeed(kMarkets) dataType:MARKETS];
}

+ (void)loadTech {
    [self dataTaskWithURL:urlRssFeed(kTech) dataType:TECH];
}

+ (void)loadLife {
    [self dataTaskWithURL:urlRssFeed(kLife) dataType:LIFE];
}

+ (void)dataTaskWithURL:(NSURL *)url dataType:(LOAD_DATA_TYPE)dataType {
    
    Class lwdClass = [self class];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error || ((NSHTTPURLResponse *) response).statusCode != 200)
            switch (error.code) {
                case NSURLErrorTimedOut:
                    return [lwdClass performDelegateSelector:@selector(requestTimedOut:) dataType:dataType parameter2:nil];
                    
                case NSURLErrorNotConnectedToInternet:
                    return [lwdClass performDelegateSelector:@selector(requestFailedOffline:) dataType:dataType parameter2:nil];
                    
                default:
                    return [lwdClass performDelegateSelector:@selector(requestFailed:) dataType:dataType parameter2:nil];
            }
        
        ParseWsjDocOperation *op = [[ParseWsjDocOperation alloc] initWithData:data];
        __weak ParseWsjDocOperation *wop = op;
        
        op.completionBlock = ^{
            [lwdClass performDelegateSelector:@selector(loadedData:wsjItems:) dataType:dataType parameter2:wop.wsjItems];
        };
        
        [[self parseOperationQueue] addOperation:op];
        
    }] resume];
}

+ (void)performDelegateSelector:(SEL)selector dataType:(LOAD_DATA_TYPE)dataType parameter2:(id)parameter2 {
    if (![[self manager].wsjDelegate respondsToSelector:selector])
        return;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[[self manager].wsjDelegate class] instanceMethodSignatureForSelector:selector]];
    [invocation retainArguments];
    invocation.target = [self manager].wsjDelegate;
    invocation.selector = selector;
    [invocation setArgument:&dataType atIndex:2];
    if (parameter2)
        [invocation setArgument:&parameter2 atIndex:3];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [invocation invoke];
    }];
}

@end
