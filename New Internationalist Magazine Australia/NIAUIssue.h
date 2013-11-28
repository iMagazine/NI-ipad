//
//  NIAUIssue.h
//  New Internationalist Magazine Australia
//
//  Created by Simon Loffler on 24/06/13.
//  Copyright (c) 2013 New Internationalist Australia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NewsstandKit/NewsstandKit.h>
#import "NIAUArticle.h"

extern NSString *ArticlesDidUpdateNotification;
extern NSString *ArticlesFailedUpdateNotification;

@interface NIAUIssue : NSObject {
    NSDictionary *dictionary;
    NSArray *articles;
    BOOL requestingArticles;
    NIAUCache *coverThumbCache;
    NIAUCache *coverCache;
}

-(NSString *)name;
-(NSDate *)publication;

-(NSNumber *)railsID;
-(NSString *)title;
-(NSString *)editorsLetter;
-(NSString *)editorsName;

+(NSArray *)issuesFromNKLibrary;
+(NIAUIssue *)issueWithDictionary:(NSDictionary *)dict;

-(void)getCoverWithCompletionBlock:(void(^)(UIImage *img))block;

-(void)getCoverThumbWithSize:(CGSize)size andCompletionBlock:(void (^)(UIImage *))block;

-(UIImage *)attemptToGetCoverThumbFromMemoryForSize:(CGSize)size;

-(void)getEditorsImageWithCompletionBlock:(void(^)(UIImage *img))block;

-(NKIssue *)nkIssue;

-(void)requestArticles;
-(void)forceDownloadArticles;
-(NSInteger)numberOfArticles;
-(NIAUArticle *)articleAtIndex:(NSInteger)index;


- (NSURL *)getWebURL;

@end
