import datetime

def datestdtojd (stddate):
    fmt='%Y-%m-%d %H:%M'
    sdtdate = datetime.datetime.strptime(stddate, fmt)
    sdtdate = sdtdate.timetuple()
    jdate = sdtdate.tm_yday
    return(jdate)

print(datestdtojd('1975-06-20 23:00'))
