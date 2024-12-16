String[] dearData;
String[][] data;

// Arrays to store specific columns of data
ArrayList<String> daysOfWeek;
ArrayList<String> drinkTypes;
ArrayList<String> times;
ArrayList<String> reasons;
ArrayList<String> whoMades;

int flowerIndex = 0; // To keep track of which flower to draw next

// Array to store flower properties
ArrayList<Flower> flowers;

int getColorForDay(String day) {
  int red = 255;  // Maximum red for lighter colors
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

  // Loading the data file
  dearData = loadStrings("deardata.csv");

  // Initialize the 2D data array to store each line's data
  data = new String[dearData.length][];

  // Initialize the ArrayLists to store each column
  daysOfWeek = new ArrayList<String>();
  drinkTypes = new ArrayList<String>();
  times = new ArrayList<String>();
  reasons= new ArrayList<String>();
  whoMades = new ArrayList<String>();

  // Initialize the flower list
  flowers = new ArrayList<Flower>();

  // Loop through each line of the data file and Split each line by commas
  for (int i = 0; i < dearData.length; i++) {
    String[] eachDataItems = split(dearData[i], ",");

    // Store the split data into the 2D array
    data[i] = new String[eachDataItems.length];

    // Loop through each individual item in the current line and Store in the data array
    for (int d = 0; d < eachDataItems.length; d++) {
      data[i][d] = eachDataItems[d]; 

      // Check if we have the correct 5 number of columns 
      if (eachDataItems.length >= 5) {
        if (d == 0) {
          daysOfWeek.add(eachDataItems[d]);   // Day of the week (1st column)
        } else if (d == 1) {
          drinkTypes.add(eachDataItems[d]);   // Drink type (2nd column)
        } else if (d == 2) {
          times.add(eachDataItems[d]);        // Time (3rd column)
        } else if (d == 3) {
          reasons.add(eachDataItems[d]);      // Reason (4th column)
        } else if (d == 4) {
          whoMades.add(eachDataItems[d]);     // Who made it (5th column)
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
  
  
  // Rotate the flower continuously if it's "Myself"
  if (rotateFlower) {
    rotate(frameCount * 0.05); // Rotate the flower continuously if it's "Myself"
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

  // Display information about data when the mouse is hovering over a flower
  for (Flower f : flowers) {
    if (dist(mouseX, mouseY, f.x, f.y) < f.size * 2) {
      String info = "Day: " + f.day + "\nTime: " + times.get(flowers.indexOf(f)) + "\nDrink: " + drinkTypes.get(flowers.indexOf(f));
      fill(0);
      text(info, mouseX + 10, mouseY + 10); // Display the info near the cursor
    }
  }
}

//Will execute when any key is pressed
void keyPressed() {
  if (flowerIndex < daysOfWeek.size()) {
    // Get the day for the current flower
    String day = daysOfWeek.get(flowerIndex);

    // Setting the flower size based on the drink type
    float flowerSize = 5; // Default size will represent the names of the columns
    if (flowerIndex < drinkTypes.size()) {
      String drinkType = drinkTypes.get(flowerIndex);

      // Check the drink type and set the flower size accordingly
      if (drinkType.equalsIgnoreCase("Tea")) {
        flowerSize = 40;  // Big size for Tea
      } else if (drinkType.equalsIgnoreCase("Hot chocolate")) {
        flowerSize = 20;   // Medium size for Hot chocolate
      } else if (drinkType.equalsIgnoreCase("Green tea")) {
        flowerSize = 10;   // Small size for Green tea
      }
    }

    // Map the time to the number of petals
    int petals = 0;  // Default number of petals
    if (flowerIndex < times.size()) {
      String timeStr = times.get(flowerIndex);
      if (timeStr.length() == 4) {
        int hour = int(timeStr.substring(0, 2));  // Extract hour from time
        petals = hour;  // Set petals equal to the hour (1-12)
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

    //flowers stay fully within the window bounds
    float xPos = random(width);
    float yPos = random(height);

    //flower radius will be center + petals
    float flowerRadius = flowerSize * 2;

    // Constrain the position based on the flower's full radius to ensure flower center stays within window
    xPos = constrain(xPos, flowerRadius, width - flowerRadius); 
    yPos = constrain(yPos, flowerRadius, height - flowerRadius); 

    // Add a new flower to the list 
    flowers.add(new Flower(xPos, yPos, flowerSize, petals, day, rotateFlower));

    // Increment the flowerIndex to move to the next flower
    flowerIndex++;
  }
}


class Flower {
  float x, y; // Position of the flower
  float size; // Size of the flower
  int petals; // Number of petals
  String day; // Day of the week
  boolean rotateFlower; // Whether the flower should rotate

  //Constructor method
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
