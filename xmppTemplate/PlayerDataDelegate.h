//
//  PlayerDataDelegate.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/7/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

@protocol PlayerDataDelegate

#import "PlayerDataPoint.h"

-(void)playerDataDidUpdate:(NSArray *)playerDataPoints WithColorMap:(NSMutableDictionary *) colorMap;

-(void)playerDataDidUpdateWithArrival:(NSString *)arrival_patch_id WithDeparture:(NSString *)departure_patch_id WithPlayerId:(NSString *)player_id WithColor:(NSString *)color;


@end
