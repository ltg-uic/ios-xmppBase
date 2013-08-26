//
//  CPDStockPriceStore.h
//  CorePlotDemo
//
//  Created by Steve Baranski on 5/4/12.
//  Copyright (c) 2012 komorka technology, llc. All rights reserved.
//

#import "Player.h"

@interface DataStore : NSObject



+ (DataStore *)sharedInstance;

- (void)resetPlayerCount;
- (Player *)playerAt: (int)index;
- (void)zeroOutPlayersScore;
- (int)playerCount;
- (void)printPlayers;
- (int)clusterCountWith: (NSString *)label;

- (NSMutableArray *)clusterLabels;
- (void)addPlayerSpacing;
- (void)addPlayerWithRFID:(NSString *)rfid withCluster:(NSString *)cluster withColor:(NSString *)color;

- (void)addScore: (NSNumber *)score WithIndex: (NSNumber *)index;
- (void)addScore:(NSNumber *)score withRFID: (NSString *)rfid;
- (void)addScore:(NSNumber *)score withKey: (NSNumber *)key;
- (void)resetScoreWithRFID: (NSString *)rfid;

- (NSNumber *)scoreForRFID: (NSString *)rfid;
- (NSNumber *)scoreForKey: (NSUInteger)key;
- (NSString *)colorForKey: (NSUInteger)key;

- (NSArray *)datesInMonth;
@end
