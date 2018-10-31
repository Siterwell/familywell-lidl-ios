#pragma once
#import <FunSDK/Jobject.h>
#define JK_POINT "POINT" 
class POINT : public JObject
{
public:
	JIntObj		bottom;
	JIntObj		left;
	JIntObj		right;
	JIntObj		top;

public:
    POINT(JObject *pParent = NULL, const char *szName = JK_POINT):
    JObject(pParent,szName),
	bottom(this, "bottom"),
	left(this, "left"),
	right(this, "right"),
	top(this, "top"){
	};

    ~POINT(void){};
};