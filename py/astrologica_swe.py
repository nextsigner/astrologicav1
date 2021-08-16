import swisseph as swe
import jdutil
import datetime
from decimal import Decimal
import sys
from subprocess import run, PIPE

houseType="P"

def decdeg2dms(dd):
   is_positive = dd >= 0
   dd = abs(dd)
   minutes,seconds = divmod(dd*3600,60)
   degrees,minutes = divmod(minutes,60)
   degrees = degrees if is_positive else -degrees
   return (degrees,minutes,seconds)

#Calculo para Fortuna Diurna Asc + Luna - Sol
#Calculo para Fortuna Nocturna Asc + Sol - Luna


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

#Para la Conjunción un orbe de 8 grados.
#Para la Oposición un orbe de 8 grados.
#Para el Trígono un orbe de 8 grados.
#Para la Cuadratura, un orbe de 7 grados.
#Para el Sextil, un orbe de 6 grados.
def getAsp(g1, g2, ic):
    asp=-1 # -1 = no hay aspectos. 0 = oposición. 1 = cuadratura. 2 = trígono. 3 = conjunción
    #np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Selena', 57), ('Lilith', 12)]
    orbe8=8
    orbe7=7
    if indexAsp == 5 or indexAsp == 6 or indexAsp == 7 or indexAsp == 8 or indexAsp == 9 or indexAsp == 12:
        orbe8=10
        orbe7=9
    #Calculo oposición.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 180.00 + orbe8 and difDeg > 180.00 - orbe8:
        asp=0

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 180.00 + orbe8 and difDeg > 180.00 - orbe8:
        asp=0

    #Calculo cuadratura.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 90.00 + orbe7 and difDeg > 90.00 - orbe7:
        asp=1

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 90.00 + orbe7 and difDeg > 90.00 - orbe7:
        asp=1

    #Calculo trígono.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 120.00 + orbe8 and difDeg > 120.00 - orbe8:
            asp=2

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 240.00 + orbe8 and difDeg > 240.00 - orbe8:
         asp=2

    #Calculo conjunción.
    difDeg=swe.difdegn(g1, g2)
    if difDeg < 0 + orbe8 and difDeg > 0 - orbe8:
            asp=3

    difDeg=swe.difdegn(g2, g1)
    if difDeg < 0 + orbe8 and difDeg > 0 - orbe8:
        asp=3

    return asp


dia = sys.argv[1]
mes = int(sys.argv[2]) #+ 1
anio = sys.argv[3]
hora = sys.argv[4]
min = sys.argv[5]
gmt = sys.argv[6]

lat = sys.argv[7]
lon = sys.argv[8]

if float(gmt) < 0.0:
        gmtCar='W'
        gmtNum=abs(float(gmt))
else:
        gmtCar='E'
        gmtNum=float(gmt)

if float(lon) < 0:
    lonCar='W'
else:
    lonCar='E'


if float(lat) < 0:
        latCar='S'
else:
        latCar='N'


GMSLat=decdeg2dms(float(lat))
GMSLon=decdeg2dms(float(lon))

#print('Fecha: '+dia+'/'+mes+'/'+anio+' Hora: '+hora+':'+min)

#Astrolog
#Consulta normal ./astrolog -qa 6 20 1975 23:00 3W 69W57 35S47
#Consultar Aspectos ./astrolog -qa 6 20 1975 23:00 3W 69W57 35S47 -a -A 4

#cmd1='~/astrolog/astrolog -qa '+str(int(mes))+' '+str(int(dia))+' '+anio+' '+hora+':'+min+' ' + str(gmtNum) + ''+ gmtCar +' ' +str(int(GMSLon[0])) + ':' +str(int(GMSLon[1])) + '' + lonCar + ' ' +str(int(GMSLat[0])) + ':' +str(int(GMSLat[1])) + '' + latCar + '  -a -A 4'
#print(cmd1)
#s1 = run(cmd1, shell=True, stdout=PIPE, universal_newlines=True)
#s2=str(s1.stdout).split(sep="\n")

#index=0
#for i in s2:
    #print('------------------>' + str(s2[index]))
    #index= index + 1
    #if index > 15:
        #break

getIndexSign
horaLocal = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))

#Prevo a aplicar el GMT
dia=horaLocal.strftime('%d')
mes=int(horaLocal.strftime('%m'))
anio=horaLocal.strftime('%Y')
hora=horaLocal.strftime('%H')
min=horaLocal.strftime('%M')

