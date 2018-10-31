#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocket_BanLed "PowerSocket.BanLed" 
class PowerSocket_BanLed : public JObject
{
public:
	JIntObj		Banstatus;

public:
    PowerSocket_BanLed(JObject *pParent = NULL, const char *szName = JK_PowerSocket_BanLed):
    JObject(pParent,szName),
	Banstatus(this, "Banstatus"){
	};

    ~PowerSocket_BanLed(void){};
};
