//
//  PlayerDataDelegate.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/7/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

@protocol PlayerDataDelegate

-(void)playerDataDidUpdate:(NSArray *)playerDataPoints WithColorMap:(NSMutableDictionary *) colorMap;

@end
