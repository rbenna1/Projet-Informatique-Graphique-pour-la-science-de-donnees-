float iposX = 1;
float iposY = -1;
boolean Outside = true;

float posX = iposX;
float posY = iposY;
float posZ = 0;
float MposX = 1.0;
float MposY = 3.0;
float MposZ = 0.0;
float MTorsoH = 20.0;

float dirX = 0;
float dirY = 1;
float odirX = 0;
float odirY = 1;
float MdirX = 0;
float MdirY = 1;
float WALLD = 1;
//float zLabCoordinate = 0;
int CurrentLaby = 0;

boolean FreeCam = false;

int anim = 0;
float angleB = 0;
float distB = height/2 - height/3;
float distBW = height*0.95 - height*0.85;

boolean animT=false;
boolean animR=false;

boolean inLab = true;

int LAB_SIZE = 21;
int LABS_HEIGHT = 5;
int ETAGES = 5;
int todig [];
char labyrinthe [][][];
char sides [][][][];

PShape laby0 [];
PShape ceiling0 [];
PShape ceiling1 [];
PImage  texture0;
PImage texture1;
PImage img;
PImage compass;
PShape Hand1;
PShape Hand2;
PShape Momie;

int cols, rows;
int scl = 30;
int w = 2000;
int h = 2000;
float SortiesTabX [][];
float SortiesTabY [][];

float [][] terrain;

 int Frames = 0;
 
