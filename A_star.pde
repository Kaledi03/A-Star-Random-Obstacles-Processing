int l = 20, h, w, goal_x, goal_y; //<>//

ArrayList<Node> open_set = new ArrayList<>();
ArrayList<Node> closed_set = new ArrayList<>();
ArrayList<Node> path = new ArrayList<>();
int[][] obstacles;

Node start;
Node goal;
Node[][] nodes;


boolean serachingStarted = false;

/**
*  The Node class rappresents the basic square from each the grid is
*  displayed on the screen. The attributes are: 'x' and 'y' that are
*  the coordinates of the square that implements the class, 'g' rappresents
*  the steps so far(with each square worth one step), 'h' rappresents the
*  hueristics of the square (the 'manhattan'/'taxi cab' distance from the 
*  destination and 'f' is the sum of 'g' and 'h'
*/
class Node{
  int x,y,h,f,g=Integer.MAX_VALUE;
  Node cameFrom;
  ArrayList<Node> neighbors;
  
  public Node (int x, int y, Node cameFrom) {
    this.x = x;
    this.y = y;
    this.cameFrom = cameFrom;
    neighbors = new ArrayList<>();
  }
  
  @Override
  public boolean equals (Object o){
    if (o == this) {
      return true;
    }
    
    if (!(o instanceof Node)) {
      return false;
    }
    
    Node node = (Node)o;
    return (this.x == node.x && this.y == node.y);
  }
}

/**
*  The 'setup' function populates the two dimensional array of nodes and 
*  randomly assigns a value to the obstacles 2D array, a value of 1 (with
*  a 25% probability) rappresents an obstacle while the valueo of 0 rappresents
*  a normal block; then the programm assigns the reference to the instance of
*  all the neighbors.
*/
void setup() {
  // SIZE OF THE SCREEN
  size(800, 600);

  goal_x = (int)random((width/l)-1);
  goal_y = (int)random((height/l)-1);

  nodes = new Node[height/l][width/l];
  h = height/l;
  w = width/l;
  obstacles = new int[h][w];
  
  
  for (int i=0; i<h; i++) {
    for (int j=0; j<w; j++) {
      nodes[i][j] = new Node(i, j, null);
      
      fill(240, 240, 240);
      strokeWeight(1);
      stroke(95, 176, 184);
      
      if (i == 0 && j == 0) {
        start = nodes[i][j];
        start.g = 0;
      }
      if (i==goal_y && j==goal_x) {
        goal = nodes[i][j];
        goal.g = Integer.MAX_VALUE;
      }
      //random(1)<=0.25
      if (random(1)<=0.25 && nodes[i][j] != start && nodes[i][j] != goal) {
        obstacles[i][j] = 1;
      } else {
        obstacles[i][j] = 0;
      }
      
      square(i*l, j*l, l);
    }  
  }
  
  for (int i=0; i<h; i++) {
    for (int j=0; j<w; j++) {
      if (nodes[i][j].x > 0 && obstacles[i][j] == 0) {
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x-1][nodes[i][j].y]);
      }
      if (nodes[i][j].x < (height/l)-1 && obstacles[i][j] == 0) {
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x+1][nodes[i][j].y]);
      }
      if (nodes[i][j].y > 0 && obstacles[i][j] == 0) {
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x][nodes[i][j].y-1]);
      }
      if (nodes[i][j].y < (width/l)-1 && obstacles[i][j] == 0) {
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x][nodes[i][j].y+1]);
      }
    }  
  }
}





/**
*  The 'draw' function (only the first time) starts another thread where
*  the 'Astar' function will execute then at each frame the function draws
*  the path via a call to 'display_path'.
*/
void draw(){
  if(!serachingStarted){
    thread("Astar");
    serachingStarted = true;
  }
  display_path();
  
}




/**
*  Implementation of the A*Pathfinding algorithm according to the pseudocode
*  on wikipedia.org ----> https://en.wikipedia.org/wiki/A*_search_algorithm
*/
void Astar() {
  open_set.add(start);
  while (!open_set.isEmpty()) {
    delay(4);
    int lowest = Integer.MAX_VALUE;
    Node current = null;
    for (Node e : open_set){
      if(e.f < lowest){
        current = e;
        lowest = current.f;
      }
    }
    
    create_path(current);
    
    open_set.remove(current);
    closed_set.add(current);
    
    if(current.equals(goal)){
      create_path(current);
      print("Found");
      return;
    }
    
    for (Node n : current.neighbors) {
      int temp_g = current.g + 1;
      if (temp_g < n.g) {
        if (!closed_set.contains(n)) { 
          n.cameFrom = current;
          n.g = temp_g;
          n.f = n.g + distance(n, goal);
          if (!open_set.contains(n)) {
            open_set.add(n);
          }
        } //<>//
      }
    }
  } 
  print("No solution");
}


/**
*  By going backwards the function retreaves the shortest path to the destination
*  and stores this path in the 'path' arrayList.
*/
void create_path(Node origin) {
  path = new ArrayList<>();
  while (origin.cameFrom != null) {
    path.add(origin);
    origin = origin.cameFrom;
  }
}


/**
*  'display_path' iterates for each square on the display and draws it according to
*  the legend of colors below. 
*/
void display_path(){
  for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
        
       fill(240, 240, 240);
       strokeWeight(1);
       stroke(95, 176, 184);
       
       if (open_set.contains(nodes[i][j])) {
         fill(0, 128, 255);
       }
        
       if (closed_set.contains(nodes[i][j])) {
         fill(0, 195, 255);
       }
       
       if (path.contains(nodes[i][j])) {
         fill(153, 255, 0);
       }
       
       if (obstacles[i][j] == 1) {
         fill(30, 30, 30);
         noStroke();
       }
       square(j*l, i*l, l);
      }  
    }
}


/**
*  With two arguments 'a' and 'b' the function calculates the Manhattan distance
*  between the two points
*/
int distance(Node a, Node b){
  int return_value = 0;
  return_value += (int)Math.abs(a.x-b.x);
  return_value += (int)Math.abs(a.y-b.y);
  return return_value;
}




/**
*  Legend of colors:
*
*  fill(240, 240, 240) ---> Normal element
*  fill(0, 128, 255)   ---> Element contained in the open_set (element still used by the code)
*  fill(0, 195, 255)   ---> Element contained in the closed_set
*  fill(153, 255, 0)   ---> One of the element of the path at the time of displaying
*  fill(30, 30, 30)    ---> An obstacle
*/
