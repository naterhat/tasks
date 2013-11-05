//
//  Constants.h
//  tasks
//
//  Created by Nate Ramirez on 11/5/13.
//  Copyright (c) 2013 natewire. All rights reserved.
//

#ifndef tasks_Constants_h
#define tasks_Constants_h

// Constant Values
#define kFileNameDatabase @"database.sqlite"
#define kFileNameModel @"database.momd"

#define kCellIdentifier @"cell"

// Math Functions for CGPoint & CGSize
#define CGPointAdd(pA, pB) CGPointMake(pA.x+pB.x, pA.y+pB.y);
#define CGPointScale(p, scale) CGPointMake(p.x*scale, p.y*scale);
#define CGSizeAdd(sA, sB) CGSizeMake(sA.width+sB.width, sA.height+sB.height);
#define CGSizeScale(s, scale) CGSizeMake(s.width*scale, s.height*scale);
#define CGSizeGetMin(s) (s.width<s.height?s.width:s.height)


#endif
