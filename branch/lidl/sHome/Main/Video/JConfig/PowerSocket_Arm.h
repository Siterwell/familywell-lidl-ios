#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocket_Arm "PowerSocket.Arm" 
class PowerSocket_Arm : public JObject
{
public:
	JIntObj		Guard;

public:
    PowerSocket_Arm(JObject *pParent = NULL, const char *szName = JK_PowerSocket_Arm):
    JObject(pParent,szName),
	Guard(this, "Guard"){
	};

    ~PowerSocket_Arm(void){};
};
