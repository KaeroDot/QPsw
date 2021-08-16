#!/home/rji/Documentos/PythonWork/Arduino/QuP/bin/python
"""
    PROGRAMA DE PYTHON
    Pide un caracter al usuario y lo envia por Serial.
 
"""
 
 
import serial, time
import io
from readSeqFile import * 
 
#Inicializamos el puerto de serie a 9600 baud
arduino = serial.Serial('/dev/ttyUSB0', 9600)
time.sleep(2)
arduino.flush() 

Seq = ""
cnt = 0


#Now the command list is shown
print("Command list: \n")
print("ENA SLx CHx ON|OFF")
print("STAT")
print("*IDN?")
print("*RST")
print("*CLS")
print("GTL")
print("REM")
print("TRG")
print("TIMER")
print("TIMER?")
print("ADDSEQ")
print("SEQ?")
print("NSEQ?")
print("DELSEQ")
print("START")
print("STOP")
print("RESUME")
print("PAUSE")
print("*STB?")
print("TRGPOL")
print("GRD")
print("LDSEQ <cnt>")
print("GTSEQ")
print("STSEQ")
print("RLSEQ")

print("type <exit> to terminate the script")


with arduino:
	while True:
           try:
            #The user enter a command
              print("Enter a command: ")
              command = input()
              command = command + str('\r\n')
              
              if command[0:4] == "exit":
                  arduino.close()
                  exit()

              #if the command LDSEQ I read the sequence file
              if command[0:5] == "LDSEQ":
                  #The function takes the filename as parameter
                  txBuff=packSequence("Sequence.txt") 

                  arduino.write(command.encode())
                  for i in range(len(txBuff)):
                    arduino.write(txBuff[i])

                  line = arduino.readline()
                  print(line)
              else:

                  arduino.write(command.encode())  
                  #As the command are query/response I am reading the response from the Arduino
                  line = arduino.readline()

                  if command[0:5] == "*STB?":
                    aux = list(line.decode().strip())
                    #stb = line.strip()
                    stb = ''.join('{0:08b}'.format(ord(i), 'b') for i in aux[7]) 
                    #print('{0:08b}'.format(ord(stb[7])))
                    print(stb)
                  else:
                    print(line.strip())
           except KeyboardInterrupt:
              print("Exiting")
              break

arduino.close()
