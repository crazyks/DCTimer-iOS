//
//  EOLine.m
//  DCTimer solvers
//
//  Created by MeigenChou on 13-4-5.
//  Copyright (c) 2013年 MeigenChou. All rights reserved.
//

#import "EOLine.h"
#import "DCTUtils.h"
#import "Util.h"

@interface EOLine ()
@property (nonatomic, strong) NSArray *faceStr;
@property (nonatomic, strong) NSArray *moveIdx;
@property (nonatomic, strong) NSArray *rotIdx;
@property (nonatomic, strong) NSArray *turn;
@property (nonatomic, strong) NSArray *suff;
@property (nonatomic, strong) NSMutableString *sol;
@end

@implementation EOLine
@synthesize faceStr, moveIdx, rotIdx, turn, suff, sol;


-(id) init {
    if(self = [super init]) {
        faceStr = [[NSArray alloc] initWithObjects:@"DF DB", @"DL DR", @"UF UB", @"UL UR",
                   @"LF LB", @"LU LD", @"RF RB", @"RU RD", @"FU FD", @"FL FR", @"BU BD", @"BL BR", nil];
        self.moveIdx = [[NSArray alloc] initWithObjects:@"UDLRFB", @"UDFBRL", @"DURLFB", @"DUFBLR",
                   @"RLUDFB", @"RLFBDU", @"LRDUFB", @"LRFBUD", @"BFLRUD", @"BFUDRL", @"FBLRDU", @"FBDURL", nil];
        self.rotIdx = [[NSArray alloc] initWithObjects:@"", @" y", @" z2", @" z2 y",
                  @" z'", @" z' y", @" z", @" z y", @" x'", @" x' y", @" x", @" x y", nil];
        self.turn = [[NSArray alloc] initWithObjects:@"U", @"D", @"L", @"R", @"F", @"B", nil];
        self.suff = [[NSArray alloc] initWithObjects:@"", @"2", @"'", nil];
        [self initeo];
    }
    return self;
}

-(int) getEpm:(int)eci epi:(int)epi k:(int)k {
    bool comb[12];
    [Util idxToComb:comb i:eci k:2 l:12];;
    int perm[2];
    [Util idxToPerm:perm i:epi l:2];
    int selEdges[] = {8, 10};
    int next = 0;
    int ep[] = { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 };
    for (int i = 0; i < 12; i++)
        if (comb[i]) ep[i] = selEdges[perm[next++]];
    switch(k){
		case 0: [Util cir:ep a:4 b:7 c:6 d:5]; break;
		case 1: [Util cir:ep a:8 b:9 c:10 d:11]; break;
		case 2: [Util cir:ep a:7 b:3 c:11 d:2]; break;
		case 3: [Util cir:ep a:5 b:1 c:9 d:0]; break;
		case 4: [Util cir:ep a:6 b:2 c:10 d:1]; break;
		case 5: [Util cir:ep a:4 b:0 c:8 d:3]; break;
    }
    int edgesMap[] = {0, 1, 2, 3};
    bool ec[12];
    for (int i = 0; i < 12; i++)
        ec[i] = ep[i] > 0;
    eci = [Util combToIdx:ec k:2 l:12];
    int edgesPerm[] = {-1, -1};
    next = 0;
    for (int i = 0; i < 12; i++)
        if (ec[i]) {
            if(ep[i] > -1)
                edgesPerm[next++] 
                = edgesMap
                [ep[i]-8];
        }
    epi = [Util permToIdx:edgesPerm l:2];
    return eci * 2 + epi;
}