stringDateSinGmt= str(dia) + '/' + str(mes) + '/' + str(anio) + ' ' + str(hora) + ':' + str(min)+'"'




horaLocal = horaLocal - datetime.timedelta(hours=float(gmt))
#print(horaLocal)

#Luego de aplicar el GMT
dia=horaLocal.strftime('%d')
mes=int(horaLocal.strftime('%m'))
anio=horaLocal.strftime('%Y')
hora=horaLocal.strftime('%H')
min=horaLocal.strftime('%M')

#print('Tiempo: ' + dia + '/' + mes + '/' + anio + ' ' + hora + ':' + min)

swe.set_ephe_path('./swe')

d = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
jd1 =jdutil.datetime_to_jd(d)

jsonParams='"params":{'
jsonParams+='"jd":'+str(jd1)+','
jsonParams+='"sd": "'+ str(dia) + '/' + str(mes) + '/' + str(anio) + ' ' + str(hora) + ':' + str(min)+'",'
jsonParams+='"sdgmt": "'+ stringDateSinGmt
jsonParams+='}'

np=[('Sol', 0), ('Luna', 1), ('Mercurio', 2), ('Venus', 3), ('Marte', 4), ('Júpiter', 5), ('Saturno', 6), ('Urano', 7), ('Neptuno', 8), ('Plutón', 9), ('Nodo Norte', 11), ('Nodo Sur', 10), ('Quirón', 15), ('Selena', 57), ('Lilith', 12)]

