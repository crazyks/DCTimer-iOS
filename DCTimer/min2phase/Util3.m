//
//  Util3.m
//  DCTimer
//
//  Created by MeigenChou on 16/2/4.
//
//

#import "Util3.h"
#import "CubieCube.h"
#import "Util.h"

@implementation Util3
//Moves
const int Ux1 = 0;
const int Ux2 = 1;
const int Ux3 = 2;
const int Rx1 = 3;
const int Rx2 = 4;
const int Rx3 = 5;
const int Fx1 = 6;
const int Fx2 = 7;
const int Fx3 = 8;
const int Dx1 = 9;
const int Dx2 = 10;
const int Dx3 = 11;
const int Lx1 = 12;
const int Lx2 = 13;
const int Lx3 = 14;
const int Bx1 = 15;
const int Bx2 = 16;
const int Bx3 = 17;

//Facelets
const int U1 = 0;
const int U2 = 1;
const int U3 = 2;
const int U4 = 3;
const int U5 = 4;
const int U6 = 5;
const int U7 = 6;
const int U8 = 7;
const int U9 = 8;
const int R1 = 9;
const int R2 = 10;
const int R3 = 11;
const int R4 = 12;
const int R5 = 13;
const int R6 = 14;
const int R7 = 15;
const int R8 = 16;
const int R9 = 17;
const int F1 = 18;
const int F2 = 19;
const int F3 = 20;
const int F4 = 21;
const int F5 = 22;
const int F6 = 23;
const int F7 = 24;
const int F8 = 25;
const int F9 = 26;
const int D1 = 27;
const int D2 = 28;
const int D3 = 29;
const int D4 = 30;
const int D5 = 31;
const int D6 = 32;
const int D7 = 33;
const int D8 = 34;
const int D9 = 35;
const int L1 = 36;
const int L2 = 37;
const int L3 = 38;
const int L4 = 39;
const int L5 = 40;
const int L6 = 41;
const int L7 = 42;
const int L8 = 43;
const int L9 = 44;
const int B1 = 45;
const int B2 = 46;
const int B3 = 47;
const int B4 = 48;
const int B5 = 49;
const int B6 = 50;
const int B7 = 51;
const int B8 = 52;
const int B9 = 53;

int cornerFacelet[8][3] = { { U9, R1, F3 }, { U7, F1, L3 }, { U1, L1, B3 }, { U3, B1, R3 }, { D3, F9, R7 }, { D1, L9, F7 }, { D7, B9, L7 }, { D9, R9, B7 } };
int edgeFacelet[12][2] = { { U6, R2 }, { U8, F2 }, { U4, L2 }, { U2, B2 }, { D6, R8 }, { D2, F8 }, { D4, L8 }, { D8, B8 }, { F6, R4 }, { F4, L6 }, { B6, L4 }, { B4, R6 } };
bool ckmov2[11][10];
int std2ud[18];
int ud2std[] = {Ux1, Ux2, Ux3, Rx2, Fx2, Dx1, Dx2, Dx3, Lx2, Bx2};
int permMult[24][24];

+ (void)toCubieCube:(int [])f cc:(CubieCube *)ccRet {
    int ori;
    for (int i = 0; i < 8; i++)
        ccRet->cp[i] = 0;// invalidate corners
    for (int i = 0; i < 12; i++)
        ccRet->ep[i] = 0;// and edges
    int col1, col2;
    for (int i=0; i<8; i++) {
        // get the colors of the cubie at corner i, starting with U/D
        for (ori = 0; ori < 3; ori++)
            if (f[cornerFacelet[i][ori]] == 0 || f[cornerFacelet[i][ori]] == 3)
                break;
        col1 = f[cornerFacelet[i][(ori + 1) % 3]];
        col2 = f[cornerFacelet[i][(ori + 2) % 3]];
        
        for (int j=0; j<8; j++) {
            if (col1 == cornerFacelet[j][1]/9 && col2 == cornerFacelet[j][2]/9) {
                // in cornerposition i we have cornercubie j
                ccRet->cp[i] = j;
                ccRet->co[i] = (int) (ori % 3);
                break;
            }
        }
    }
    for (int i=0; i<12; i++) {
        for (int j=0; j<12; j++) {
            if (f[edgeFacelet[i][0]] == edgeFacelet[j][0]/9
                && f[edgeFacelet[i][1]] == edgeFacelet[j][1]/9) {
                ccRet->ep[i] = j;
                ccRet->eo[i] = 0;
                break;
            }
            if (f[edgeFacelet[i][0]] == edgeFacelet[j][1]/9
                && f[edgeFacelet[i][1]] == edgeFacelet[j][0]/9) {
                ccRet->ep[i] = j;
                ccRet->eo[i] = 1;
                break;
            }
        }
    }
}

+ (NSString *)toFaceCube:(CubieCube *)cc {
    char f[54];
    char ts[] = {'U', 'R', 'F', 'D', 'L', 'B'};
    for (int i=0; i<54; i++) {
        f[i] = ts[i/9];
    }
    for (int c=0; c<8; c++) {
        int j = cc->cp[c];// cornercubie with index j is at
        // cornerposition with index c
        int ori = cc->co[c];// Orientation of this cubie
        for (int n=0; n<3; n++)
            f[cornerFacelet[c][(n + ori) % 3]] = ts[cornerFacelet[j][n]/9];
    }
    for (int e=0; e<12; e++) {
        int j = cc->ep[e];// edgecubie with index j is at edgeposition
        // with index e
        int ori = cc->eo[e];// Orientation of this cubie
        for (int n=0; n<2; n++)
            f[edgeFacelet[e][(n + ori) % 2]] = ts[edgeFacelet[j][n]/9];
    }
    NSString *facelets = [[NSString alloc] initWithCString:(char*)f encoding:NSASCIIStringEncoding];
    NSLog(@"%@", facelets);
    return facelets;
}

+ (int)binarySearch:(unsigned short [])arr l:(int)length k:(int)key {
    if (key <= arr[length-1]) {
        int l = 0;
        int r = length-1;
        while (l <= r) {
            int mid = (l+r)>>1;
            int val = arr[mid];
            if (key > val) {
                l = mid + 1;
            } else if (key < val) {
                r = mid - 1;
            } else {
                return mid;
            }
        }
    }
    return 0xffff;
}

+ (void)setupUtil {
    for (int i=0; i<10; i++) {
        std2ud[ud2std[i]] = i;
    }
    for (int i=0; i<10; i++) {
        for (int j=0; j<10; j++) {
            int ix = ud2std[i];
            int jx = ud2std[j];
            ckmov2[i][j] = (ix/3 == jx/3) || ((ix/3%3 == jx/3%3) && (ix>=jx));
        }
        ckmov2[10][i] = false;
    }
    [Util initCnk];
    int arr1[4];
    int arr2[4];
    int arr3[4];
    for (int i=0; i<24; i++) {
        for (int j=0; j<24; j++) {
            [Util setNPerm:arr1 i:i n:4];
            [Util setNPerm:arr2 i:j n:4];
            for (int k=0; k<4; k++) {
                arr3[k] = arr1[arr2[k]];
            }
            permMult[i][j] = [Util getNPerm:arr3 n:4];
        }
    }
}

@end
