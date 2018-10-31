#pragma once
#import <FunSDK/JObject.h>

#define JK_LightOnSec "LightOnSec" 
class LightOnSec : public JObject
{
public:
	JIntObj		SMinute;
	JIntObj		EHour;
	JIntObj		EMinute;
	JIntObj		Enable;
	JIntObj		SHour;

public:
    LightOnSec(JObject *pParent = NULL, const char *szName = JK_LightOnSec):
    JObject(pParent,szName),
	SMinute(this, "SMinute"),
	EHour(this, "EHour"),
	EMinute(this, "EMinute"),
	Enable(this, "Enable"),
	SHour(this, "SHour"){
	};

    ~LightOnSec(void){};
};
