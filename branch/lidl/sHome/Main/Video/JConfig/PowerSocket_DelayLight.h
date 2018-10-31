#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocket_DelayLight "PowerSocket.DelayLight" 
class PowerSocket_DelayLight : public JObject
{
public:
	JIntObj		PeriodOn;
	JIntObj		PeriodOff;
	JIntObj		Mode;
	JIntObj		Enable;

public:
    PowerSocket_DelayLight(JObject *pParent = NULL, const char *szName = JK_PowerSocket_DelayLight):
    JObject(pParent,szName),
	PeriodOn(this, "PeriodOn"),
	PeriodOff(this, "PeriodOff"),
	Mode(this, "Mode"),
	Enable(this, "Enable"){
	};

    ~PowerSocket_DelayLight(void){};
};
