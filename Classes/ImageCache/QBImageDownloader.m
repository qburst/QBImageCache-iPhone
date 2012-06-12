//
//  QBImageDownloader.m
//  ImageDownloader
//
//  Created by renjini on 13/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QBImageDownloader.h"


@implementation QBImageDownloader
@synthesize imageUrl = imageUrl_;
@synthesize delegate = delegate_;

- (id) init {
	
	self = [super init];
	if (self != nil) {
		data_ =	[[NSMutableData alloc] init];
	}
	return self;
}

/*
 Each time clear the old connection request and create a new one with the url
 Reset the variable's length to 0 before storing the new image
 */
- (void)startImageDownload {
	
    NSURLRequest* request = [NSURLRequest requestWithURL:imageUrl_];
	if (connection_ != nil) {
        [connection_ release];
        connection_ = nil;
    }
    connection_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
	if (connection_) {
        if (data_==nil) {
            data_ =	[[NSMutableData alloc] init];
        }
		[data_ setLength:0];
	}
}

 
- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
	
    [data_ appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	[data_ setLength:0];
}


- (void)connection:(NSURLConnection *)urlConnection didFailWithError:(NSError *)error {
	
	[delegate_ didFailImageDownload:imageUrl_];
    if (data_) {
        [data_ release];
    }
	data_ = nil;
	urlConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)urlConnection {

    UIImage *image = [[UIImage alloc] initWithData:data_];
    if (data_) {
        [data_ release];
    }
	data_ = nil;
    urlConnection = nil;
	[delegate_ didFinishImageDownload:imageUrl_ image:image];
	[image autorelease];
}

- (void) dealloc {
	
	if (data_) {		
		[data_ release];
	}
	
	if (connection_) {
		[connection_ release];
	}
	[super dealloc];
}

@end
