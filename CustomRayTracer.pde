//3 dimensional vector
//Stores an XYZ coordinate
static class vec3 {
  public double x;
  public double y;
  public double z;
  public vec3(){ this(0,0,0); }
  public vec3(vec3 v){ this(v.x, v.y, v.z); }
  public vec3(double x, double y, double z){ this.x = x; this.y = y; this.z = z; }
  public double getMagnitude(){ return Math.sqrt(vec3.dotProduct(this, this)); }
  public vec3 getNormal(){ double mag = this.getMagnitude(); return new vec3(this.x/mag, this.y/mag, this.z/mag); }
  public static vec3 reflect(vec3 v1, vec3 n){ return vec3.minus(v1, vec3.times(2*vec3.dotProduct(v1, n), n)); }
  public static vec3 plus (vec3 v1, vec3 v2){ return new vec3(v1.x+v2.x, v1.y+v2.y, v1.z+v2.z); }
  public static vec3 minus(vec3 v1, vec3 v2){ return new vec3(v1.x-v2.x, v1.y-v2.y, v1.z-v2.z); }
  public static vec3 times(double c, vec3 v1){ return new vec3(c*v1.x, c*v1.y, c*v1.z); }
  public static vec3 crossProduct(vec3 v1, vec3 v2){ return new vec3(v1.y*v2.z-v1.z*v2.y, v1.z*v2.x-v1.x*v2.z, v1.x*v2.y-v1.y*v2.x); }
  public static double dotProduct(vec3 v1, vec3 v2){ return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z; }
}

//Light object
//Stores light position, color, and power
class light {
  public vec3 pos;
  public float[] clr;
  public double power;
  public light(vec3 pos, float[] clr, double power){this.pos = pos; this.clr = clr; this.power = power;}
}

//Shape (triangle) object
//Stores three points for triangle, and material properties
//Material properties include diffuse color, specular color, and shininess for lighting
class shape {
  public vec3[] points;
  public float[] diffClr;
  public float[] specClr;
  public double shininess;
  public shape(){this(new vec3(), new vec3(), new vec3());}
  public shape(vec3 p1, vec3 p2, vec3 p3){this(p1,p2,p3,new float[]{1,1,1}, new float[]{1,1,1}, 0);}
  public shape(vec3 p1, vec3 p2, vec3 p3, float[] diffClr, float[] specClr, double shininess){
    this.points = new vec3[] {p1, p2, p3};
    this.diffClr = diffClr;
    this.specClr = specClr;
    this.shininess = shininess;
  }
  public vec3 normalVector(){
    return vec3.crossProduct(vec3.minus(points[0], points[1]), vec3.minus(points[0], points[2])).getNormal();
  }
  public double[] getPlaneEquation(){  //Returns the plane in form ax + by + cz = d
    vec3 normVec = this.normalVector();
    //Formula is normal vector dotted with ((x,y,z) - (a point on the plane))
    double d = vec3.dotProduct(normVec, points[0]);
    //This is the dot product written out
    //double d = normVec.x*shape[0].x + normVec.y*shape[0].y + normVec.z*shape[0].z;
    return new double[] {normVec.x, normVec.y, normVec.z, d};
  }
}


int windowX = 1024;
int numPixelsX = 1024;
vec3 camera = new vec3(0,-10,0);

//Camera Angle
//Pitch, roll, yaw
//Ignoring roll and yaw for now
vec3 camAng = new vec3(0,0,0);

double camSpeed = 0.5;

int phase = 0;

double focalLength = 5;
double imageLength = 10;

double pixelX = windowX/numPixelsX;
double pixelLength = imageLength/numPixelsX;

