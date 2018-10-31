#pragma once
#import "FunSDK/JObject.h"
#include "Video.h"

#define JK_ExtraFormat "ExtraFormat" 
class ExtraFormat : public JObject
{
public:
	JBoolObj		AudioEnable;
	Video		mVideo;
	JBoolObj		VideoEnable;

public:
	ExtraFormat(JObject *pParent = NULL, const char *szName = JK_ExtraFormat):
	JObject(pParent,szName),
	AudioEnable(this, "AudioEnable"),
	mVideo(this, "Video"),
	VideoEnable(this, "VideoEnable"){
	};

	~ExtraFormat(void){};
};