#pragma once
#include "JObject.h"

#define JK_FbExtraStateCtrl "FbExtraStateCtrl" 
class FbExtraStateCtrl : public JObject
{
public:
	JIntObj		ison;

public:
    FbExtraStateCtrl(JObject *pParent = NULL, const char *szName = JK_FbExtraStateCtrl):
    JObject(pParent,szName),
	ison(this, "ison"){
	};

    ~FbExtraStateCtrl(void){};
};