//
//  HomeViewController.h
//  ImageCacheSampleProject
//
//  Created by martin on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImageCache.h"


@interface HomeViewController : UIViewController<QBImageCacheDelegate> {
	
	IBOutlet UITableView *homeTableView_;
	NSArray *tableData_;
	NSMutableDictionary *imageList_; 

}
- (NSString *)getImageUrlPlistPath;
- (void)getImageUrlList;
@end
