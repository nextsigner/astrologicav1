import swisseph as swe
import jdutil
import datetime
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
#horaLocal = horaLocal - datetime.timedelta(minutes=int(30))
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
h=swe.houses(jd1, float(lat), float(lon), bytes(houseType, encoding = "utf-8"))

jsonString='{'

index=0

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
    break

jsonHouses+='}'
jsonString+='' + jsonHouses+','
jsonString+='' + jsonParams
jsonString+='}}'

#print(jsonBodies)
#print(jsonHouses)
#print(jsonAspets)
print(jsonString)
swe.close()
#help(swe)