shape[] shapes = {
  new shape(new vec3(0,32,0), new vec3(32,32,0), new vec3(0,32,32), new float[]{0.9, 0.2, 0.2}, new float[] {1,1,1}, 3),
  new shape(new vec3(40,64,20), new vec3(-80,48,0), new vec3(-32,64,-32), new float[]{0.2, 1, 0.2}, new float[] {1,1,1}, 3),
  new shape(new vec3(40,50,75), new vec3(-80,150,75), new vec3(-32,80,75), new float[]{1, 0, 1}, new float[] {1,1,1}, 2),
  //new shape(new vec3(30,70,50), new vec3(60,30,40), new vec3(32,50,32), new float[]{0,0.2,0.4}, new float[] {0,0.2,0.4}, 5)
};

light[] lights = {
  new light(new vec3(0,0,-10), new float[]{1,1,1}, 1),
  new light(new vec3(0,0,0), new float[]{1,0.2,0.2},0)
};

void setup(){
    size(1024,1024);
    loop();
}

void draw(){
  switch(phase){
    case 0:
      camera.y += 0.5;
      if(camera.y > 100) phase++;
      break;
    case 1:
      camAng.z += 0.05;
      if(camAng.z >= 3.14) phase++;
      break;
    case 2:
      camera.y -= 1.0;
      if(camera.y <= 0) phase++;
      break;
    case 3:
      camAng.z += 0.05;
      if(camAng.z >= 6.28) phase++;
      break;
    case 4:
      camera.z -= 0.5;
      if(camera.z <= -30) phase++;
      break;
    case 5:
      camAng.x += 0.01;
      if(camAng.x >= 0.4) phase++;
      break;
    case 6:
      lights[0].pos.y += 0.5;
      if(lights[0].pos.y > 120) phase++;
      break;
    case 7:
      lights[0].power -= 0.01;
      if(lights[0].power <= -0.2) phase++;
      break;
    case 8:
      lights[1].power += 0.01;
      if(lights[1].power >= 2) phase++;
      break;
    case 9:
      lights[1].clr[1] += 0.01;
      if(lights[1].clr[1] >= 1) phase++;
      break;
    case 10:
      lights[1].clr[2] += 0.01;
      if(lights[1].clr[2] >= 1) phase++;
      break;
    case 11:
      lights[1].power -= 0.03;
      camera.y += Math.cos(camAng.x)*0.8;
      camera.z += Math.sin(camAng.x)*0.8;
      if(lights[1].power < 0) phase++;
      break;
    case 12:
      exit();
      break;
  }
  //camera.y += Math.cos(camAng.x)*camSpeed;
  //camera.z += Math.sin(camAng.x)*camSpeed;
  //lights[0].pos.y += camSpeed;
  noStroke();
  for(int y = 0; y < numPixelsX; y++){
    for(int x = 0; x < numPixelsX; x++){
      float[] clr = new float[3];
      vec3 pixelPos;
      if(phase == 1 || phase==2){
        pixelPos = getImagePixelPosition(x,numPixelsX - y - 1);
      }else{
        pixelPos = getImagePixelPosition(x,y);
      }
      double minDepth = -1;
      for(int i = 0; i < shapes.length; i++){
        double t = getT(shapes[i].getPlaneEquation(), pixelPos);
        vec3 point = tToPoint(t, pixelPos);
        //println("Point:", point.x, point.y, point.z);
        if(pointWithinShape(shapes[i],point) && t > 0){
          if(minDepth < 0 || t < minDepth){
            minDepth = t;
            clr = new float[3];
            for(int j = 0; j < lights.length; j++){
              //Diffuse color   (object color * light color * cosine angle * power)
              double cos = Math.abs(vec3.dotProduct(vec3.minus(lights[j].pos, point).getNormal(), shapes[i].normalVector()));
              clr[0] += (float) (shapes[i].diffClr[0] * lights[j].clr[0] * lights[j].power * cos);
              clr[1] += (float) (shapes[i].diffClr[1] * lights[j].clr[1] * lights[j].power * cos);
              clr[2] += (float) (shapes[i].diffClr[2] * lights[j].clr[2] * lights[j].power * cos);
              
              //Specular (reflection) color   ((reflection (dot) view)^shiny * object spec * light spec)
              cos = vec3.dotProduct(vec3.reflect(vec3.minus(point, lights[j].pos).getNormal(), shapes[i].normalVector()), vec3.minus(camera, point).getNormal());
              if(cos >= 0){
                clr[0] += (pow((float) cos, (float)shapes[i].shininess) * shapes[i].specClr[0] * lights[j].clr[0] * lights[j].power);
                clr[1] += (pow((float) cos, (float)shapes[i].shininess) * shapes[i].specClr[1] * lights[j].clr[1] * lights[j].power);
                clr[2] += (pow((float) cos, (float)shapes[i].shininess) * shapes[i].specClr[2] * lights[j].clr[2] * lights[j].power);
              }
            }
          }
        }
      }
      fill(clr[0]*255, clr[1]*255, clr[2]*255);
      
      square((float) (x*pixelX),(float) (y*pixelX), (float) pixelX);
    }
  }
  saveFrame("ISP-#####.png");
}