#La oblicuidad de calcula con ipl = SE_ECL_NUT = -1 en SWE pero en swisseph ECL_NUT = -1
posObli=swe.calc(jd1, -1, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
oblicuidad=posObli[0][0]
#print('Oblicuidad: ' + str(posObli[0][0]))

#Se calculan casas previamente para calcular en cada cuerpo con swe.house_pos(...)
#h=swe.houses(jd1, float(lat), float(lon), bytes("P", encoding = "utf-8"))
#swe.set_topo(float(lat), float(lon), 1440.00)
h=swe.houses(jd1, float(lat), float(lon), bytes(houseType, encoding = "utf-8"))

jsonString='{'

#Comienza JSON Bodies
tuplaPosBodies=()
jsonBodies='"pc":{'
index=0
for i in np:
    pos=swe.calc_ut(jd1, np[index][1], flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
    #print(pos)
    gObj=float(pos[0][0])
    if index == 11:
        #posNN=swe.calc_ut(jd1, np[10][1], flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
        gNN=float(tuplaPosBodies[index - 1])#float(posNN[0][0]) + 180 #
        if gNN < 180:
            gNS= 180.00 + gNN#360.00 - gNN
        else:
            gNS=gNN - 180.00

        #print('Planeta: ' +np[index][0] + ' casa ' + str(posHouse))
        #print('Grado de Nodo Norte: '+str(gNN))
        #print('Grado de Nodo Sur: '+str(gNS))
        gObj=gNS

    tuplaPosBodies+=tuple([gObj])
    indexSign=getIndexSign(gObj)
    td=decdeg2dms(gObj)
    gdeg=int(td[0])
    mdeg=int(td[1])
    sdeg=int(td[2])
    rsgdeg=gdeg - ( indexSign * 30 )
    jsonBodies+='"c' + str(index) +'": {' if (index==0) else  ',"c' + str(index) +'": {'
    jsonBodies+='"nom":"' + str(np[index][0]) + '",'
    jsonBodies+='"is":' + str(indexSign)+', '
    jsonBodies+='"gdec":' + str(gObj)+', '
    jsonBodies+='"gdeg":' + str(gdeg)+', '
    jsonBodies+='"rsgdeg":' + str(rsgdeg)+', '
    jsonBodies+='"mdeg":' + str(mdeg)+', '
    jsonBodies+='"sdeg":' + str(sdeg)+', '
    posHouse=swe.house_pos(h[0][9],float(lat), oblicuidad, gObj, 0.0, bytes(houseType, encoding = "utf-8"))

    jsonBodies+='"ih":' + str(int(posHouse))+', '
    jsonBodies+='"dh":' + str(posHouse)
    jsonBodies+='}'
    index=index + 1

jsonBodies+='}'


jsonAspets='"asps":{'
#print(tuplaPosBodies)
tuplaArr=(())
arr1=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
arr2=(0,2,3,4,5,6,7,8,9,10,11,12,13,14,15)
arr3=(0,1,3,4,5,6,7,8,9,10,11,12,13,14,15)
arr4=(0,1,2,4,5,6,7,8,9,10,11,12,13,14,15)
arr5=(0,1,2,3,5,6,7,8,9,10,11,12,13,14,15)
arr6=(0,1,2,3,4,6,7,8,9,10,11,12,13,14,15)
arr7=(0,1,2,3,4,5,7,8,9,10,11,12,13,14,15)
arr8=(0,1,2,3,4,5,6,8,9,10,11,12,13,14,15)
arr9=(0,1,2,3,4,5,6,7,9,10,11,12,13,14,15)
arr10=(0,1,2,3,4,5,6,7,8,10,11,12,13,14,15)
arr11=(0,1,2,3,4,5,6,7,8,9,11,12,13,14,15)
arr12=(0,1,2,3,4,5,6,7,8,9,10,12,13,14,15)
arr13=(0,1,2,3,4,5,6,7,8,9,10,11,13,14,15)
arr14=(0,1,2,3,4,5,6,7,8,9,10,11,12,14,15)
arr15=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,15)
tuplaArr=((arr1),(arr2),(arr3),(arr4),(arr5),(arr6),(arr7),(arr8),(arr9),(arr10),(arr11),(arr12),(arr13),(arr14),(arr15))
#print(tuplaArr)
index=0
indexAsp=0
for i in tuplaPosBodies:
    #print('i:' + str(i))
    for num in range(14):
        #print('Comp: ' + str(np[index][0]) + ' con ' + str(np[tuplaArr[index][num]][0]))
        g1=float(tuplaPosBodies[index])
        g2=float(tuplaPosBodies[tuplaArr[index][num]])
        #print('g1: '+str(g1) + ' g2: ' + str(g2))
        controlar=str(tuplaArr[index][num])==str(index)

        asp=getAsp(g1, g2, index)
        stringInvertido='"ic1":' + str(tuplaArr[index][num]) + ', "ic2":' + str(index) + ', '
        stringActual='"ic1":' + str(index) + ', "ic2":' + str(tuplaArr[index][num]) + ', '
        if asp >= 0 and stringInvertido not in jsonAspets and controlar == False:
            jsonAspets+='"asp' +str(index) + '": {' if (indexAsp==0) else  ',"asp' +str(index) + '": {'
            #jsonAspets+='"asp' +str(index) + '": {'
            jsonAspets+=stringActual
            jsonAspets+='"c1":"' + str(np[index][0]) + '", '
            jsonAspets+='"c2":"' + str(np[num][0]) + '", '
            jsonAspets+='"ia":' + str(asp) + ','
            jsonAspets+='"gdeg1":' + str(g1) + ','
            jsonAspets+='"gdeg2":' + str(g2) + ','
            jsonAspets+='"dga":' + str(swe.difdegn(g1, g2)) + ''
            jsonAspets+='}'
            indexAsp = indexAsp +1
        #print('Dif 1: '+str(swe.difdegn(g1, g2)))
        #print('Dif 2: '+str(swe.difdegn(g2, g1)))
        #print(asp)
        #print('Comp:' + np[index][0] + ' con '
    index = index + 1

jsonAspets+='}'
#print(jsonAspets)
#print('Cantidad de Aspectos: '+str(indexAsp))
#Comienza JSON Houses
jsonHouses='"ph":{'
numHouse=1
#print('ARMC:' + str(h[0][9]))

for i in h[0]:
    td=decdeg2dms(i)
    gdeg=int(td[0])
    mdeg=int(td[1])
    sdeg=int(td[2])
    index=getIndexSign(float(i))
    rsgdeg=gdeg - ( index * 30 )
    jsonHouses+='"h' + str(numHouse) + '": {'
    jsonHouses+='"is":' + str(index)+', '
    jsonHouses+='"gdec":' + str(i)+','
    jsonHouses+='"rsgdeg":' + str(rsgdeg)+', '
    jsonHouses+='"gdeg":' + str(gdeg)+','
    jsonHouses+='"mdeg":' + str(mdeg)+','
    jsonHouses+='"sdeg":' + str(sdeg)+''
    if numHouse != 12:
        jsonHouses+='},'
    else:
        jsonHouses+='}'
    numHouse = numHouse + 1

jsonHouses+='}'

jsonString+='' + jsonBodies + ','
jsonString+='' + jsonHouses + ','
jsonString+='' + jsonAspets + ','
jsonString+='' + jsonParams
jsonString+='}'

#print(jsonBodies)
#print(jsonHouses)
#print(jsonAspets)
print(jsonString)
swe.close()
#help(swe)
