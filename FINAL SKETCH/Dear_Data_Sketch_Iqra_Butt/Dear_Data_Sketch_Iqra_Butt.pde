String[] dearData;
String[][] data;

//Array of each specific category
ArrayList<String> daysOfWeek;
ArrayList<String> drinkTypes;
ArrayList<String> times;
ArrayList<String> reasons;
ArrayList<String> whoMades;

int flowerIndex = 0; // To keep track of which flower to draw next

ArrayList<Flower> flowers;

int getColorForDay(String day) {
  int red = 255; 
  int green = 80;
  int blue = 150;  

  //The redness of the flower will grow depending on the day of the week
  if (day.equals("Monday")) {
    red = 230; // Lighter pink for Monday
  } else if (day.equals("Tuesday")) {
    red = 210; 
  } else if (day.equals("Wednesday")) {
    red = 190; // Mid pink for Wednesday
  } else if (day.equals("Thursday")) {
    red = 170; 
  } else if (day.equals("Friday")) {
    red = 150; 
  } else if (day.equals("Saturday")) {
    red = 130; 
  } else if (day.equals("Sunday")) {
    red = 110; // Darkest pink for Sunday
  }

  // Create a pink color using rgb values for each day
  return color(red, green, blue);
}

void setup() {
  size(800, 800);
  background(255);

  
  dearData = loadStrings("deardata.csv");

  // Initialize the 2D data array to store each line's data
  data = new String[dearData.length][];

  //Initialising each of the arrays
  daysOfWeek = new ArrayList<String>();
  drinkTypes = new ArrayList<String>();
  times = new ArrayList<String>();
  reasons= new ArrayList<String>();
  whoMades = new ArrayList<String>();

 
  flowers = new ArrayList<Flower>();

  for (int i = 0; i < dearData.length; i++) {
    String[] eachDataItems = split(dearData[i], ",");
    
    data[i] = new String[eachDataItems.length];
    
    for (int d = 0; d < eachDataItems.length; d++) {
      data[i][d] = eachDataItems[d]; 

      // Check if we have the correct 5 number of columns 
      if (eachDataItems.length >= 5) {
        if (d == 0) {
          daysOfWeek.add(eachDataItems[d]);   
        } else if (d == 1) {
          drinkTypes.add(eachDataItems[d]);   
        } else if (d == 2) {
          times.add(eachDataItems[d]);       
        } else if (d == 3) {
          reasons.add(eachDataItems[d]);      
        } else if (d == 4) {
          whoMades.add(eachDataItems[d]);     
        }
      }
    }
  }

}

void drawFlower(float x, float y, float flowerSize, int petals, String day, boolean rotateFlower) {
  int flowerColor = getColorForDay(day); // Get color based on day of the week
  strokeWeight(flowerSize);
  stroke(flowerColor);
  pushMatrix();
  translate(x, y);
  if (rotateFlower) {
    rotate(frameCount * 0.05); 
  }

  for (int i = 0; i < petals; i++) {
    rotate(TWO_PI / petals);
    line(0, 0, 3 * flowerSize, 0);
  }
  fill(flowerColor);
  ellipse(0, 0, 1.5 * flowerSize, 1.5 * flowerSize);
  popMatrix();
}

void draw() {
  background(255);

  // Loop through the flowers array and draw the flowers
  for (Flower f : flowers) {
    f.display();
  }

  // Show information about the data when the mouse is hovering over a flower
  for (Flower f : flowers) {
    if (dist(mouseX, mouseY, f.x, f.y) < f.size * 2) {
      String info = "Day: " + f.day + "\nTime: " + times.get(flowers.indexOf(f)) + "\nDrink: " + drinkTypes.get(flowers.indexOf(f));
      fill(0);
      text(info, mouseX + 10, mouseY + 10); // Display the info near the cursor
    }
  }
}

void keyPressed() {
  if (flowerIndex < daysOfWeek.size()) {
    // Get the day for the current flower
    String day = daysOfWeek.get(flowerIndex);

    // flower size will vary depending on the drink type
    float flowerSize = 5; // Default size will visually represent the names of the columns
    if (flowerIndex < drinkTypes.size()) {
      String drinkType = drinkTypes.get(flowerIndex);
      if (drinkType.equalsIgnoreCase("Tea")) {
        flowerSize = 40; 
      } else if (drinkType.equalsIgnoreCase("Hot chocolate")) {
        flowerSize = 20;  
      } else if (drinkType.equalsIgnoreCase("Green tea")) {
        flowerSize = 10;
      }
    }

    // Map the time to the number of petals
    int petals = 0;  // Default number of petals
    if (flowerIndex < times.size()) {
      String timeStr = times.get(flowerIndex);
      if (timeStr.length() == 4) {
        int hour = int(timeStr.substring(0, 2)); 
        petals = hour; 
      }
    }

    //The flower will rotate if the answer to who made it = myself
    boolean rotateFlower = false; //set a false flag
    if (flowerIndex < whoMades.size()) {
      String whoMade = whoMades.get(flowerIndex);
      if (whoMade.equalsIgnoreCase("Myself")) {
        rotateFlower = true;  // Rotate the flower if the answer is "Myself"
      }
    }

    float xPos = random(width);
    float yPos = random(height);
    float flowerRadius = flowerSize * 2;
    xPos = constrain(xPos, flowerRadius, width - flowerRadius); 
    yPos = constrain(yPos, flowerRadius, height - flowerRadius); 

    // Add a new flower to the list 
    flowers.add(new Flower(xPos, yPos, flowerSize, petals, day, rotateFlower));
    // Increment the flowerIndex to move to the next flower
    flowerIndex++;
  }
}


class Flower {
  float x, y; 
  float size;
  int petals; 
  String day; 
  boolean rotateFlower; 

  Flower(float x, float y, float size, int petals, String day, boolean rotateFlower) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.petals = petals;
    this.day = day;
    this.rotateFlower = rotateFlower;
  }

  // Display the flower which will call the drawFlower method
  void display() {
    drawFlower(x, y, size, petals, day, rotateFlower);
  }
}
