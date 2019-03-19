//
//  PatternUtil.h
//  sHome
//
//  Created by Ryan Hsueh on 2018/11/28.
//  Copyright © 2018 shaop. All rights reserved.
//

#ifndef PatternUtil_h
#define PatternUtil_h

#define EmailPattern @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define PasswordPattern @"(?=^.{10,}$)((?=.*\\d)(?=.*\\W+))(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$"

#endif /* PatternUtil_h */
