#pragma once
#import "FunSDK/JObject.h"
#include "DSTEnd.h"
#include "DSTStart.h"

#define JK_General_Location "General.Location" 
class General_Location : public JObject
{
public:
	DSTEnd		mDSTEnd;
	JStrObj		DSTRule;
	DSTStart		mDSTStart;
	JStrObj		DateFormat;
	JStrObj		DateSeparator;
	JStrObj		Language;
	JStrObj		TimeFormat;
	JStrObj		VideoFormat;
	JIntObj		WorkDay;

public:
	General_Location(JObject *pParent = NULL, const char *szName = JK_General_Location):
	JObject(pParent,szName),
	mDSTEnd(this, "DSTEnd"),
	DSTRule(this, "DSTRule"),
	mDSTStart(this, "DSTStart"),
	DateFormat(this, "DateFormat"),
	DateSeparator(this, "DateSeparator"),
	Language(this, "Language"),
	TimeFormat(this, "TimeFormat"),
	VideoFormat(this, "VideoFormat"),
	WorkDay(this, "WorkDay"){
	};

	~General_Location(void){};
};