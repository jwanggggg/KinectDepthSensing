import KinectPV2.*;
import gab.opencv.*;
import controlP5.*; // ControlP5 library for slider value
import processing.net.*;
import java.awt.*;

OpenCV opencv;
KinectPV2 kinect;
ControlP5 cp5;

PImage camCapture;

int slider = 40;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

int kinectHighThresh = 1600;
int kinectLowThresh = 60;

void setup() {
  size(1200, 424);
  // Slider for threshold
  cp5 = new ControlP5(this);
  cp5.addSlider("slider").setPosition(750,400).setRange(0,255);
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true); // Enable depth sensing
  kinect.enableInfraredImg(true); // Enable infrared imagery
  kinect.enablePointCloud(true); // Enable point cloud
    
  kinect.init();
}

void draw() {  
  background(0);
  
  // Set the threshold of the kinect sensor to be higher. This allows it to see the floor pixels
  kinect.setLowThresholdPC(kinectLowThresh); 
  kinect.setHighThresholdPC(kinectHighThresh);
  
  PImage myImage = kinect.getDepthImage();
  camCapture = kinect.getPointCloudDepthImage();
  
  opencv = new OpenCV(this, myImage);
  
  opencv.loadImage(camCapture);
  opencv.threshold(slider);
  //opencv.invert(); // Change to background black/foreground white
  
  contours = opencv.findContours();
  
  image(opencv.getSnapshot(), 0, 0);   
  
  noFill();  
  
   //Contour objects in the depth image
  
  for (Contour contour : contours) { // Draw contours around objects
    contour.setPolygonApproximationFactor(1);
    if (contour.numPoints() > 50) {
      Rectangle box = contour.getBoundingBox();
      if (box.width > 20 && box.height > 20) {
        
        ellipse(box.x * 1.5, box.y * 1.5, box.width *1.5, box.height * 1.5);
      }
      
      stroke(0, 255, 0);
      contour.draw();  
      for (PVector point : contour.getPolygonApproximation ().getPoints()){
        vertex(point.x, point.y);
      } 
    }
  } 
  
}
