#pragma once
#import "FunSDK/JObject.h"
#include "ExtraFormat.h"
#include "MainFormat.h"

#define JK_Simplify_Encode "Simplify.Encode" 
class Simplify_Encode : public JObject
{
public:
	ExtraFormat		mExtraFormat;
	MainFormat		mMainFormat;

public:
	Simplify_Encode(JObject *pParent = NULL, const char *szName = JK_Simplify_Encode):
	JObject(pParent,szName),
	mExtraFormat(this, "ExtraFormat"),
	mMainFormat(this, "MainFormat"){
	};

	~Simplify_Encode(void){};
};