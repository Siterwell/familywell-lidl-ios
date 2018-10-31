#pragma once
#include "FunSDK/JObject.h"

#define JK_ExtRecord "ExtRecord" 
class ExtRecord : public JObject
{
public:
	JObjArray<JObject>		Mask;
	JIntObj		PacketLength;
	JIntObj		PreRecord;
	JStrObj		RecordMode;
	JBoolObj		Redundancy;
	JObjArray<JObject>		TimeSection;

public:
    ExtRecord(JObject *pParent = NULL, const char *szName = JK_ExtRecord):
    JObject(pParent,szName),
	Mask(this, "Mask"),
	PacketLength(this, "PacketLength"),
	PreRecord(this, "PreRecord"),
	RecordMode(this, "RecordMode"),
	Redundancy(this, "Redundancy"),
	TimeSection(this, "TimeSection"){
	};

    ~ExtRecord(void){};
};
