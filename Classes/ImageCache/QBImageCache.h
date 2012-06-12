//
//  QBImageCache.h
//  ImageDownloader
//
//  Created by renjini on 13/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBImageDownloader.h"

@protocol QBImageCacheDelegate;

@interface QBImageCache : NSObject <QBImageDownloaderDelegate> {
	
	QBImageDownloader *imageDownloader_;
	NSString *imageUrl_;
	id <QBImageCacheDelegate> cacheDelegate_;
	float cacheDuration_;
}

@property(nonatomic,retain) QBImageDownloader *imageDownloader;
@property(nonatomic, retain) NSString *imageUrl;
@property(nonatomic,retain) id <QBImageCacheDelegate> cacheDelegate;
@property float cacheDuration;

- (id) initWithUrl:(NSString*)url;
+ (NSMutableDictionary*) cachedImages;
+ (void) saveToPlist;
+ (void) loadFromPlist;
- (void)fetchImage;
- (void)cacheImagesToDocsDirectory:(UIImage *)cacheImage;
- (UIImage *)fetchImageFromCache;
- (BOOL) isNetWorkReachable;

@end

@protocol QBImageCacheDelegate

- (void)didFetchImage:(NSURL*) url image:(UIImage*)cachedImage;

@optional

-(void)didFailImageFetch:(NSURL*)url;
@end