#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocketAutoLightItem "" 
class PowerSocketAutoLightItem : public JObject
{
public:
	JIntObj		DayStop;
	JBoolObj		Enable;
	JIntObj		TimeStop;
	JIntObj		TimeStart;
	JIntObj		DayStart;

public:
    PowerSocketAutoLightItem(JObject *pParent = NULL, const char *szName = JK_PowerSocketAutoLightItem):
    JObject(pParent,szName),
	DayStop(this, "DayStop"),
	Enable(this, "Enable"),
	TimeStop(this, "TimeStop"),
	TimeStart(this, "TimeStart"),
	DayStart(this, "DayStart"){
	};

    ~PowerSocketAutoLightItem(void){};
};
