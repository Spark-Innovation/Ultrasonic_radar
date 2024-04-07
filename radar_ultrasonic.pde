import processing.serial.*;

Serial myPort; // Serial object
String angle = "";
String distance = "";
int iAngle, iDistance;
int updateInterval = 20; // Increase the interval for smoother rotation
long lastUpdate = 0;

void setup() {
  size(1200, 700);
  smooth();
  myPort = new Serial(this, "COM6", 9600);
  myPort.bufferUntil('.'); // Read data up to '.'
}

void draw() {
  background(0);
  updateData(); // Update angle data

  fill(98, 245, 31);
  noStroke();
  fill(0, 4); 
  rect(0, 0, width, height - height * 0.065); 

  fill(98, 245, 31);
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void updateData() {
  if (millis() - lastUpdate > updateInterval) {
    if (iAngle < 180) {
      iAngle++; // Increment angle
    } else {
      iAngle = 0; // Reset angle when reaching 180
    }
    lastUpdate = millis(); // Update last update time
  }
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('.');
  if (data != null) {
    data = data.trim(); // Remove leading/trailing whitespace
    println("Received data: " + data); // Debug statement
    String[] parts = data.split(",");
    if (parts.length == 2) {
      angle = parts[0].trim();
      distance = parts[1].trim();
      println("Parsed angle: " + angle + ", Parsed distance: " + distance); // Debug statement
      iAngle = int(angle);
      iDistance = int(distance);
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  // Draws the arc lines
  for (int i = 1; i <= 4; i++) {
    arc(0, 0, (width - width * (i * 0.192)), (width - width * (i * 0.192)), PI, TWO_PI);
  }
  // Draws the angle lines
  for (int j = 30; j <= 180; j += 30) { // Extend angle lines up to 180 degrees
    line(0, 0, (width / 2) * cos(radians(j)), -(width / 2) * sin(radians(j)));
  }
  popMatrix();
}

void drawObject() {
  if (iDistance < 40) {
    pushMatrix();
    translate(width / 2, height - height * 0.074);
    strokeWeight(9);
    stroke(255, 10, 10); // Red color
    float pixsDistance = iDistance * ((height - height * 0.1666) * 0.025);
    // Draw the object according to the angle and the distance
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
    popMatrix();
  }
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074);
  // Draw the line indicating the angle of the detected object
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  pushMatrix();
  String noObject = (iDistance > 40) ? "Out of Range" : "In Range";
  fill(255); // White color
  textSize(25);
  textAlign(LEFT);
  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);
  textSize(40);
  textAlign(CENTER);
  text("Spark Innovation", width / 2, height - height * 0.0277);
  fill(98, 245, 60);
  
  // Position the angle text on the left side
  textAlign(LEFT);
  text("Angle: " + iAngle, width * 0.05, height - height * 0.0277);
  
  // Position the distance text on the right side
  textAlign(RIGHT);
  text("Distance: " + iDistance + " cm", width - width * 0.05, height - height * 0.0277);
  
  textSize(25);
  
  // Draw angle labels
  translate((width - width * 0.4994) + width / 2 * cos(radians(30)), (height - height * 0.0907) - width / 2 * sin(radians(30)));
  rotate(-radians(-60));
  text("30", 0, 0);
  resetMatrix();
  translate((width - width * 0.503) + width / 2 * cos(radians(60)), (height - height * 0.0888) - width / 2 * sin(radians(60)));
  rotate(-radians(-30));
  text("60", 0, 0);
  resetMatrix();
  translate((width - width * 0.507) + width / 2 * cos(radians(90)), (height - height * 0.0833) - width / 2 * sin(radians(90)));
  rotate(radians(0));
  text("90", 0, 0);
  resetMatrix();
  translate(width - width * 0.513 + width / 2 * cos(radians(120)), (height - height * 0.07129) - width / 2 * sin(radians(120)));
  rotate(radians(-30));
  text("120", 0, 0);
  resetMatrix();
  translate((width - width * 0.5104) + width / 2 * cos(radians(150)), (height - height * 0.0574) - width / 2 * sin(radians(150)));
  rotate(radians(-60));
  text("150", 0, 0);
  popMatrix();
}
