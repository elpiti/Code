//LLAMA LIBRERIA DE INTERRUPCIONES EXTERNAS
#include <avr/interrupt.h>
//INICIALIZACION DE VARIABLES
int marca=0;
int val=0;

//PINES DE SALIDA PARA BUJIAS
int bujia1=10;
int bujia2=11;
int bujia3=12;
int bujia4=13;
//PINES DE SALIDA PARA INYECTORES
int inyec1=6;
int inyec2=7;
int inyec3=8;
int inyec4=9;
//VARIABLE PARA SALIDA PWM AL MOTOR
int motor=5;
int valor;
//ENTRADA DE INTERRUPCIONES PARA EL ENCODER
int encoder1=2;
int aviso=19;
int pulsador=4;
int app = 17;
int oil = 18;

volatile int contador = -1;
 
void setup()
{
  //INICIA COMUNICACION SERIAL A 115200 BAUDIOS
  Serial.begin(115200);
  Serial3.begin(115200);
  attachInterrupt(0,pinISR,RISING);
  //MODO DE FUNCIONAMIENTO DE PINES PARA BUJIAS COMO SALIDAS
  pinMode(bujia1,OUTPUT);
  pinMode(bujia2,OUTPUT);
  pinMode(bujia3,OUTPUT);
  pinMode(bujia4,OUTPUT);
  //MODO DE FUNCIONAMIENTO DE PINES PARA INYECTORES COMO SALIDAS
  pinMode(inyec1,OUTPUT);
  pinMode(inyec2,OUTPUT);
  pinMode(inyec3,OUTPUT);
  pinMode(inyec4,OUTPUT);
  pinMode(motor,OUTPUT);
  pinMode(aviso,OUTPUT);
  pinMode(pulsador,INPUT);
  pinMode(oil,OUTPUT);
  pinMode(app, INPUT);
  digitalWrite(aviso,LOW);
  digitalWrite(oil,LOW);
    }
 
void loop()
{   
   //PROGRAMACION DEL CKP
    if(digitalRead(pulsador)==1){
    digitalWrite(aviso,HIGH);
    digitalWrite(oil,HIGH);
    analogWrite(motor,0);   
    Serial.write('r'); 
    Serial3.write('C');
    }
    
    /*else{
    digitalWrite(aviso,LOW);
    digitalWrite(oil,LOW);
    //analogWrite(motor,valor);    
    }*/
    
  //PROGRAMACION DEL APP
    if(digitalRead(app)==1){
     //analogWrite(motor, 30);
     digitalWrite(aviso,HIGH);
     Serial.write('h'); 
     Serial3.write('P');
         }
    /* else{
    digitalWrite(aviso,LOW);
    }*/
  
  //COMUNICACION SERIAL
  if(Serial.available()>0)//Si el Arduino recibe datos a través del puerto serie
  {
       
    byte dato = Serial.read(); //Los almacena en la variable "dato"      

     
    if(dato=='A'&& marca==1) { //AUMENTA PWM VELOCIDAD DEL MOTOR  
    valor=valor+5;  
    Serial.write(valor);
    Serial3.write(valor);
    if(valor>245){
    valor=245;
    }
    analogWrite(motor,valor);      
    }
    
    if(dato=='B'&& marca==1) { //DISMINUYE PWM VELOCIDAD DEL MOTOR 
    valor=valor-5; 
    Serial.write(valor);
    Serial3.write(valor);
    if(valor<30){
    valor=30;
    }     
    analogWrite(motor,valor);
    }

        //SI RECIBE LA LETRA "z", EL MOTOR SE ENCIENDE EN RALENTI
    if(dato=='z') { 
    marca=1;
    valor=25;
    Serial.write(valor);
    Serial3.write(valor);
    analogWrite(motor,valor);  
    //APAGA LUCES TESTIGO
    digitalWrite(aviso,LOW);
    digitalWrite(oil,LOW);    
    }
    // SI RECIBE LA LETRA "s", EL MOTOR DETIENE SU MARCHA COMPLETAMENTE
    if(dato=='s') {  
    marca=0;
    valor=0;
    Serial.write(valor);
    Serial3.write(valor);
    analogWrite(motor,valor);
    } 
    
    //SI RECIBE LA LETRA "k", ENCIENDE LUCES TESTIGO AL MOMENTO DE PRESIONAR CONTACTO
    if(dato=='k'){
    digitalWrite(aviso,HIGH);
    digitalWrite(oil,HIGH);  
    }

    if(dato=='q'){
    digitalWrite(aviso,LOW);
    digitalWrite(oil,LOW);  
    }

    
      
    }
  }

//RUTINA PARA INTERRUPCION EXTERNA EN EL PIN 2 
void pinISR(){
  //CADA VEZ QUE INGRESA CUENTA DE FORMA ASCENDENTE HASTA EL 3 Y REINICA SU VALOR A 0
contador++;  
//Serial.println(contador);
if(contador==4){
 contador = 0; 
}

 //CADA VEZ Q REALIZA ENTRA A LA INTERRUPCION Y AUMENTA LA VARIABLE CONTADOR INGRESA AL MENU PARA 
 //ENCENDER DE ACUERDO AL ORDEN 1,3,4,2. RESPECTIVAMENTE CADA CILINDRO
    switch(contador){
       case 0:
         //CILINDRO 1
         digitalWrite(inyec1,HIGH);
         delay(20);
         digitalWrite(inyec1,LOW);
         delay(2);
         digitalWrite(bujia1,HIGH);
         delay(20);
         digitalWrite(bujia1,LOW);
       break;
       
       case 1:
         //CILINDRO 3
         digitalWrite(inyec3,HIGH);
         delay(20);
         digitalWrite(inyec3,LOW);
         delay(2);
         digitalWrite(bujia3,HIGH);
         delay(20);
         digitalWrite(bujia3,LOW);
       break;
       
       case 2:
         //CILINDRO 4
         digitalWrite(inyec4,HIGH);
         delay(20);
         digitalWrite(inyec4,LOW);
         delay(2);
         digitalWrite(bujia4,HIGH);
         delay(20);
         digitalWrite(bujia4,LOW);
       break;
       
       case 3:
         //CILINDRO 2
         digitalWrite(inyec2,HIGH);
         delay(20);
         digitalWrite(inyec2,LOW);
         delay(2);
         digitalWrite(bujia2,HIGH);
         delay(20);
         digitalWrite(bujia2,LOW); 
       break;
     } 
//digitalWrite(13, !digitalRead(13));
} 

