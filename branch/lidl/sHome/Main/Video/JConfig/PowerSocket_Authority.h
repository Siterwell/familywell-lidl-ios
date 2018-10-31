#pragma once
#include "FunSDK/JObject.h"

#define JK_PowerSocket_Authority "PowerSocket.Authority" 
class PowerSocket_Authority : public JObject
{
public:
	JIntObj		Level;
	JIntObj		Ability;

public:
    PowerSocket_Authority(JObject *pParent = NULL, const char *szName = JK_PowerSocket_Authority):
    JObject(pParent,szName),
	Level(this, "Level"),
	Ability(this, "Ability"){
	};

    ~PowerSocket_Authority(void){};
};
