//
//  HomeViewController.m
//  ImageCacheSampleProject
//
//  Created by martin on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"


@implementation HomeViewController


#pragma mark -
#pragma mark View lifecycle



- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
		imageList_ = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	[self getImageUrlList];
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 500;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
	HomeTableViewCell * cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    // Configure the cell..
	cell.titleLabel = [[tableData_ objectAtIndex:(indexPath.row%11)] objectForKey:@"Name"];
	
	
	if ([imageList_ objectForKey:[NSString stringWithFormat:@"%d",(indexPath.row%11)]]==nil) {
		
		QBImageCache *imageCache = [[QBImageCache alloc]initWithUrl:[[tableData_ objectAtIndex:(indexPath.row%11)] objectForKey:@"URL"]];
		UIImage *cache = [imageCache fetchImageFromCache];
		
		if (cache != nil) {
			
			cell.logo = cache;
			[imageList_ setObject:cache forKey:[NSString stringWithFormat:@"%d",(indexPath.row%11)]];
			
		}
		else {
			imageCache.cacheDelegate = self;
			imageCache.cacheDuration = 5;
			[imageCache fetchImage];
			cell.logo = nil;
			}
		[imageCache release];

	}
	else {
		
		cell.logo = [imageList_ objectForKey:[NSString stringWithFormat:@"%d",(indexPath.row%11)]];
	
	}
    return cell;
}


/*
 Delegate method for QBImageCache, the cached image obtained here.
 */
- (void) didFetchImage:(NSURL *)imageUrl_ image:(UIImage *)cachedImage {
	
	int i=0;
	for (NSDictionary *dict in tableData_) {
		if ([[dict objectForKey:@"URL"] isEqual:[imageUrl_ absoluteString]])  {
			NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
			HomeTableViewCell *cell =(HomeTableViewCell *)[homeTableView_ cellForRowAtIndexPath:ip];
			if (cachedImage) {
				
				cell.logo = cachedImage;
				[imageList_ setObject:cachedImage forKey:[NSString stringWithFormat:@"%d",ip.row]];
			
			}
			
		}
		i++;
	}	
}

- (NSString *)getImageUrlPlistPath {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageUrl" ofType:@"plist"];
	return path;
}

- (void)getImageUrlList {
	
	tableData_ = [[NSArray alloc] initWithContentsOfFile:[self getImageUrlPlistPath]];
	[homeTableView_ reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	homeTableView_.dataSource = nil;
	homeTableView_.delegate = nil;
	[homeTableView_ release];
}


- (void)dealloc {
	
	[tableData_ release];
	[imageList_ release];
	[homeTableView_ release];
    [super dealloc];
}

@end

