#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_CLOSE_PATTERNS_PATTERN01_H
#define D_CLOSE_PATTERNS_PATTERN01_H

#ifndef IG_MOVING_AVERAGE
#define IG_MOVING_AVERAGE
#include "..\..\..\MA\MovingAverage.mq5"
#endif

class ClosePattern01 {
public:
    ClosePattern01(void);
    ~ClosePattern01(void);

    bool IsPattern01(MovingAverage &s, MovingAverage &l);
};

#endif

#ifndef D_CLOSE_PATTERNS_PATTERN01_B
#define D_CLOSE_PATTERNS_PATTERN01_B

void ClosePattern01::ClosePattern01() {}

void ClosePattern01::~ClosePattern01() {}

bool ClosePattern01::IsPattern01(MovingAverage &s, MovingAverage &l) {
    int sSize = s.GetSize();
    int lSize = l.GetSize();
    if (
        s.ValueAt(sSize - 2) > l.ValueAt(lSize - 2)
        && s.ValueAt(sSize - 1) < l.ValueAt(lSize - 1)
    ) {
        // Dead Cross
        return true;
    }
    return false;
}

#endif
