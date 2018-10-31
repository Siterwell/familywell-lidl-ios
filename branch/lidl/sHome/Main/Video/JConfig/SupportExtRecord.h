#pragma once
#include "FunSDK/JObject.h"

#define JK_SupportExtRecord "SupportExtRecord" 
class SupportExtRecord : public JObject
{
public:
	JIntHex		AbilityPram;

public:
	SupportExtRecord(JObject *pParent = NULL, const char *szName = JK_SupportExtRecord):
	JObject(pParent,szName),
	AbilityPram(this, "AbilityPram"){
	};

	~SupportExtRecord(void){};
};
