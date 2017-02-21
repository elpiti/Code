import processing.serial.*; //Importamos la librería Serial
 
Serial port; //Nombre para puerto serial
 
PrintWriter output;  //Para crear el archivo de texto donde guardar los datos

String letras;

int marca = 0;
int rquad=90; //tamaño del circulo
int xquad=199;  //Posición X de circulo
int yquad=299;  //Posición Y de circulo

int rchoke = 25;
int xchoke = 350;
int ychoke = 300;
//Colores cuadrado de choke
int Rchoke = 255;
int Gchoke = 255;
int Bchoke = 255;

//Color de CHECK ENGINE
int Rce = 0;
int Gce = 0;
int Bce = 0;

//Color de OIL
int Roil = 0;
int Goil = 0;
int Boil = 0;

boolean overRect = false; //Estado del mouse si está encima de circulo o no
boolean sobrechoke =false;
 
 
//Colores del botón
int red=51;
int green=250;
int blue=8;
 
boolean status=false; //Estado del color de rect
boolean statuschoke = false;
String texto = "ENCENDER MOTOR";//Texto del status inicial del LED

String textochoke = "Contacto";

String info = "*Presione       E      para  salir";
String nombres = "ELECTIVA III\n10°  NIVEL\nTANIA  AGUIRRE\nPEDRO VALLADARES";
 
int xlogo=370;//Posición X de la imagen
int ylogo=75;//Posición Y de la imagen
 
int valor;//Valor de la velocidad
int dato;
int rpm;
float valor1; 


//Colores de rectangulo de velocidad
float rojo;
float verde;
float azul;
 
void setup()
{
  //println(Serial.list()); //Visualiza los puertos serie disponibles en la consola de abajo
  //Comunicacion a una velocidad de 115200 Baudios
  port = new Serial(this, Serial.list()[1], 115200);  
  port.buffer(7);
   
  port.write(65);
  output = createWriter("Historico_RPM.txt"); //Creamos el archivo de texto, que es guardado en la carpeta del programa
  output.println("RPM         FECHA         HORA         "); 
  println("RPM         FECHA         HORA         "); 
  size(767, 480); //Creamos una ventana de 767 píxeles de anchura por 480 píxeles de altura 
}
 //Pone imagen de fondo
void draw()
{
  PImage  img;
  img = loadImage("carbon_fine2x2_twill_wallpaper_by_bigbc_opt1.jpg");
  background(img);
 
    
  if(mouseX > xquad-rquad && mouseX < xquad+rquad &&  //Si el mouse se encuentra dentro de circulo
     mouseY > yquad-rquad && mouseY < yquad+rquad)
     {
       overRect=true;  //Variable que demuestra que el mouse esta dentro de circulo
       stroke(151,151,151);  //Contorno de rect plomo
     }
   else
   {
     overRect=false;  //Si el mouse no está dentro de circulo, la variable pasa a ser falsa
     stroke(0,0,0);  //Contorno de rect negro
   }
   
   //BOTON DE CHOKE, ENCENDIDO ;)
    if(mouseX > xchoke-rchoke && mouseX < xchoke+rchoke &&  //Si el mouse se encuentra dentro de circulo
     mouseY > ychoke-rchoke && mouseY < ychoke+rchoke)
     {
       sobrechoke=true;  //Variable que demuestra que el mouse esta dentro de circulo
       stroke(151,151,151);  //Contorno de rect plomo
     }
   else
   {
     sobrechoke=false;  //Si el mouse no está dentro de circulo, la variable pasa a ser falsa
     stroke(0,0,0);  //Contorno de rect negro
   }
   
      
   
  //Dibujamos un circulo de color gris
  fill(red,green,blue);
  ellipseMode(RADIUS); //Esta función hace que Width y Height de circulo sea el radio (distancia desde el centro hasta un costado).
  ellipse(xquad,yquad,rquad,rquad);
  //Pone imagen de bonton de encendido
  PImage botstart;
  botstart= loadImage("startbutton.png");
  image(botstart,200,300,185,184);
  
   //DIBUJAMOS EL CUADRADO PARA EL BOTON CHOKE
  noStroke();
  fill(Rchoke,Gchoke,Bchoke);
  rectMode(RADIUS); //Esta función hace que Width y Height de circulo sea el radio (distancia desde el centro hasta un costado).
  rect(xchoke,ychoke,rchoke,rchoke);
    
  //ESCRIBIMOS LAS LETRAS PARA CHOKE
  fill(255,255,255);
  PFont letrachoke = loadFont("StylusBT-48.vlw");//Tipo de fuente
  textFont(letrachoke, 15);
  text(textochoke, 320, 340);
 
  //Cuadrados para las luces del tablero
  //CHECK ENGINE
  noStroke();
  fill(Rce,Gce,Bce);
  rect(525,328,32,20); 
  //OIL
  noStroke();
  fill(Roil,Goil,Boil);
  rect(615,328,40,20);
  
    
  //Creamos un texto de color blanco con la palabra ENCENDER MOTOR  
  fill(255,255,255);
  PFont f = loadFont("StylusBT-48.vlw");//Tipo de fuente
  textFont(f, 30);
  text(texto, 90, 200);
  
    
  //Ponemos la imagen del logo de la UPS
  imageMode(CENTER);//Esta función hace que las coordenadas de la imagen sean el centro de esta y no la esquina izquierda arriba
  PImage imagen=loadImage("logo-ups-home.png");
  image(imagen,xlogo,ylogo,400,100);
 
  PImage checkengine = loadImage("engine1.png");
  image (checkengine,525,330,170,81);
  
  PImage oil = loadImage("oil1.png");
  image (oil,615,330,170,81);
 
  PImage choke = loadImage("choke.png");
  image (choke,xchoke,ychoke,50,50);
 
  //Recibir datos rpm del Arduino 
  if(port.available() > 0) // si hay algún dato disponible en el puerto
   {
     valor=port.read();//Lee el dato y lo almacena en la variable "valor"
     //letras = port.readString();
   }
   //Visualizamos la velocidad con un texto
   text("RPM =",490,200);
   valor1 = map(valor,0,250,0,8000);
   rpm =int(valor1);
   text(rpm, 590, 200);
   
  //print(valor); 
  if(valor == 'r'){
    valor = 0;
    rpm = 0;
        
    Rce = 255;
    Gce = 230;
    Bce = 3;
     
    Roil = 255;
    Goil = 0;
    Boil = 4;
    }
    
  if(valor == 'h'){
    rpm = 800;
    Rce = 255;
    Gce = 230;
    Bce = 3;
    }  
    
   //Escribimos los datos de las rpm con el tiempo (h/m/s) en el archivo de texto
   //output.print(rpm + " RPM     ");
   output.print(rpm + "         ");
   output.print(day( )+"/");
   output.print(month( )+"/");
   output.print(year( )+"      ");
   output.print(hour( )+":");
   output.print(minute( )+":");
   output.println(second( ));
   output.println("");
   
   
   //Escribe los datos en la consola para visualizar datos en vivo (TIEMPO REAL)
  
   print(rpm + "         ");
   print(day( )+"/");
   print(month( )+"/");
   print(year( )+"      ");
   print(hour( )+":");
   print(minute( )+":");
   println(second( ));
   println("");
   
   
  //rectangulo color visualización de rpm
  float temp = map (valor,0,200, 0, 255);//Escalamos la rpm donde maximo sea 8000rpm y mínimo 800rpm
  rojo=temp;
  verde=temp*-1 + 255;
  azul=temp*-10 + 255;
  
  //Dibujamos un rectangulo para colorear con el valor de las rpm
  noStroke();
  fill(rojo,verde,azul);
  rectMode(CENTER);
  rect(570,250,85,22);
  
  //Texto Informativo con los nombres de los integrantes
  fill(255,255,255);
  PFont ff = loadFont("StylusBT-48.vlw");//Tipo de fuente
  textFont(ff, 20);
  text(info, 49, 445);
  //integrantes
  text(nombres,500,400);  
 
}
 
