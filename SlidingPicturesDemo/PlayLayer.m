//
//  PlayLayer.m
//  PlayLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "PlayLayer.h"
#import "GameOverLayer.h"

static const int kTimeUntilGameOver = 15;

@interface PlayLayer ()

@property (nonatomic,retain) CCLabelTTF *label;
@property (nonatomic,assign) int remainingTime;

@end

@implementation PlayLayer

@synthesize box = _box;
@synthesize selectedTile  = _selectedTile;
@synthesize firstOne = _firstOne;
@synthesize label = _label;
@synthesize remainingTime;

-(id) init{
	self = [super init];
	
	value = (arc4random() % kKindCount+1);
	self.box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth,kBoxHeight) imgValue:value];
	self.box.layer = self;
	self.box.lock = YES;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.label = [CCLabelTTF labelWithString:@"0"dimensions:CGSizeMake(460, 300) hAlignment:UITextAlignmentRight
                                    fontName:@"Verdana-Bold" fontSize:18.0];
    self.label.color = ccBLACK;
    int margin = 10;
    self.label.position = ccp(winSize.width - (self.label.contentSize.width/2)
                              - margin, self.label.contentSize.height/2 + margin);
    
    [self.label setString:[NSString stringWithFormat:@"%d", remainingTime]];
    [self addChild:self.label];
	
	[self.box check];
	
	self.isTouchEnabled = YES;
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(shuffleTiles)
                                   userInfo:nil
                                    repeats:NO];
    
    remainingTime = kTimeUntilGameOver;

    [self schedule: @selector(countdownTimerToGameOver:) interval:1.0f];
    
	return self;
    
}

- (void) countdownTimerToGameOver: (ccTime) dt
{
    [self.label setString:[NSString stringWithFormat:@"%d", remainingTime]];
    remainingTime--;
    if (remainingTime < 0) { // Go to Game Over scene
        [self unschedule:@selector(countdownTimerToGameOver:)];
        [self goToGameOverScene];
    }
}

-(void) goToGameOverScene
{
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:[self.box checkSolution]];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
    
}

-(void) shuffleTiles
{
    [self.box shuffleTiles];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if (location.y < (kStartY) || location.y > (kStartY + (kTileSize * kBoxHeight))) {
		return;
	}
	
	int x = (location.x - x_Offset) / (kTileSize);
	int y = (location.y - kStartY) / (kTileSize);
	
	if (self.selectedTile && self.selectedTile.x == x && self.selectedTile.y == y) {
		self.selectedTile = nil;
		return;
	}
	
	Tile *tile = [self.box objectAtX:x Y:y];
    self.selectedTile = tile;
//    CCLOG(@"Tapped over Tile at %d:%d",x,y);
    
//	if (tile.x >= 0 && tile.y >= 0) {
//		if (selectedTile && [selectedTile nearTile:tile]) {
//			[box setLock:YES];
//			[self changeWithTileA: selectedTile TileB: tile sel: @selector(check:data:)];
//			selectedTile = nil;
//		}
//		else {
//			if (selectedTile) {
//				if (selectedTile.x == x && selectedTile.y == y) {
//					selectedTile = nil;
//				}
//			}
//			selectedTile = tile;
//		}
//	}
}

// Override the "ccTouchesMoved:withEvent:" method to add your own logic
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    
    int xCoord = (location.x - x_Offset) / (kTileSize);
	int yCoord = (location.y - kStartY) / (kTileSize);
	
	if (self.selectedTile && self.selectedTile.x == xCoord && self.selectedTile.y == yCoord) {
		return;
	}
    
    //Lets check what's the Tile to be swapped

    Tile *tile = [self.box objectAtX:xCoord Y:yCoord];
	if (tile.x >= 0 && tile.y >= 0)
    {
        if (self.selectedTile && [self.selectedTile nearTile:tile])
        {
			[self.box setLock:YES];
//            CCLOG(@"Swaping Tile at %d:%d",xCoord,yCoord);
			[self.box changeWithTileA: self.selectedTile TileB: tile];
			self.selectedTile = nil;
		}
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    
    int xCoord = (location.x - x_Offset) / (kTileSize);
	int yCoord = (location.y - kStartY) / (kTileSize);
	
	if (self.selectedTile && self.selectedTile.x == xCoord && self.selectedTile.y == yCoord) {
		return;
	}
    
    //Lets check what's the Tile to be swapped
    
    Tile *tile = [self.box objectAtX:xCoord Y:yCoord];
	if (tile.x >= 0 && tile.y >= 0)
    {
        if (self.selectedTile && [self.selectedTile nearTile:tile])
        {
			[self.box setLock:YES];
			[self.box changeWithTileA: self.selectedTile TileB: tile];
			self.selectedTile = nil;
		}
    }
    
}


@end