void setup() { 
  pixelDensity(2);
  randomSeed(2);
  tint(150,150,0);
  texture0 = loadImage("stones.jpg");
  texture1 = loadImage("sandstone.jpg");
  img = loadImage("stars2.jpg");
  size(1000, 1000, P3D);
  
   cols = w / scl;
   rows = h/ scl;
   terrain = new float[cols][rows];
   float yoff = 0;
   for (int y = 0; y < rows; y++) {
      float xoff =0;
        for (int x = 0; x < cols; x++) {
            terrain[x][y] = map(noise(xoff,yoff),0,1,-50,50);
            xoff+=0.1;
        }
        yoff+=0.1;
    }
 
    println("BUILD",LAB_SIZE);
    labyrinthe = new char[LABS_HEIGHT][LAB_SIZE][LAB_SIZE];
    sides = new char[LABS_HEIGHT][LAB_SIZE][LAB_SIZE][4];
    todig = new int[LABS_HEIGHT];
    laby0 = new PShape[LABS_HEIGHT];
    ceiling0 =new PShape[LABS_HEIGHT];
    ceiling1 =new PShape[LABS_HEIGHT];
    SortiesTabX = new float [LABS_HEIGHT][1];
    SortiesTabY = new float [LABS_HEIGHT][1];
    Hand1 = loadShape("hand1.obj");
    Hand2 = loadShape("hand1.obj");
    
    todig[0] = 0; todig[1] = 0; todig[2] = 0; todig[3] = 0; todig[4] = 0;
    for (int H = 0; H<ETAGES; H++){
      for (int j=0; j<LAB_SIZE; j++) {
        for (int i=0; i<LAB_SIZE; i++) {
          sides[H][j][i][0] = 0;
          sides[H][j][i][1] = 0;
          sides[H][j][i][2] = 0;
          sides[H][j][i][3] = 0;
          if (j%2==1 && i%2==1) {
            labyrinthe[H][j][i] = '.';
            todig[H] = todig[H]+1;
            } else  {
            labyrinthe[H][j][i] = '#';
          }
        } 
      }
      println(LAB_SIZE);
      LAB_SIZE -= 2;
    }
    println("A");
    LAB_SIZE = 21;
    for (int P = 0; P < ETAGES; P++){
      int gx = 1;
      int gy = 1;
      while (todig[P]>0 ) {
        int oldgx = gx;
        int oldgy = gy;
        int alea = floor(random(0, 4)); // selon un tirage aleatoire
        if      (alea==0 && gx>1)          gx -= 2; // le fantome va a gauche
        else if (alea==1 && gy>1)          gy -= 2; // le fantome va en haut
        else if (alea==2 && gx<LAB_SIZE-2) gx += 2; // .. va a droite
        else if (alea==3 && gy<LAB_SIZE-2) gy += 2; // .. va en bas
    
        if (labyrinthe[P][gy][gx] == '.') {
          todig[P] = todig[P]-1;
          labyrinthe[P][gy][gx] = ' ';
          labyrinthe[P][(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
        }
      } 
    }
    
    println("B");
  
    for (int P = 0; P < ETAGES; P++){
       labyrinthe[P][0][1]                   = ' '; // entree
       labyrinthe[P][LAB_SIZE-2][LAB_SIZE-1] = ' '; // sortie 
    }
    
    
    labyrinthe[1][17][0] = ' '; // sortie 
    labyrinthe[2][3][16] = ' '; // sortie 
    labyrinthe[3][14][10] = ' '; // sortie 
    labyrinthe[4][11][0] = ' '; // sortie 
    
    SortiesTabX[0][0] = 21.0;
    SortiesTabY[0][0] = 19.0;
    SortiesTabX[1][0] = -1.0;
    SortiesTabY[1][0] = 17.0;
    SortiesTabX[2][0] = 17.0;
    SortiesTabY[2][0] = 3.0;
    SortiesTabX[3][0] = 10.0;
    SortiesTabY[3][0] = 15.0;
    SortiesTabX[4][0] = -1.0;
    SortiesTabY[4][0] = 11.0;
    
    for (int P = 0; P<ETAGES; P++){
       for (int j=1; j<LAB_SIZE-1; j++) {
          for (int i=1; i<LAB_SIZE-1; i++) {
             if (labyrinthe[P][j][i]==' ') {
                if (labyrinthe[P][j-1][i]=='#' && labyrinthe[P][j+1][i]==' ' && labyrinthe[P][j][i-1]=='#' && labyrinthe[P][j][i+1]=='#')
                    sides[P][j-1][i][0] = 1;// c'est un bout de couloir vers le haut 
                if (labyrinthe[P][j-1][i]==' ' && labyrinthe[P][j+1][i]=='#' && labyrinthe[P][j][i-1]=='#' && labyrinthe[P][j][i+1]=='#')
                    sides[P][j+1][i][3] = 1;// c'est un bout de couloir vers le bas 
                if (labyrinthe[P][j-1][i]=='#' && labyrinthe[P][j+1][i]=='#' && labyrinthe[P][j][i-1]==' ' && labyrinthe[P][j][i+1]=='#')
                    //sides[P][j][i+1+P][1+P] = 1;// c'est un bout de couloir vers la droite
                if (labyrinthe[P][j-1][i]=='#' && labyrinthe[P][j+1][i]=='#' && labyrinthe[P][j][i-1]=='#' && labyrinthe[P][j][i+1]==' ')
                    sides[P][j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
                }
            }
        } 
      LAB_SIZE -= 2;
    }
    
    LAB_SIZE = 21;
  
    // un affichage texte pour vous aider a visualiser le labyrinthe en 2D
    for (int P = 0; P<ETAGES; P++){
      println("Laby Num",P);
        for (int j=0; j<LAB_SIZE; j++) {
            for (int i=0; i<LAB_SIZE; i++) {
                print(labyrinthe[P][j][i]);
            }
        println("");
        } 
      LAB_SIZE -= 2;
    }
    
    LAB_SIZE = 21;
    
    //laby0.stroke(255, 32);
    //laby0.strokeWeight(0.5);
      
    for (int P = 0; P<ETAGES; P++){
      float wallW = width/21;
      float wallH = height/21;
      float AddedHeight = 50*P*2; 
      float AddedX = wallW*P;
      //wallH*2*P
    
      ceiling0[P] = createShape();
      ceiling1[P] = createShape();
      
      ceiling1[P].beginShape(QUADS);
      ceiling0[P].beginShape(QUADS);
      ceiling0[P].texture(texture0);
      ceiling0[P].texture(texture0);
      ceiling1[P].noStroke();
      ceiling0[P].noStroke();
      
      laby0[P] = createShape();
      laby0[P].beginShape(QUADS);
      laby0[P].texture(texture0);
      laby0[P].noStroke();
       for (int j=0; j<LAB_SIZE; j++) {
           for (int i=0; i<LAB_SIZE; i++) {
               if (labyrinthe[P][j][i]=='#') {
                   laby0[P].fill(i*25, j*25, 255-i*10+j*10);
                   if (j==0 || labyrinthe[P][j-1][i]==' ') {
                   laby0[P].normal(0, -1, 0);
                   for (int k=0; k<WALLD; k++)
                       for (float l=-WALLD; l<WALLD; l++) {
      
                           laby0[P].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD + AddedX, j*wallH-wallH/2 + AddedX, (l+0)*50/WALLD + AddedHeight, k/(float)WALLD*texture0.width, (0.5+l/2.0/WALLD)*texture0.height);

                           laby0[P].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD + AddedX, j*wallH-wallH/2 + AddedX, (l+0)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+l/2.0/WALLD)*texture0.height);
                        
                           laby0[P].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD + AddedX, j*wallH-wallH/2 + AddedX, (l+1)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                        
                           laby0[P].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD + AddedX, j*wallH-wallH/2 + AddedX, (l+1)*50/WALLD + AddedHeight, k/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                      }
                   }
    
            if (j==LAB_SIZE-1 || labyrinthe[P][j+1][i]==' ') {
              laby0[P].normal(0, 1, 0);
              for (int k=0; k<WALLD; k++)
                for (float l=-WALLD; l<WALLD; l++) {
                  laby0[P].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD + AddedX, j*wallH+wallH/2 + AddedX, (l+1)*50/WALLD + AddedHeight, (k+0)/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD + AddedX, j*wallH+wallH/2 + AddedX, (l+1)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD + AddedX, j*wallH+wallH/2 + AddedX, (l+0)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+(l+0)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD + AddedX, j*wallH+wallH/2 + AddedX, (l+0)*50/WALLD + AddedHeight, (k+0)/(float)WALLD*texture0.width, (0.5+(l+0)/2.0/WALLD)*texture0.height);
                }
            }
    
            if (i==0 || labyrinthe[P][j][i-1]==' ') {
              laby0[P].normal(-1, 0, 0);
              for (int k=0; k<WALLD; k++)
                for (float l=-WALLD; l<WALLD; l++) {
                  laby0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH-wallH/2+(k+0)*wallW/WALLD + AddedX, (l+1)*50/WALLD + AddedHeight, (k+0)/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH-wallH/2+(k+1)*wallW/WALLD + AddedX, (l+1)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH-wallH/2+(k+1)*wallW/WALLD + AddedX, (l+0)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+(l+0)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH-wallH/2+(k+0)*wallW/WALLD + AddedX, (l+0)*50/WALLD + AddedHeight, (k+0)/(float)WALLD*texture0.width, (0.5+(l+0)/2.0/WALLD)*texture0.height);
                }
            }
    
            if (i==LAB_SIZE-1 || labyrinthe[P][j][i+1]==' ') {
              laby0[P].normal(1, 0, 0);
              for (int k=0; k<WALLD; k++)
                for (float l=-WALLD; l<WALLD; l++) {
                  laby0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH-wallH/2+(k+0)*wallW/WALLD + AddedX, (l+0)*50/WALLD + AddedHeight, (k+0)/(float)WALLD*texture0.width, (0.5+(l+0)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH-wallH/2+(k+1)*wallW/WALLD + AddedX, (l+0)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+(l+0)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH-wallH/2+(k+1)*wallW/WALLD + AddedX, (l+1)*50/WALLD + AddedHeight, (k+1)/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                  laby0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH-wallH/2+(k+0)*wallW/WALLD + AddedX, (l+1)*50/WALLD + AddedHeight, (k+0)/(float)WALLD*texture0.width, (0.5+(l+1)/2.0/WALLD)*texture0.height);
                }
            }
            ceiling1[P].fill(255,0,0);
            ceiling1[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH-wallH/2 + AddedX, 50 + AddedHeight);
            ceiling1[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH-wallH/2 + AddedX, 50 + AddedHeight);
            ceiling1[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH+wallH/2 + AddedX, 50 + AddedHeight);
            ceiling1[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH+wallH/2 + AddedX, 50 + AddedHeight);        
          } else {
            laby0[P].fill(30,30,30); // ground
            laby0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH-wallH/2 + AddedX, -50 + AddedHeight, 0, 0);
            laby0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH-wallH/2 + AddedX, -50 + AddedHeight, 0, 1);
            laby0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH+wallH/2 + AddedX, -50 + AddedHeight, 1, 1);
            laby0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH+wallH/2 + AddedX, -50 + AddedHeight, 1, 0);
            
            ceiling0[P].fill(30,30,30); // top of walls
            ceiling0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH-wallH/2 + AddedX, 50 + AddedHeight);
            ceiling0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH-wallH/2 + AddedX, 50 + AddedHeight);
            ceiling0[P].vertex(i*wallW+wallW/2 + AddedX, j*wallH+wallH/2 + AddedX, 50 + AddedHeight);
            ceiling0[P].vertex(i*wallW-wallW/2 + AddedX, j*wallH+wallH/2 + AddedX, 50 + AddedHeight);
          }
        }
      }
    laby0[P].endShape();
    ceiling0[P].endShape();
    ceiling1[P].endShape(); 
    LAB_SIZE -= 2;
    }
    LAB_SIZE = 21;
}