void mousePressed()  //Cuando el mouse está apretado
{
  //BOTON DE ENCEDIDO DEL MOTOR :)
  if (overRect==true) //Si el mouse está dentro del boton de encendido
  {
    status=!status; //El estado del color cambia
    port.write("z"); //Envia una "z" para que el motor se encienda a 800rpm
    if(status==true)
    {
      //Color del botón rojo
      red=255;
      green=9;
      blue=0;
      texto="MOTOR ON";
      Rchoke = 0;
      Gchoke = 0;
      Bchoke = 0;
     
      Rce = 0;
      Gce = 0;
      Bce = 0;
      
      Roil = 0;
      Goil = 0;
      Boil = 0;
      
   }
    
    if(status==false)
    {
      //Color del botón verde
      port.write("s");
      red=51;
      green=250;
      blue=8;
      texto="MOTOR OFF";
      
    }
  }
  
  
  //BOTON PARA CONTACTO Y LUCES TESTIGO CHECK Y OIL
  if (sobrechoke==true) //Si el mouse está dentro del boton de encendido
  {
    statuschoke=!statuschoke; //El estado del color cambia
    port.write("k"); //Envia una "z" para que el motor se encienda a 800rpm
    if(statuschoke==true)
    {
      //Color del botón rojo
      Rchoke = 255;
      Gchoke = 255;
      Bchoke = 255;
      //textochoke="MOTOR ON";
      Rce = 255;
      Gce = 230;
      Bce = 3;
     
      Roil = 255;
      Goil = 0;
      Boil = 4;
        
      port.clear();
      
    }
    if(statuschoke==false)
    {
      //Color del botón verde
      port.write("q");
      Rchoke = 0;
      Gchoke = 0;
      Bchoke = 0;
      //textochoke="MOTOR OFF";
      Rce = 0;
      Gce = 0;
      Bce = 0;
      
      Roil = 0;
      Goil = 0;
      Boil = 0;
    }
  }
  
    
}
 
void keyPressed() //Cuando se pulsa una tecla
{
  //Aumenta la velocidad
  if(keyCode ==UP)
  {
    port.write("A");  
    delay(5);
  }
  //Disminuye la velocidad
  else if(keyCode ==DOWN)
  {
    port.write("B");  
    delay(5);   
  }  
  //Pone en ralenti al motor
  if(keyCode =='r'|| keyCode =='R')
  {
    port.write("z");  
    delay(5);
  }
  
  //Pulsar la tecla E para salir del programa
  if(key=='e' || key=='E')
  {
    port.write("s");  //apaga el motor
    port.write("q"); 
    output.flush(); // Escribe los datos restantes en el archivo
    output.close(); // Final del archivo
    exit();//Salimos del programa
  }
}