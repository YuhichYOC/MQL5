#property library
#property copyright "Copyright 2022, YuhichYOC"

class DateTimeUtil {
public:
    DateTimeUtil(void);
    ~DateTimeUtil(void);

    MqlDateTime GetCurrent(void);
    ENUM_DAY_OF_WEEK IntToDow(int dow);
    MqlDateTime ConvertDateTime(datetime);
    bool AreEqual(MqlDateTime &arg1, MqlDateTime &arg2);
    bool AreEqualMinute(MqlDateTime &arg1, MqlDateTime &arg2);
    bool AreEqualHour(MqlDateTime &arg1, MqlDateTime &arg2);
    bool LessThanMinute(MqlDateTime &arg1, MqlDateTime &arg2, int min);
};

void DateTimeUtil::DateTimeUtil() {}

void DateTimeUtil::~DateTimeUtil() {}

MqlDateTime DateTimeUtil::GetCurrent() {
    MqlDateTime nowMql;
    TimeToStruct(TimeCurrent(), nowMql);
    return nowMql;
}

ENUM_DAY_OF_WEEK DateTimeUtil::IntToDow(int dow) {
    switch (dow) {
        case 6:
            return SATURDAY;
        case 5:
            return FRIDAY;
        case 4:
            return THURSDAY;
        case 3:
            return WEDNESDAY;
        case 2:
            return TUESDAY;
        case 1:
            return MONDAY;
        default:
            return SUNDAY;
    }
}

MqlDateTime DateTimeUtil::ConvertDateTime(datetime value) {
    MqlDateTime dateMql;
    TimeToStruct(value, dateMql);
    return dateMql;
}

bool DateTimeUtil::AreEqual(MqlDateTime &arg1, MqlDateTime &arg2) {
    return arg1.year == arg2.year && arg1.mon == arg2.mon && arg1.day == arg2.day
        && arg1.hour == arg2.hour && arg1.min == arg2.min && arg1.sec == arg2.sec;
}

bool DateTimeUtil::AreEqualMinute(MqlDateTime &arg1, MqlDateTime &arg2) {
    return arg1.year == arg2.year && arg1.mon == arg2.mon && arg1.day == arg2.day
        && arg1.hour == arg2.hour && arg1.min == arg2.min;
}

bool DateTimeUtil::AreEqualHour(MqlDateTime &arg1, MqlDateTime &arg2) {
    return arg1.year == arg2.year && arg1.mon == arg2.mon && arg1.day == arg2.day
        && arg1.hour == arg2.hour;
}

bool DateTimeUtil::LessThanMinute(MqlDateTime &arg1, MqlDateTime &arg2, int min) {
    string arg1str = IntegerToString(arg1.year) + IntegerToString(arg1.mon, 2, '0') + IntegerToString(arg1.day, 2, '0')
        + IntegerToString(arg1.hour, 2, '0') + IntegerToString(arg1.min + min, 2, '0');
    string arg2str = IntegerToString(arg2.year) + IntegerToString(arg2.mon, 2, '0') + IntegerToString(arg2.day, 2, '0')
        + IntegerToString(arg2.hour, 2, '0') + IntegerToString(arg2.min, 2, '0');
    return arg1str >= arg2str;
}

class OpenTimeChecker {
public:
    OpenTimeChecker(void);
    ~OpenTimeChecker(void);

    void Initialize(string symbol);
    bool IsOpen(void);

private:
    string m_symbol;
};

void OpenTimeChecker::OpenTimeChecker() {}

void OpenTimeChecker::~OpenTimeChecker() {}

void OpenTimeChecker::Initialize(string symbol) {
    m_symbol = symbol;
}

bool OpenTimeChecker::IsOpen() {
    DateTimeUtil du;
    MqlDateTime nowMql = du.GetCurrent();
    datetime from, to;
    SymbolInfoSessionTrade(m_symbol, du.IntToDow(nowMql.day_of_week), 0, from, to);
    MqlDateTime fromMql = du.ConvertDateTime(from);
    MqlDateTime toMql = du.ConvertDateTime(to);
    int fromInt = fromMql.hour * 10000 + fromMql.min * 100 + fromMql.sec;
    int nowInt = nowMql.hour * 10000 + nowMql.min * 100 + nowMql.sec;
    int toInt = toMql.hour * 10000 + toMql.min * 100 + toMql.sec;
    return fromInt <= nowInt && nowInt <= toInt;
}
