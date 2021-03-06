//
//  Clock.m
//  DCTimer scramblers
//
//  Created by MeigenChou on 13-3-2.
//  Copyright (c) 2013年 MeigenChou. All rights reserved.
//

#import "Clock.h"
#import "stdlib.h"
#import "time.h"
@interface Clock()
@property (nonatomic, strong) NSArray *turns;
@end

@implementation Clock
@synthesize turns;
int movesClk[9][18] = {
    {0,1,1,0,1,1,0,0,0,  -1, 0, 0, 0, 0, 0, 0, 0, 0},// UR
    {0,0,0,0,1,1,0,1,1,   0, 0, 0, 0, 0, 0,-1, 0, 0},// DR
    {0,0,0,1,1,0,1,1,0,   0, 0, 0, 0, 0, 0, 0, 0,-1},// DL
    {1,1,0,1,1,0,0,0,0,   0, 0,-1, 0, 0, 0, 0, 0, 0},// UL
    {1,1,1,1,1,1,0,0,0,  -1, 0,-1, 0, 0, 0, 0, 0, 0},// U
    {0,1,1,0,1,1,0,1,1,  -1, 0, 0, 0, 0, 0,-1, 0, 0},// R
    {0,0,0,1,1,1,1,1,1,   0, 0, 0, 0, 0, 0,-1, 0,-1},// D
    {1,1,0,1,1,0,1,1,0,   0, 0,-1, 0, 0, 0, 0, 0,-1},// L
    {1,1,1,1,1,1,1,1,1,  -1, 0,-1, 0, 0, 0,-1, 0,-1},// A
};
int movesOld[][18] = {
    {1,1,1,1,1,1,0,0,0,  -1, 0,-1, 0, 0, 0, 0, 0, 0},//UUdd
    {0,1,1,0,1,1,0,1,1,  -1, 0, 0, 0, 0, 0,-1, 0, 0},//dUdU
    {0,0,0,1,1,1,1,1,1,   0, 0, 0, 0, 0, 0,-1, 0,-1},//ddUU
    {1,1,0,1,1,0,1,1,0,   0, 0,-1, 0, 0, 0, 0, 0,-1},//UdUd
    {0,0,0,0,0,0,1,0,1,   0, 0, 0,-1,-1,-1,-1,-1,-1},
    {1,0,0,0,0,0,1,0,0,   0,-1,-1, 0,-1,-1, 0,-1,-1},
    {1,0,1,0,0,0,0,0,0,  -1,-1,-1,-1,-1,-1, 0, 0, 0},
    {0,0,1,0,0,0,0,0,1,  -1,-1, 0,-1,-1, 0,-1,-1, 0},
    {0,1,1,1,1,1,1,1,1,  -1, 0, 0, 0, 0, 0,-1, 0,-1},//dUUU
    {1,1,0,1,1,1,1,1,1,   0, 0,-1, 0, 0, 0,-1, 0,-1},//UdUU
    {1,1,1,1,1,1,1,1,0,  -1, 0,-1, 0, 0, 0, 0, 0,-1},//UUUd
    {1,1,1,1,1,1,0,1,1,  -1, 0,-1, 0, 0, 0,-1, 0, 0},//UUdU
    {1,1,1,1,1,1,1,1,1,  -1, 0,-1, 0, 0, 0,-1, 0,-1},//UUUU
    {1,0,1,0,0,0,1,0,1,  -1,-1,-1,-1,-1,-1,-1,-1,-1},//dddd
};

int clkPosit[18];
int clkPegs[4];

- (id)init {
    if(self = [super init]) {
        self.turns = [[NSArray alloc] initWithObjects:@"UR", @"DR", @"DL", @"UL", @"U", @"R", @"D", @"L", @"ALL", nil];
        srand((unsigned)time(0));
    }
    return self;
}

- (NSString *)scramble {
    int x;
    int positCopy[18];
    for(x=0; x<18; x++) clkPosit[x] = positCopy[x] = 0;
    NSMutableString *scr = [NSMutableString string];
    
    for(x=0; x<9; x++) {
        int turn = rand()%12-5;
        for(int j=0; j<18; j++){
            positCopy[j]+=turn*movesClk[x][j];
        }
        bool clockwise = turn >= 0;
        [scr appendFormat:@"%@%d%@ ", [self.turns objectAtIndex:x], ABS(turn), (clockwise?@"+":@"-")];
        //scramble.append( turns[x] + turn + (clockwise?"+":"-") + " ");
    }
    [scr appendString:@"y2 "];
    for(x=0; x<9; x++){
        clkPosit[x] = positCopy[x+9];
        clkPosit[x+9] = positCopy[x];
    }
    for(x=4; x<9; x++) {
        int turn = rand()%12-5;
        for(int j=0; j<18; j++){
            clkPosit[j]+=turn*movesClk[x][j];
        }
        bool clockwise = turn >= 0;
        [scr appendFormat:@"%@%d%@ ", [self.turns objectAtIndex:x], ABS(turn), (clockwise?@"+":@"-")];
        //scramble.append( turns[x] + turn + (clockwise?"+":"-") + " ");
    }
    for(int j=0; j<18; j++){
        clkPosit[j]%=12;
        while( clkPosit[j]<=0 ) clkPosit[j]+=12;
    }
    bool isFirst = true;
    int clkIdx[] = {1, 3, 2, 0};
    for(x=0; x<4; x++) {
        clkPegs[clkIdx[x]] = rand()%2;
        if (clkPegs[clkIdx[x]] == 0) {
            [scr appendFormat:@"%@%@", (isFirst?@"":@" "), [self.turns objectAtIndex:x]];
            //scramble.append((isFirst?"":" ")+turns[x]);
            isFirst = false;
        }
    }
    return scr;
}

