//
//  PlayLayer.m
//  PlayLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "cocos2d.h"

#import "Box.h"

@interface PlayLayer : CCLayer
{	
	BOOL isMoving;
	
	NSInteger value;
}

@property (nonatomic,retain) Box *box;
@property (nonatomic,retain) Tile *selectedTile;
@property (nonatomic,retain) Tile *firstOne;
@end