boolean pointWithinShape(shape s, vec3 point){
  //Solve system of equations with Cramer's Rule.
  //If a, b, and c coefficients for weighted average are all positive (Barycentric coordinates)
  double d = det(s.points);
  double x = det(new vec3[] {point, s.points[1], s.points[2]})/d;
  double y = det(new vec3[] {s.points[0], point, s.points[2]})/d;
  double z = det(new vec3[] {s.points[0], s.points[1], point})/d;
  //println("Weights:", x, y, z);
  return x >= 0 && y >= 0 && z >= 0;
}

double det(vec3[] v){
  double d = v[0].x*(v[1].y*v[2].z - v[1].z*v[2].y);
  d -= v[1].x*(v[0].y*v[2].z - v[0].z*v[2].y);
  d += v[2].x*(v[0].y*v[1].z - v[0].z*v[1].y);
  return d;
}

double getT(double[] plane, vec3 imagePixelPos){
  double n = (plane[3] - plane[0]*camera.x - plane[1]*camera.y - plane[2]*camera.z);
  double d = (plane[0]*(imagePixelPos.x - camera.x) + plane[1]*(imagePixelPos.y - camera.y) + plane[2]*(imagePixelPos.z - camera.z));
  return n/d;
}

//line equation is R(t) = C*(1-t) + I(t)
//plane equation is ax + by + cz = d
//We need to find a t* to represent the point in R(t) form.
vec3 tToPoint(double t, vec3 imagePixelPos){
  return new vec3(camera.x*(1-t) + imagePixelPos.x*t, camera.y*(1-t) + imagePixelPos.y*t, camera.z*(1-t) + imagePixelPos.z*t);
}

vec3 getImagePixelPosition(int x, int y){
  vec3 pixelPos = new vec3(0, 0, 0);
  pixelPos.x += -(imageLength/2)+x*pixelLength+pixelLength/2;
  pixelPos.y += focalLength;
  pixelPos.z += -(imageLength/2)+y*pixelLength+pixelLength/2;
  
  double theta = camAng.x;
  vec3 k = new vec3(1,0,0);
  //Rotation accounting for pitch
  pixelPos = vec3.plus(
    vec3.times(Math.cos(theta), pixelPos),
    vec3.times(Math.sin(theta), vec3.crossProduct(k, pixelPos)));
  pixelPos.x += pixelPos.x*(1-Math.cos(theta));
  
  theta = camAng.z;
  k = new vec3(0,0,1);
  //Rotation accounting for pitch
  pixelPos = vec3.plus(
    vec3.times(Math.cos(theta), pixelPos),
    vec3.times(Math.sin(theta), vec3.crossProduct(k, pixelPos)));
  pixelPos.z += pixelPos.z*(1-Math.cos(theta));
  
  pixelPos = vec3.plus(pixelPos, camera);
  //println("x, y", x, y);
  //println("3D trans", pixelPos.x, pixelPos.y, pixelPos.z);
  return pixelPos;
}
