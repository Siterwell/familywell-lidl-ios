#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocketAutoSwitchItem "" 
class PowerSocketAutoSwitchItem : public JObject
{
public:
	JIntObj		TimeStart;
	JIntObj		TimeStop;
	JIntObj		DayStart;
	JIntObj		DayStop;
	JBoolObj		Enable;

public:
    PowerSocketAutoSwitchItem(JObject *pParent = NULL, const char *szName = JK_PowerSocketAutoSwitchItem):
    JObject(pParent,szName),
	TimeStart(this, "TimeStart"),
	TimeStop(this, "TimeStop"),
	DayStart(this, "DayStart"),
	DayStop(this, "DayStop"),
	Enable(this, "Enable"){
	};

    ~PowerSocketAutoSwitchItem(void){};
};
