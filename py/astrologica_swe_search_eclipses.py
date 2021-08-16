import swisseph as swe
import jdutil
import datetime
import sys

def decdeg2dms(dd):
   is_positive = dd >= 0
   dd = abs(dd)
   minutes,seconds = divmod(dd*3600,60)
   degrees,minutes = divmod(minutes,60)
   degrees = degrees if is_positive else -degrees
   return (degrees,minutes,seconds)

def getIndexSign(grado):
    index=0
    g=0.0
    for num in range(12):
        g = g + 30.00
        if g > float(grado):
            break
        index = index + 1
        #print('index sign: ' + str(num))

    return index


dia = sys.argv[1]
mes = sys.argv[2]
anio = sys.argv[3]

tipoLuminaria = sys.argv[4]
tipoEclipse = sys.argv[5]

swe.set_ephe_path('./swe')

d = datetime.datetime(int(anio),int(mes),int(dia),int(0), int(0))
jd1 =jdutil.datetime_to_jd(d)

grado=0

if int(tipoLuminaria) == 1:
    e=swe.lun_eclipse_when(jd1, int(tipoEclipse), False, swe.FLG_SWIEPH)
else:
    e=swe.sol_eclipse_when_glob(jd1, int(tipoEclipse), False, swe.FLG_SWIEPH)

for ecs in e:
    for ecs2 in ecs:
        #print(ecs2)
        jdE1=float(ecs2)
        dateEc1=jdutil.jd_to_date(jdE1)
        if float(dateEc1[0]) > 1:
            #print(dateEc1)
            d = datetime.datetime(int(dateEc1[0]),int(dateEc1[1]),int(dateEc1[2]))
            jd1=jdutil.datetime_to_jd(d)
            pos=swe.calc_ut(jd1, int(tipoLuminaria), flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
            grado=pos[0][0]
            #print(pos[0][0])
            break

indexSign=getIndexSign(grado)
gradoIs=30 * indexSign
rsgdeg=int(decdeg2dms(grado)[0] - gradoIs)
gdeg=int(decdeg2dms(grado)[0])
mdeg=int(decdeg2dms(grado)[1])
json='{'
json+='"gdec":'+str(grado)+','
json+='"rsgdeg":'+str(rsgdeg)+','
json+='"gdeg":'+str(gdeg)+','
json+='"mdeg":'+str(mdeg)+','
json+='"is":'+str(indexSign)+''
json+='}'
print(json)
