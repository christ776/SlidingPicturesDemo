//
//  Box.h
//  Box
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "cocos2d.h"

#import "Constants.h"
#import "Tile.h"

@interface Box : NSObject {
	id first, second;
	CGSize size;
	NSMutableArray *content;
	NSMutableSet *readyToRemoveTiles;
	BOOL lock;
	CCLayer *layer;
	Tile *OutBorderTile;
	
	NSInteger imgValue;
}
@property(nonatomic, retain) CCLayer *layer;
@property(nonatomic, readonly) CGSize size;
@property(nonatomic) BOOL lock;

-(id) initWithSize: (CGSize) size imgValue: (int) aImgValue;
-(Tile *) objectAtX: (int) posX Y: (int) posY;
-(BOOL) check;
-(void) shuffleTiles;
-(BOOL) checkSolution;
-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b;

@end
