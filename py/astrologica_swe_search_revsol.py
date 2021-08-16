import swisseph as swe
import jdutil
import datetime
import sys, os, pathlib
from subprocess import run, PIPE

def dms2dd(degrees, minutes, seconds):
    dd = float(degrees) + float(minutes)/60 + float(seconds)/(60*60);
    #if direction == 'E' or direction == 'N':
        #dd *= -1
    return dd;

dia = sys.argv[1]
mes = sys.argv[2]
anio = sys.argv[3]
hora = sys.argv[4]
min = sys.argv[5]
gmt = sys.argv[6]

lat = sys.argv[7]
lon = sys.argv[8]

gradoArg = int(sys.argv[9])
minutoArg = int(sys.argv[10])
segundoArg = int(sys.argv[11])

#print('Fecha: '+dia+'/'+mes+'/'+anio+' Hora: '+hora+':'+min)

horaLocal = datetime.datetime(int(anio),int(mes),int(dia),int(hora), int(min))
horaLocal = horaLocal - datetime.timedelta(hours=float(gmt))

swe.set_ephe_path('./swe')

jsonMomentos='{'

enDia1=False
momento='0/0/0000 00:00'
grado=0
#print(str(horaLocal))

encontrado=False

def getHour(uHora, grado):
    for hora in range(24):
        #print('Hora: '+str(hora))        
        encontrado=False
        tuplaRet=[(uHora,encontrado)]
        for minuto in range(60):
            #print('Minuto: '+str(minuto))
            uHora  += datetime.timedelta(minutes=1)
            #print(str(d))
            jd1 =jdutil.datetime_to_jd(uHora)
            pos=swe.calc_ut(jd1, 0, flag=swe.FLG_SWIEPH+swe.FLG_SPEED)
            gsol=float(pos[0][0])
            #print(str(gsol) + '<----->' + str(grado))
            if  gsol >= grado:
                #print(str(gsol))
                uHora = uHora + datetime.timedelta(hours=float(gmt))
                encontrado=True
                tuplaRet=[(uHora,encontrado)]
                #tuplaRet[1]=uHora
                break
        if encontrado:
            break

    return tuplaRet


gdec=dms2dd(gradoArg,minutoArg,segundoArg)
pos1=getHour(horaLocal, gdec)
#print(pos1[0][0])
#print(pos1[0][1])
dateTimeFinal=pos1[0][0]
encontradoFinal=pos1[0][1]
if pos1[0][1] == False:
    pos2=getHour(pos1[0][0], gdec)
    dateTimeFinal=pos2[0][0]
    encontradoFinal=pos2[0][1]
    if pos2[0][1] == False:
        pos3=getHour(pos2[0][0], gdec)
        dateTimeFinal=pos3[0][0]
        encontradoFinal=pos3[0][1]

if encontradoFinal == False:
    print(encontradoFinal)
else:
    #print(dateTimeFinal)
    if os.name == 'nt':
        cmd='.\\Python\\python.exe '+str(pathlib.Path(__file__).parent.absolute())+'\\astrologica_swe.py '
    else:
        cmd='python3 '+str(pathlib.Path(__file__).parent.absolute())+'/astrologica_swe.py '
    cmd+=str(dateTimeFinal.day)
    cmd+=' '+str(dateTimeFinal.month)
    cmd+=' '+str(dateTimeFinal.year)
    cmd+=' '+str(dateTimeFinal.hour)
    cmd+=' '+str(dateTimeFinal.minute)
    cmd+=' '+str(gmt)
    cmd+=' '+str(lat)
    cmd+=' '+str(lon)
    #cmd+=' -35.47857 -69.61535'
    #print(cmd)
    os.system(cmd)
#print(pos1)
#print(pos2)

#print('Grado Decimal: '+str(gdec))