void draw() {
  //background(0);
  //println(Frames);
  Frames++;
  if (Outside == true) {lights();} else {noLights();}
  background(img);
  sphereDetail(6);
  float AddedX = (width/21)*CurrentLaby;
  LAB_SIZE = 21;
  if (anim>0) anim--;
  float wallW = width/LAB_SIZE;
  float wallH = height/LAB_SIZE;
  float AddedHeight = 50*CurrentLaby*2;
  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  stroke(0);
  
  if (posX == MposX && posY == MposY){println("Killed by the Momie"); exit();}
  
  for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        //println(P,j,i,LAB_SIZE);
          if (labyrinthe[CurrentLaby][j][i]=='#') {
          fill(i*25, j*25, 255-i*10+j*10);
          pushMatrix();
          translate(50+i*wallW/8, 50+j*wallH/8, 50);
          box(wallW/10, wallH/10, 5);
          popMatrix();
          }
      }
  }
  
   pushMatrix();
   strokeWeight(5);
   perspective();
   float siz = 50;
   stroke(255,0,0);
   line(width*0.85,height/2,width*0.85,height/4);
   line(width*0.85+25,height/4+50,width*0.85,height/4);
   line(width*0.85-25,height/4+50,width*0.85,height/4);
   line(width*0.85-25,height/4+50,width*0.85+25,height/4+50);
   stroke(255);
   line(width*0.85+100,height/2 + (height/4-height/2)*0.5, width*0.85-100,height/2 + (height/4-height/2)*0.5);
   noStroke();
   textSize(siz);
   text("Nord", width*0.85-siz - sin(angleB)*height/5.3, height/3+siz - cos(angleB)*height/5.3);
   text("Sud", width*0.85-siz - sin(-angleB)*height/5.3, height/3+siz + cos(angleB)*height/5.3);
   text("Est", width*0.85-siz - sin(angleB-(PI/2))*height/5.3, height/3+siz - cos(angleB-(PI/2))*height/5.3);
   text("Ouest", width*0.85-siz - sin(angleB+(PI/2))*height/5.3, height/3+siz - cos(angleB+(PI/2))*height/5.3);
   strokeWeight(1);
   popMatrix();
 
  pushMatrix();
  fill(0, 255, 0);
  noStroke();
  translate(50+posX*wallW/8, 50+posY*wallH/8, 50);
  sphere(3);
  popMatrix();
  stroke(0);
  //println(5);
  //println(-15+2*sin(anim*PI/5.0) + posZ);
  PVector V0, V1, VN;
  V0 = new PVector(0,0,0);
  V1 = new PVector(0,0,0);
  if (inLab) {
    perspective(2*PI/3, float(width)/float(height), 1, 10000);
    if (animT) {
      camera((posX-dirX*anim/20.0)*wallW + AddedX,      (posY-dirY*anim/20.0)*wallH + AddedX,      -15+2*sin(anim*PI/5.0) + 50*CurrentLaby*2 + posZ, 
             (posX-dirX*anim/20.0+dirX)*wallW + AddedX, (posY-dirY*anim/20.0+dirY)*wallH + AddedX, -15+4*sin(anim*PI/5.0) + 50*CurrentLaby*2 + posZ, 0, 0, -1);
      V0 = new PVector( (posX-dirX*anim/20.0)*wallW , (posY-dirY*anim/20.0)*wallH );
      V1 = new PVector( (posX-dirX*anim/20.0+dirX)*wallW , (posY-dirY*anim/20.0+dirY)*wallH );
    } else if (animR){ 
      camera(posX*wallW + AddedX, posY*wallH + AddedX, -15 + 50*CurrentLaby*2 + posZ, 
            (posX+(odirX*anim+dirX*(20-anim))/20.0)*wallW + AddedX, (posY+(odirY*anim+dirY*(20-anim))/20.0)*wallH + AddedX, -15-5*sin(anim*PI/20.0) + 50*CurrentLaby*2 + posZ, 0, 0, -1);
      V0 = new PVector( posX*wallW, posY*wallH);
      V1 = new PVector( (posX+(odirX*anim+dirX*(20-anim))/20.0)*wallW, (posY+(odirY*anim+dirY*(20-anim))/20.0)*wallH);      
    } else {
      camera(posX*wallW + AddedX, posY*wallH + AddedX, -15 + 50*CurrentLaby*2 + posZ, 
             (posX+dirX)*wallW + AddedX, (posY+dirY)*wallH + AddedX, -15 + 50*CurrentLaby*2 + posZ, 0, 0, -1);
             V0 = new PVector(posX*wallW, posY*wallH);
             V1 = new PVector(posX*wallW, posY*wallH);
    }
    VN = new PVector(0.0,1.0);
    V1 = V1.sub(V0).normalize();
    angleB = PVector.angleBetween(VN,V1);
    if (V1.x < 0){
        angleB = -angleB;
    }
    //camera((posX-dirX*anim/20.0)*wallW, (posY-dirY*anim/20.0)*wallH, -15+6*sin(anim*PI/20.0), 
    //  (posX+dirX-dirX*anim/20.0)*wallW, (posY+dirY-dirY*anim/20.0)*wallH, -15+10*sin(anim*PI/20.0), 0, 0, -1);

    lightFalloff(0.0, 0.01, 0.0001);
    pointLight(255, 255, 255, posX*wallW + AddedX, posY*wallH+ AddedX, 15 + AddedHeight + posZ );
  } else{
    lightFalloff(0.0, 0.05, 0.0001);
    pointLight(255, 255, 255, posX*wallW+ AddedX, posY*wallH+ AddedX, 15 + AddedHeight + posZ);
  }

  noStroke();
  LAB_SIZE = 21;
  for (int P=0; P<ETAGES; P++){
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        pushMatrix();
        translate(i*wallW + AddedX, j*wallH + AddedX, AddedHeight);
        if (labyrinthe[P][j][i]=='#') {
          beginShape(QUADS);
          if (sides[P][j][i][3]==1) {
            pushMatrix();
            translate(0, -wallH/2,40);
            if (i==posX || j==posY) {
              fill(i*25, j*25, 255-i*10+j*10);
              sphere(5);
              lightFalloff(0.0, 0.01, 0.0001);
              if (P == CurrentLaby){ spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);}
            } else {
              fill(128);
              sphere(15);
            }
            popMatrix();
          }
  
          if (sides[P][j][i][0]==1) {
            pushMatrix();
            translate(0, wallH/2, 40);
            if (i==posX || j==posY) {
              fill(i*25, j*25, 255-i*10+j*10);
              sphere(5);              
              //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              lightFalloff(0.0, 0.01, 0.0001);
              if (P == CurrentLaby){ spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);}
            } else {
              fill(128);
              sphere(15);
            }
            popMatrix();
          }
           
           if (sides[P][j][i][1]==1) {
            pushMatrix();
            translate(-wallW/2, 0, 40);
            if (i==posX || j==posY) {
              fill(i*25, j*25, 255-i*10+j*10);
              sphere(5);              
              //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              lightFalloff(0.0, 0.01, 0.0001);
              if (P == CurrentLaby){spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);}
            } else {
              fill(128);
              sphere(15);
            }
            popMatrix();
          }
           
          if (sides[P][j][i][2]==1) {
            pushMatrix();
            translate(0, wallH/2, 40);
            if (i==posX || j==posY) {
              fill(i*25, j*25, 255-i*10+j*10);
              sphere(5);              
              //spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
              lightFalloff(0.0, 0.01, 0.0001);
              if (P == CurrentLaby){ spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);}
            } else {
              fill(128);
              sphere(15);
            }
            popMatrix();
          }
        } 
        popMatrix();
      }
    }  
    LAB_SIZE -= 2;
    shape(laby0[P], 0, 0);
  if (inLab)
    shape(ceiling0[P], 0, 0);
  else
    shape(ceiling1[P], 0, 0); 
  }
    //println(dirX,dirY);
    //noFill();
    pushMatrix();
    translate(MposX*wallW,MposY*wallH,-20);
    if (MdirX == 0.0 && MdirY == 1.0){
        rotateZ(PI); 
    } else if (MdirX == 1.0 && MdirY == 0.0) {
        rotateZ(PI/2); 
    } else if (MdirX == -1.0 && MdirY == 0.0) {
      rotateZ(-PI/2);
    }
    
    //Momie start
    pushMatrix(); 
    float n = 0;
    //stroke(0);
    //strokeWeight(0.5);
    translate(0,0,-30 + MposZ);
    //Torse
    for (int T = 0; T < 10;T++){
        beginShape(QUAD_STRIP );  
        for (int F = 0; F < 12;F++){
          n+=0.1;
          float noise = noise(n);
          fill(140+noise*250,140+noise*250,0+noise*250);
          float XX = cos((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          float YY = sin((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          //println(XX+MposX,YY+MposY,0);
          //println(XX+MposX,YY+MposY,5);
          vertex(XX+MposX,YY+MposY,0+T*3);
          vertex(XX+MposX,YY+MposY,3+T*3);
        }
        endShape();
    }
    float TT = 0.0;
    for (int T = 10; T > 0;T--){
        beginShape(QUAD_STRIP );  
        for (int F = 0; F < 12;F++){
          n+=0.1;
          float noise = noise(n);
          fill(140+noise*250,140+noise*250,0+noise*250);
          float XX = cos((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          float YY = sin((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          //println(XX+MposX,YY+MposY,0);
          //println(XX+MposX,YY+MposY,5);
          vertex(XX+MposX,YY+MposY,0+TT*3+30);
          vertex(XX+MposX,YY+MposY,3+TT*3+30);
        }
        TT++;
        endShape();
    }
    
        //Tête
    translate(0,0,60);
    for (int T = 0; T < 5;T++){
        beginShape(QUAD_STRIP );  
        for (int F = 0; F < 12;F++){
          n+=0.1;
          float noise = noise(n);
          fill(140+noise*250,140+noise*250,0+noise*250);
          float XX = cos((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          float YY = sin((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          //println(XX+MposX,YY+MposY,0);
          //println(XX+MposX,YY+MposY,5);
          vertex(XX+MposX,YY+MposY,0+T*2);
          vertex(XX+MposX,YY+MposY,3+T*2);
        }
        endShape();
    }
    TT = 0.0;
    for (int T = 5; T > 0;T--){
        beginShape(QUAD_STRIP );  
        for (int F = 0; F < 12;F++){
          n+=0.1;
          float noise = noise(n);
          fill(140+noise*250,140+noise*250,0+noise*250);
          float XX = cos((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          float YY = sin((2*PI)/11*F)*(T/1.5+3)*((noise/5)+1);
          //println(XX+MposX,YY+MposY,0);
          //println(XX+MposX,YY+MposY,5);
          vertex(XX+MposX,YY+MposY,0+TT*2+10);
          vertex(XX+MposX,YY+MposY,3+TT*2+10);
        }
        TT++;
        endShape();
    }
    popMatrix();
    fill(255,0,0);
    
    pushMatrix(); 
    fill(255,255,255);
    translate(4,-1.5,40);
    sphere(2);
    translate(0,-1.2,-1);
    fill(0,0,0);
    sphere(1);
    popMatrix();
    
     pushMatrix(); 
    fill(255,255,255);
    translate(-4,-1.5,40);
    sphere(2);
    translate(0,-1.2,-1);
    fill(0,0,0);
    sphere(1);
    popMatrix();
    
    
    translate(0,0,10);
    rotateX(PI/2);
    translate(20,0,0);
    shape(Hand2,0,0);
    translate(-30,0);
    shape(Hand1,0,0);
    //ellipse(0,0, 20, 60);
    //sphere(15);
    popMatrix();
    
    //Momie end
    
    translate(-width + 500,-height,-30);
    //rotateX(PI/3);
    //translate(-w/2,-h/2);
    fill(255, 255, 0);
    for (int y =0; y < rows-1; y++) {
        beginShape(TRIANGLE_STRIP);
        for (int x =0; x < cols; x++) {
            //stroke(255, 255, 0);
            vertex(x*scl, y*scl, terrain[x][y]-30);
            vertex(x*scl, (y+1)*scl,terrain[x][y+1]-30);
        }
        endShape();
    }
    
    if (Frames%30 == 0) {
        //println("Seconde");  
        //MposX++;
        int r = int(random(0,3));
        if (r==0){
            int ran = int(random(0,4)); 
            //println("ran",ran);
            if (ran == 0) {
                MdirX = 0.0;
                MdirY = 1.0;
            } else if (ran == 1) {
                MdirX = 1.0;
                MdirY = 0.0;
            } else if (ran == 2) {
                MdirX = -1.0;
                MdirY = 0.0;
            } else {
                MdirX = 0.0;
                MdirY = -1.0;
            }
        } else if (MposX+MdirX>=0 && MposX+MdirX<21 && MposY+MdirY>=0 && MposY+MdirY<21 &&
          labyrinthe[CurrentLaby][int(MposY+MdirY)][int(MposX+MdirX)]!='#') {
          MposX+=MdirX; 
          MposY+=MdirY; 
        } else {
          int ran = int(random(0,4)); 
          //println("ran",ran);
          if (ran == 0) {
              MdirX = 0.0;
              MdirY = 1.0;
          } else if (ran == 1) {
              MdirX = 1.0;
              MdirY = 0.0;
          } else if (ran == 2) {
              MdirX = -1.0;
              MdirY = 0.0;
          } else {
              MdirX = 0.0;
              MdirY = -1.0;
          }
          //println(MdirX,MdirY);
        }
    }
}
        
void keyPressed() {
  //print(key,keyCode);
  println(dirX,dirY);
  //println(posX+dirX,posY+dirY);
  if (key=='l') inLab = !inLab;
  
  if (anim==0 && keyCode==38) { //up
    if (FreeCam != true){
       if  (posX+dirX ==  SortiesTabX[CurrentLaby][0] && posY+dirY == SortiesTabY[CurrentLaby][0] ) {
            if (CurrentLaby + 1 == ETAGES ){println("GG"); exit();}
            println("SORTIE !!!",posX+dirX,posY+dirY);
            CurrentLaby++;
            MposZ = 50*CurrentLaby*2; 
            MposX = 10;
            MposY = 10;
            posX = 1;
            posY = 0;
            dirX = 0.0;
            dirY = 1.0;
        } else if (posX+dirX>=0 && posX+dirX<21 && posY+dirY>=0 && posY+dirY<21 &&
          labyrinthe[CurrentLaby][int(posY+dirY)][int(posX+dirX)]!='#') {
          posX+=dirX; 
          posY+=dirY;
          anim=20;
          animT = true;
          animR = false;
          Outside = false;
          noLights();
        }
    } else {
        posX+=dirX; 
        posY+=dirY; 
        }
  }
  if (anim==0 && keyCode==40) { //down
     if (FreeCam != true){
       if (labyrinthe[CurrentLaby][int(posY-dirY)][int(posX-dirX)]!='#') {
          posX-=dirX; 
          posY-=dirY; 
        } 
     } else {
        posX-=dirX; 
        posY-=dirY; 
     }
  }
  if (anim==0 && keyCode==37) { //gauche
     if (FreeCam != true){
        odirX = dirX;
        odirY = dirY;
        anim = 20;
        float tmp = dirX; 
        dirX=dirY; 
        dirY=-tmp;
        animT = false;
        animR = true; 
      } else {
          dirX += 1;
      }
  }
  if (anim==0 && keyCode==39) { //droite
    if (FreeCam != true){
      odirX = dirX;
      odirY = dirY;
      anim = 20;
      animT = false;
      animR = true;
      float tmp = dirX; 
      dirX=-dirY; 
      dirY=tmp;
      } else {
          dirX += -1;
      }
  }
  
   if (anim==0 && keyCode==32) { //space
    if (FreeCam == true){
      posZ += 10;
      //posX+=dirX; 
      //posY+=dirY;
    }
  }
  
   if (anim==0 && keyCode==17) { //ctrl
    if (FreeCam == true){
       posZ -= 10;
    }
  }
  //println(dirX,dirY);
}
