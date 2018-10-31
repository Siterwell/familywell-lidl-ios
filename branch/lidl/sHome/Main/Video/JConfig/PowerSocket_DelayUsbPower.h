#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocket_DelayUsbPower "PowerSocket.DelayUsbPower" 
class PowerSocket_DelayUsbPower : public JObject
{
public:
	JIntObj		PeriodOn;
	JIntObj		PeriodOff;
	JIntObj		Mode;
	JIntObj		Enable;

public:
    PowerSocket_DelayUsbPower(JObject *pParent = NULL, const char *szName = JK_PowerSocket_DelayUsbPower):
    JObject(pParent,szName),
	PeriodOn(this, "PeriodOn"),
	PeriodOff(this, "PeriodOff"),
	Mode(this, "Mode"),
	Enable(this, "Enable"){
	};

    ~PowerSocket_DelayUsbPower(void){};
};
