#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocketAutoUsbItem "PowerSocketAutoUsbItem" 
class PowerSocketAutoUsbItem : public JObject
{
public:
	JIntObj		DayStop;
	JBoolObj		Enable;
	JIntObj		TimeStop;
	JIntObj		TimeStart;
	JIntObj		DayStart;

public:
    PowerSocketAutoUsbItem(JObject *pParent = NULL, const char *szName = JK_PowerSocketAutoUsbItem):
    JObject(pParent,szName),
	DayStop(this, "DayStop"),
	Enable(this, "Enable"),
	TimeStop(this, "TimeStop"),
	TimeStart(this, "TimeStart"),
	DayStart(this, "DayStart"){
	};

    ~PowerSocketAutoUsbItem(void){};
};