- (NSString *)scrambleOld:(bool) concise {
    int seq[14];
    int i,j;
    for(i=0;i<18;i++)clkPosit[i]=0;
    for(i=0; i<14; i++){
        seq[i] = rand()%12-5;
    }
    for( i=0; i<14; i++){
        for( j=0; j<18; j++){
            clkPosit[j]+=seq[i]*movesOld[i][j];
        }
    }
    for( j=0; j<18; j++){
        clkPosit[j]%=12;
        while( clkPosit[j]<=0 ) clkPosit[j]+=12;
    }
    NSMutableString *scr = [NSMutableString string];
    if(concise) {
        for(i=0; i<4; i++)
            [scr appendFormat:@"(%d, %d) / ", seq[i], seq[i+4]];
        for(i=8; i<14; i++)
            [scr appendFormat:@"(%d) / ", seq[i]];
    } else {
        [scr appendFormat:@"%@%d%@%d%@", @"UUdd u=", seq[0], @",d=", seq[4], @" / "];
        [scr appendFormat:@"%@%d%@%d%@", @"dUdU u=", seq[1], @",d=", seq[5], @" / "];
        [scr appendFormat:@"%@%d%@%d%@", @"ddUU u=", seq[2], @",d=", seq[6], @" / "];
        [scr appendFormat:@"%@%d%@%d%@", @"UdUd u=", seq[3], @",d=", seq[7], @" / "];
        [scr appendFormat:@"%@%d%@", @"dUUU u=", seq[8], @" / "];
        [scr appendFormat:@"%@%d%@", @"UdUU u=", seq[9], @" / "];
        [scr appendFormat:@"%@%d%@", @"UUUd u=", seq[10], @" / "];
        [scr appendFormat:@"%@%d%@", @"UUdU u=", seq[11], @" / "];
        [scr appendFormat:@"%@%d%@", @"UUUU u=", seq[12], @" / "];
        [scr appendFormat:@"%@%d%@", @"dddd d=", seq[13], @" / "];
    }
    for(int i=0; i<4; i++){
        clkPegs[i] = rand()%2;
        if(clkPegs[i]==0)[scr appendString:@"U"];
        else [scr appendString:@"d"];
    }
    return scr;
}

- (NSString *)scrambleEpo {
    int seq[14];
    int i,j;
    for(i=0;i<18;i++)clkPosit[i]=0;
    for(i=0; i<14; i++){
        seq[i] = rand()%12-5;
    }
    int epoIdx[] = {12, 8, 1, 5, 11, 0, 4, 10, 3, 7, 9, 2, 6, 13};
    for( i=0; i<14; i++){
        for( j=0; j<18; j++){
            clkPosit[j]+=seq[i]*movesOld[epoIdx[i]][j];
        }
    }
    for( j=0; j<18; j++){
        clkPosit[j]%=12;
        while( clkPosit[j]<=0 ) clkPosit[j]+=12;
    }
    NSMutableString *scr = [NSMutableString string];
    [scr appendFormat:@"%@%d%@", @"UUUU u=", seq[0], @" / "];
    [scr appendFormat:@"%@%d%@", @"dUUU u=", seq[1], @" / "];
    [scr appendFormat:@"%@%d%@%d%@", @"dUdU u=", seq[2], @",d=", seq[3], @" / "];
    [scr appendFormat:@"%@%d%@", @"UUdU u=", seq[4], @" / "];
    [scr appendFormat:@"%@%d%@%d%@", @"UUdd u=", seq[0], @",d=", seq[4], @" / "];
    [scr appendFormat:@"%@%d%@", @"UUUd u=", seq[0], @" / "];    
    [scr appendFormat:@"%@%d%@%d%@", @"UdUd u=", seq[3], @",d=", seq[7], @" / "];
    [scr appendFormat:@"%@%d%@", @"UdUU u=", seq[9], @" / "];
    [scr appendFormat:@"%@%d%@%d%@", @"ddUU u=", seq[2], @",d=", seq[6], @" / "];
    [scr appendFormat:@"%@%d%@", @"dddd d=", seq[13], @" / "];
    for(int i=0; i<4; i++){
        clkPegs[i] = rand()%2;
        if(clkPegs[i]==0)[scr appendString:@"U"];
        else [scr appendString:@"d"];
    }
    return scr;
}

+ (NSMutableArray *)image {
    NSMutableArray *img = [[NSMutableArray alloc] init];
    for(int i=0; i<18; i++)
        [img addObject:@(clkPosit[i])];
    return img;
}

+ (NSMutableArray *)pegs {
    NSMutableArray *p = [[NSMutableArray alloc] init];
    for(int i=0; i<4; i++)
        [p addObject:@(clkPegs[i])];
    return p;
}
@end
