#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_OPEN_PATTERNS_PATTERN01_H
#define D_OPEN_PATTERNS_PATTERN01_H

#ifndef IG_MOVING_AVERAGE
#define IG_MOVING_AVERAGE
#include "..\..\..\MA\MovingAverage.mq5"
#endif

class OpenPattern01 {
public:
    OpenPattern01(void);
    ~OpenPattern01(void);

    bool IsPattern01(MovingAverage &s, MovingAverage &l);
};

#endif

#ifndef D_OPEN_PATTERNS_PATTERN01_B
#define D_OPEN_PATTERNS_PATTERN01_B

void OpenPattern01::OpenPattern01() {}

void OpenPattern01::~OpenPattern01() {}

bool OpenPattern01::IsPattern01(MovingAverage &s, MovingAverage &l) {
    int sSize = s.GetSize();
    int lSize = l.GetSize();
    if (
        s.ValueAt(sSize - 2) < l.ValueAt(lSize - 2)
        && s.ValueAt(sSize - 1) > l.ValueAt(lSize - 1)
    ) {
        // Golden Cross
        return true;
    }
    return false;
}

#endif