-(void) initeo {
    int arr[12];
    for(int i=0; i<2048; i++){
        for(int j=0; j<6; j++) {
            [Util idxToZsOri:arr i:i n:2 l:12];
            switch(j){
				case 0: [Util cir:arr a:4 b:7 c:6 d:5]; break;
				case 1: [Util cir:arr a:8 b:9 c:10 d:11]; break;
				case 2: [Util cir:arr a:7 b:3 c:11 d:2]; break;
				case 3: [Util cir:arr a:5 b:1 c:9 d:0]; break;
				case 4: [Util cir:arr a:6 b:2 c:10 d:1];
					arr[6]^=1; arr[2]^=1; arr[10]^=1; arr[1]^=1; break;
				case 5: [Util cir:arr a:4 b:0 c:8 d:3];
					arr[4]^=1; arr[0]^=1; arr[8]^=1; arr[3]^=1; break;
            }
            eom[i][j] = [Util zsOriToIdx:arr n:2 l:12];
        }
    }
    for(int i=0; i<66; i++){
        for(int j=0; j<2; j++){
            for(int k=0; k<6; k++){
                epm[i*2+j][k] = [self getEpm:i epi:j k:k];
            }
        }
        
    }
    for(int i=1; i<2048; i++) eod[i] = -1;
    eod[0] = 0;
    int d = 0;
    //int n = 1;
    for(d=0; d<7; d++){
        //n=0;
        for(int i=0; i<2048; i++)
            if(eod[i] == d)
                for(int j=0; j<6; j++)
                    for(int y=i,m=0; m<3; m++){
                        y=eom[y][j];
                        if(eod[y]==-1){
                            eod[y]=d+1;
                            //n++;
                        }
                    }
        //System.out.println(d+" "+n);
    }
    
    for(int i=0; i<132; i++) epd[i] = -1;
    epd[106] = 0;
    for(d=0; d<4; d++){
        //n=0;
        for(int i=0; i<132; i++)
            if(epd[i] == d)
                for(int j=0; j<6; j++){
                    int y=i;
                    for(int m=0; m<3; m++){
                        y=epm[y][j];
                        if(epd[y]==-1){
                            epd[y]=d+1;
                            //n++;
                        }
                    }
                }
        //System.out.println(d+" "+n);
    }
}

-(bool) search:(int)eo ep:(int)ep d:(int)depth l:(int)l {
    if(depth==0) return eo==0 && ep==106;
    if(eod[eo]>depth || epd[ep]>depth) return false;
    for (int i = 0; i < 6; i++)
        if (i != l) {
            int w = eo, y = ep;
            for (int j = 0; j < 3; j++) {
                y = epm[y][i];
                w = eom[w][i];
                if ([self search:w ep:y d:depth-1 l:i]) {
                    [self.sol insertString:[NSString stringWithFormat:@" %@%@", [self.turn objectAtIndex:i], [self.suff objectAtIndex:j]] atIndex:0];
                    //sb.insert(0, " " + turn[i] + suff[j]);
                    return true;
                }
            }
        }
    return false;
}

-(NSString *) solve:(NSString *)scr side:(int)side {
    NSArray *s = [scr componentsSeparatedByString:@" "];
    int ep = 106, eo = 0;
    for(int d=0; d<s.count; d++) {
        if([[s objectAtIndex:d] length]!=0) {
            char i = [[s objectAtIndex:d] characterAtIndex:0];
            int o = [DCTUtils indexOf:[self.moveIdx objectAtIndex:side] c:i];
            ep = epm[ep][o]; eo = eom[eo][o];
            if([[s objectAtIndex:d] length]>1) {
                i = [[s objectAtIndex:d] characterAtIndex:1];
                if(i == '2') {
                    eo = eom[eo][o]; ep = epm[ep][o];
                } else {
                    eo = eom[eom[eo][o]][o]; ep = epm[epm[ep][o]][o];
                }
            }
        }
    }
    self.sol = [NSMutableString string];
    for (int d = 0; ![self search:eo ep:ep d:d l:side]; d++);
    return [NSString stringWithFormat:@"%@:%@%@", [faceStr objectAtIndex:side], [self.rotIdx objectAtIndex:side], self.sol];
}

-(NSString *) solveEOLine:(NSString *)scr side:(int)side {
    return [NSString stringWithFormat:@"\n%@\n%@", [self solve:scr side:side*2], [self solve:scr side:side*2+1]];
}
@end
