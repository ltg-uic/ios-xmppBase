//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "Player.h"
#import "DataStore.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@implementation DataStore

static NSMutableDictionary *dataPoints;
static NSMutableArray *players;
static NSMutableArray *clusters;

NSString *lastCluster;


#pragma mark - Class methods

+ (DataStore *)sharedInstance
{
    static DataStore *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initCollections];
    }
    return self;
}

-(void)initCollections {
    dataPoints = [NSMutableDictionary dictionary];
    players = [NSMutableArray array];
    
    [players addObject:[[Player alloc] initWithRFID:@"1623365"  AndCluster:@"a" AndColor:@"#99896f" AndScore:[NSNumber numberWithInt:1000]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623641"  AndCluster:@"a" AndColor:@"#89369e" AndScore:[NSNumber numberWithInt:200]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623683"  AndCluster:@"a" AndColor:@"#cb5012" AndScore:[NSNumber numberWithInt:3000]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623624"  AndCluster:@"a" AndColor:@"#146d71" AndScore:[NSNumber numberWithInt:1000]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623352"  AndCluster:@"a" AndColor:@"#ffbeb4" AndScore:[NSNumber numberWithInt:50]]];
//
    [players addObject:[[Player alloc] initWithRFID:@"1623678"  AndCluster:@"b" AndColor:@"#99896f" AndScore:[NSNumber numberWithInt:1400]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623663"  AndCluster:@"b" AndColor:@"#89369e" AndScore:[NSNumber numberWithInt:1200]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623302"  AndCluster:@"b" AndColor:@"#cb5012" AndScore:[NSNumber numberWithInt:2000]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623303"  AndCluster:@"b" AndColor:@"#146d71" AndScore:[NSNumber numberWithInt:6000]]];
 [players addObject:[[Player alloc] initWithRFID:@"1623126"  AndCluster:@"b" AndColor:@"#ffbeb4" AndScore:[NSNumber numberWithInt:4000]]];
//    //
   [players addObject:[[Player alloc] initWithRFID:@"1623238"  AndCluster:@"c" AndColor:@"#99896f" AndScore:[NSNumber numberWithInt:300]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623257"  AndCluster:@"c" AndColor:@"#89369e" AndScore:[NSNumber numberWithInt:20]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623210"  AndCluster:@"c" AndColor:@"#cb5012" AndScore:[NSNumber numberWithInt:120]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623305"  AndCluster:@"c" AndColor:@"#146d71" AndScore:[NSNumber numberWithInt:0]]];
   [players addObject:[[Player alloc] initWithRFID:@"1623386"  AndCluster:@"c" AndColor:@"#ffbeb4" AndScore:[NSNumber numberWithInt:26]]];
//    //
    [players addObject:[[Player alloc] initWithRFID:@"1623392"  AndCluster:@"d" AndColor:@"#99896f" AndScore:[NSNumber numberWithInt:5]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623115"  AndCluster:@"d" AndColor:@"#89369e" AndScore:[NSNumber numberWithInt:4]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623373"  AndCluster:@"d" AndColor:@"#cb5012" AndScore:[NSNumber numberWithInt:39]]];
    [players addObject:[[Player alloc] initWithRFID:@"1623110"  AndCluster:@"d" AndColor:@"#146d71" AndScore:[NSNumber numberWithInt:9]]];
   [players addObject:[[Player alloc] initWithRFID:@"1623667"  AndCluster:@"d" AndColor:@"#ffbeb4" AndScore:[NSNumber numberWithInt:57]]];
    
    clusters = [NSMutableArray array];
}

#pragma mark - data access methods


-(void)zeroOutPlayersScore {
    for (Player *p in players) {
        p.score = 0;
    }
}

- (void)resetPlayerCount {
    [players removeAllObjects];
    [clusters removeAllObjects];
    lastCluster = nil;
}

- (Player *)playerAt: (int)index {
    return players[index];
}

- (int)playerCount {
    return [players count];
}

- (NSMutableArray *)clusterLabels {
    return clusters;
}

- (int)clusterCountWith: (NSString *)label {
    int i = 0;
    for (Player *p in players) {

        if( [p.cluster isEqualToString:label] ) {
            i++;
        }
    }
    return i;
}


- (void)addScore: (NSNumber *)score WithIndex: (NSNumber *)index {
    Player *p = [players objectAtIndex:[index intValue]];
    p.score = [NSNumber numberWithDouble:[p.score doubleValue] + [score doubleValue]];
}

- (void)addPlayerWithRFID:(NSString *)rfid withCluster:(NSString *)cluster withColor:(NSString *)color {
    
    [players addObject:[[Player alloc] initWithRFID:rfid  AndCluster:cluster AndColor:color AndScore:[NSNumber numberWithInt:0]]];
    
    //sort the array
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cluster" ascending:TRUE];
    NSSortDescriptor *rfidDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rfid" ascending:YES];

    [players sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, rfidDescriptor, nil]];
}

- (void)addPlayerSpacing {
    for (int i = 0; i < [players count]; i++) {
        Player *player = [players objectAtIndex: i];
        
        if( lastCluster == nil ) {
            lastCluster = player.cluster;
            [clusters addObject:lastCluster];
        } else if( ![lastCluster isEqualToString:player.cluster] ) {
            lastCluster = player.cluster;
            [clusters addObject:lastCluster];
            [players insertObject:[[Player alloc] initWithRFID:@"" AndCluster:@"" AndColor:@"blank" AndScore:0] atIndex:i];
        };

    }
}

- (void)printPlayers {
    NSLog(@"PRINTING LOCAL DB");
    for (Player *player in players) {
       NSLog(@"%@\n", [player description]);
        
    }
}


- (void)addScore:(NSNumber *)score withRFID: (NSString *)rfid {
    
    for (int i = 0; i < [players count]; i++) {
        Player *p = [players objectAtIndex: i];
        if([p.rfid isEqualToString:rfid]){
            p.score = [NSNumber numberWithDouble:[p.score doubleValue] + [score doubleValue]];
            break;
        }
    }
}


- (void)addScore:(NSNumber *)score withKey: (NSNumber *)key {
    Player *p = [players objectAtIndex:[key integerValue]];
    p.score = [NSNumber numberWithDouble:[p.score doubleValue] + [score doubleValue]];
}

- (NSNumber *)scoreForRFID:(NSString *)rfid {
    for (int i = 0; i < [players count]; i++) {
        Player *p = [players objectAtIndex: i];
        if([p.rfid isEqualToString:rfid]){
            return p.score;
        }
    }
    return nil;
}

- (void)resetScoreWithRFID:  (NSString *)rfid {
    for (int i = 0; i < [players count]; i++) {
        Player *p = [players objectAtIndex: i];
        if([p.rfid isEqualToString:rfid]){
            p.score = 0;
            break;
        }
    }
}

- (NSNumber *)scoreForKey: (NSUInteger)key {
    Player *player = [players objectAtIndex:key];
    return player.score;
}

- (NSString *)colorForKey: (NSUInteger)key {
    Player *player = [players objectAtIndex:key];
    return player.color;
}

- (NSArray *)datesInMonth
{
    static NSArray *dates = nil;
    if (!dates)
    {
        dates = [NSArray arrayWithObjects:
                 @"2",
                 @"3",
                 @"4",
                 @"5",
                 @"9",
                 @"10",
                 @"11",
                 @"12",
                 @"13",
                 @"16",
                 @"17",
                 @"18",
                 @"19",
                 @"20",
                 @"23",
                 @"24",
                 @"25",
                 @"26",
                 @"27",
                 @"30",
                 nil];
    }
    return dates;
}


@end
