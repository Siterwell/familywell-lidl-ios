#pragma once
#import "FunSDK/JObject.h"
#include "UserInfo.h"
#define JK_Users "Users" 
class UsersInfo : public JObject
{
public:
    JObjArray<UserInfos>		userList;
	public:
    UsersInfo(JObject *pParent = NULL, const char *szName = JK_Users):
    JObject(pParent,szName),
	userList(this, "Users"){
	};

    ~UsersInfo(void){};
};