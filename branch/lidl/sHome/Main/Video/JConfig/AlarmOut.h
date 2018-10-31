#pragma once
#import <FunSDK/Jobject.h>

#define JK_AlarmOut "AlarmOut" 
class AlarmOut : public JObject
{
public:
	JStrObj		AlarmOutStatus;
	JStrObj		AlarmOutType;

public:
    AlarmOut(JObject *pParent = NULL, const char *szName = JK_AlarmOut):
    JObject(pParent,szName),
	AlarmOutStatus(this, "AlarmOutStatus"),
	AlarmOutType(this, "AlarmOutType"){
	};

    ~AlarmOut(void){};
};