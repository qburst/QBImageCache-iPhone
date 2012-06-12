//
//  QBImageDownloader.h
//  ImageDownloader
//
//  Created by renjini on 13/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBImageDownloaderDelegate;
@interface QBImageDownloader : NSObject {
	
	NSURL *imageUrl_;
	NSURLConnection* connection_; 
	NSMutableData* data_; 
	id <QBImageDownloaderDelegate> delegate_;
}

@property(nonatomic,retain) NSURL *imageUrl;
@property(nonatomic,assign) id <QBImageDownloaderDelegate> delegate;

- (void)startImageDownload;

@end

@protocol QBImageDownloaderDelegate

- (void)didFinishImageDownload:(NSURL*)url image:(UIImage*)downloadedImage;
- (void)didFailImageDownload:(NSURL*) url;

@end


