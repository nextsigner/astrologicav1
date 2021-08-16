import swisseph as swe
import jdutil
import datetime
import sys
from subprocess import run, PIPE

dia = sys.argv[1]
mes = sys.argv[2]
anio = sys.argv[3]
hora = sys.argv[4]
min = sys.argv[5]
gmt = sys.argv[6]

lat = sys.argv[7]
lon = sys.argv[8]

#print('Fecha: '+dia+'/'+mes+'/'+anio+' Hora: '+hora+':'+min)

horaLocal = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
horaLocal = horaLocal - datetime.timedelta(hours=int(gmt))
#print(horaLocal)

#dia=horaLocal.strftime('%d')
#mes=int(horaLocal.strftime('%m'))
#anio=horaLocal.strftime('%Y')
#hora=horaLocal.strftime('%H')
#min=horaLocal.strftime('%M')

#print('Tiempo: ' + dia + '/' + mes + '/' + anio + ' ' + hora + ':' + min)

swe.set_ephe_path('./swe')

jsonMomentos='{'

enDia1=False
momento='0/0/0000 00:00'
grado=0
#print(str(horaLocal))

def getHour(uHora, grado):
    for hora in range(24):
        #print('Hora: '+str(hora))
        encontrado=False
        for minuto in range(60):
            #print('Minuto: '+str(minuto))
            uHora  += datetime.timedelta(minutes=1)
            #print(str(d))
            jd1 =jdutil.datetime_to_jd(uHora)
            h=swe.houses(jd1, float(lat), float(lon), bytes("P", encoding = "utf-8"))
            gasc=float(h[0][0])
            if  gasc >= grado - 1.00 and gasc <= grado + 1.00:
                #print(str(gasc))
                uHora = uHora + datetime.timedelta(hours=int(gmt))
                encontrado=True
                break
        if encontrado:
            break

    return uHora

h1=getHour(horaLocal, 0.00)
#print(str(h1))
h2=getHour(h1, 30.00)
#print(str(h2))
h3=getHour(h2, 60.00)
#print(str(h3))
h4=getHour(h3, 90.00)
#print(str(h4))
h5=getHour(h4, 120.00)
#print(str(h5))
h6=getHour(h5, 150.00)
#print(str(h6))
h7=getHour(h6, 180.00)
#print(str(h7))
h8=getHour(h7, 210.00)
#print(str(h8))
h9=getHour(h8, 240.00)
#print(str(h9))
h10=getHour(h9, 270.00)
#print(str(h10))
h11=getHour(h10, 300.00)
#print(str(h11))
h12=getHour(h11, 330.00)
#print(str(h12))

jsonMomentos+='"params":{'
jsonMomentos+='"gmt":'+str(gmt)+','
jsonMomentos+='"lat":'+str(lat)+','
jsonMomentos+='"lon":'+str(lon)+''
jsonMomentos+='},'

jsonMomentos+='"fechas":{'

tuplaHs=tuple([h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12])
indexHs=0
for horaTupla in range(12):
    #print(str(tuplaHs[indexHs]))
    dia=str(int(tuplaHs[indexHs].strftime('%d')))
    mes=str(int(tuplaHs[indexHs].strftime('%m')))
    anio=str(int(tuplaHs[indexHs].strftime('%Y')))
    hora=str(int(tuplaHs[indexHs].strftime('%H')))
    min=str(int(tuplaHs[indexHs].strftime('%M')))

    if indexHs != 0:
        jsonMomentos+=','

    jsonMomentos+='"is'+ str(indexHs) +'":{'
    jsonMomentos+='"d":'+dia+','
    jsonMomentos+='"m":'+mes+','
    jsonMomentos+='"a":'+anio+','
    jsonMomentos+='"h":'+hora+','
    jsonMomentos+='"min":'+min+''
    jsonMomentos+='}'

    indexHs = indexHs + 1

jsonMomentos+='}'
jsonMomentos+='}'
print(jsonMomentos)
