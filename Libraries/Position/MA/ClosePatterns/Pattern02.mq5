#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_CLOSE_PATTERNS_PATTERN02_H
#define D_CLOSE_PATTERNS_PATTERN02_H

#ifndef IG_MOVING_AVERAGE
#define IG_MOVING_AVERAGE
#include "..\..\..\MA\MovingAverage.mq5"
#endif

class ClosePattern02 {
public:
    ClosePattern02(void);
    ~ClosePattern02(void);

    bool IsPattern02(MovingAverage &s, MovingAverage &l);
};

#endif

#ifndef D_CLOSE_PATTERNS_PATTERN02_B
#define D_CLOSE_PATTERNS_PATTERN02_B

void ClosePattern02::ClosePattern02() {}

void ClosePattern02::~ClosePattern02() {}

bool ClosePattern02::IsPattern02(MovingAverage &s, MovingAverage &l) {
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
