#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_OPEN_PATTERNS_PATTERN02_H
#define D_OPEN_PATTERNS_PATTERN02_H

class OpenPattern02 {
public:
    OpenPattern02(void);
    ~OpenPattern02(void);

    bool IsPattern02(MovingAverage &s, MovingAverage &l);
};

#endif

#ifndef D_OPEN_PATTERNS_PATTERN02_B
#define D_OPEN_PATTERNS_PATTERN02_B

void OpenPattern02::OpenPattern02() {}

void OpenPattern02::~OpenPattern02() {}

bool OpenPattern02::IsPattern02(MovingAverage &s, MovingAverage &l) {
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
