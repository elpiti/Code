int valor;
char dat;
String fallo;
int rpm;
void setup() {
   Serial.begin(115200); // Configuracion del puerto serial de comunicacion con el ESCLAVO
   delay(1000);
   Serial.println("***SCANNER AUTOMOTRIZ***");
   Serial.println("     RPM    FALLO");
}
 
void loop() {
  if (Serial.available()) {  // Verificacion que el puerto serial recibe datos                                  
   delay(10);                
                              
   while (Serial.available() > 0)
   {
     valor = Serial.read();
     dat = Serial.read();
     rpm = map(valor,0,250,0,8000);
   
     //Serial.write(rpm);
     //Serial.println(fallo);


     if (dat == 'C'){
    Serial.write('o');
      }
      else{
        Serial.write('N');
        }
      
     if (dat == 'P'){
    Serial.write('l');
      }
     else{
        Serial.write('N');
        }

      
    } 
    Serial.write(valor);
  }
}
 

