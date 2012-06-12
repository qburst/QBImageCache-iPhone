//
//  QBImageCache.m
//  ImageDownloader
//
//  Created by renjini on 13/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QBImageCache.h"
#import "Reachability.h"

#define IMAGE_CACHE_PLIST @"ImageCache.plist"
#define FILE_PATH_KEY @"filePath"
#define URL_KEY @"url"
#define CACHE_EXPIRY_DATE @"cache_Expiry"
#define TIME_CONST 3600

@implementation QBImageCache

@synthesize imageDownloader = imageDownloader_;
@synthesize imageUrl = imageUrl_;
@synthesize cacheDelegate = cacheDelegate_;
@synthesize cacheDuration = cacheDuration_;

static NSMutableDictionary *cachedImages_ = nil;

BOOL isEnumerating = NO;

+ (NSMutableDictionary*)cachedImages {
    
    @synchronized(self){        
        if(cachedImages_ == nil) {
            cachedImages_ = [[NSMutableDictionary alloc]init];
        }
    }
	return cachedImages_;
}	

- (id)initWithUrl:(NSString*)url {
	
	self=[super init];
	if (self) {
		imageUrl_ = [url retain];
        imageDownloader_ = [[QBImageDownloader alloc]init];	
        self.imageDownloader.delegate = self;
	}
	return self;
}

/*
 Fetches images from cache ie the plist based on image url key
 If the cache expiry date has not crossed current date , the image is returned 
 */
- (UIImage *)fetchImageFromCache {
	
    isEnumerating = YES;
	
	NSDictionary * item = [[QBImageCache cachedImages] objectForKey:self.imageUrl];
    isEnumerating = NO;
    if (item) {
		NSDate* cachedExpiryDate = [item objectForKey:CACHE_EXPIRY_DATE];		
		NSDate *currentDate = [NSDate date];
        
        if ([self isNetWorkReachable]&&!([cachedExpiryDate timeIntervalSinceDate:currentDate] > 0)) {
            return nil;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];		
        NSString * filePath = [item objectForKey:FILE_PATH_KEY];
        
        if ([fileManager fileExistsAtPath:filePath]) {				
            UIImage *cachedImage = [UIImage imageWithContentsOfFile:filePath];
            return cachedImage;
        }
    }   
	return nil;
}

/*
 Function downloads the image when there is no available cached images
 Assists when 2 same url's are simultaneou;sy loaded from in parallel threads
 */
- (void)fetchImage {
	
	[self retain];
    isEnumerating = YES;
	NSDictionary *imageDict= [[QBImageCache cachedImages] objectForKey:self.imageUrl];
    isEnumerating = NO;
    
    NSDate* cachedExpiryDate = [imageDict objectForKey:CACHE_EXPIRY_DATE];
    		
    NSDate *currentDate = [NSDate date];
    
	if(imageDict&&[cachedExpiryDate timeIntervalSinceDate:currentDate] > 0) {
		
		NSFileManager *fileManager = [NSFileManager defaultManager];		
		NSString *filePath = [imageDict objectForKey:FILE_PATH_KEY];
		if ([fileManager fileExistsAtPath:filePath]) {
			UIImage *cachedImage = [UIImage imageWithContentsOfFile:filePath];
			[cacheDelegate_ didFetchImage:[NSURL URLWithString:self.imageUrl] image:cachedImage];
		}
        
	} else {
		[self retain];
		imageDownloader_.imageUrl = [NSURL URLWithString:self.imageUrl];
		[imageDownloader_ startImageDownload];
	}
    [self release];
}


/*
 When an image is downloaded a png format of the image is locally saved
 Appends the new file path with image url to the plist
 Called from didFinishImageDownload 
 */
- (void)cacheImagesToDocsDirectory:(UIImage *)cacheImage {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString *imageUrlString_ = self.imageUrl;
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
	NSArray * urlComponents = [imageUrlString_ componentsSeparatedByString:@"/"];
	NSString * fileName = [urlComponents lastObject];
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir, fileName];
	
	NSData *data = [NSData dataWithData:UIImagePNGRepresentation(cacheImage)];
	[data writeToFile:pngFilePath atomically:YES];
	
	NSMutableDictionary *imageDetails = [[NSMutableDictionary alloc]init];
	[imageDetails setObject:imageUrlString_ forKey:URL_KEY];
	[imageDetails setObject:pngFilePath forKey:FILE_PATH_KEY];
	
	NSDate *currentDate = [NSDate date];
	NSDate *expDate = [currentDate dateByAddingTimeInterval:TIME_CONST*cacheDuration_];		
	[imageDetails setObject:expDate forKey:CACHE_EXPIRY_DATE];
	if (isEnumerating) {
        while (isEnumerating);
    }
	[[QBImageCache cachedImages] setObject:imageDetails forKey:imageUrlString_];
    
	[imageDetails release];
	
	[pool release];
}

#pragma mark 
#pragma mark QBImageDownloader delegate
/*
 Function implement controller specific behaviour when image download finishes
 */
- (void)didFinishImageDownload:(NSURL*)url image:(UIImage*)downloadedImage {
	
	[cacheDelegate_ didFetchImage:url image:downloadedImage];
	[self performSelectorInBackground:@selector(cacheImagesToDocsDirectory:) withObject:downloadedImage];		
	self.cacheDelegate = nil;
	[self release];
}

/*
 Function implement controller specific behaviour when image download fails
 */
- (void)didFailImageDownload:(NSURL*) url {
	
	if ([(NSObject *)cacheDelegate_ respondsToSelector:@selector(didFailImageFetch:)])
		[cacheDelegate_ didFailImageFetch:url];
	self.cacheDelegate = nil;
	[self release];
}

/*
 Saves cached images to the plist
 */
+ (void)saveToPlist {	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *path = [documentsDirectory stringByAppendingPathComponent:IMAGE_CACHE_PLIST]; 
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: path])	{
		[[QBImageCache cachedImages] writeToFile:path atomically:YES];
	}
	else {
		[[QBImageCache cachedImages] writeToFile:path atomically:YES];
	}
}

/*
 Function load the cached images from plist
 */
+ (void)loadFromPlist {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *path = [documentsDirectory stringByAppendingPathComponent:IMAGE_CACHE_PLIST]; 
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath: path]) {
		cachedImages_= [[NSMutableDictionary alloc] initWithContentsOfFile:path];		
	}	
}

/*
 Function checks for internet connection
 */
- (BOOL)isNetWorkReachable {
	
	Reachability *internetReach;
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    if(netStatus == NotReachable) { 
        return NO;
    }
    else
        return YES;
}

- (void)dealloc {
	
    self.imageUrl = nil;
    self.imageDownloader.delegate = nil;
    self.imageDownloader = nil;
    [super dealloc];
}
@end
