int l = 50;
int h;
int w;

ArrayList<Node> openSet = new ArrayList<>();
ArrayList<Node> closedSet = new ArrayList<>();
ArrayList<Node> path = new ArrayList<>();
int[][] obstacles;

Node start;
Node goal;
Node[][] nodes;

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
*  a 10% probability) rappresents an obstacle while the valueo of 0 rappresents
*  a normal block; then the programm assigns the reference to the instance of
*  all the neighbors. In the end there is a call to the 'Astar' function that
*  will operate the pathfinding
*/
void setup() {
  // SIZE OF THE SCREEN
  size(700, 600);

  nodes = new Node[height/l][width/l];
  h = height/l;
  w = width/l;
  obstacles = new int[h][w];
  
  
  for (int i=0; i<h; i++) {
    for (int j=0; j<w; j++) {
      nodes[i][j] = new Node(i, j, null);
      
      fill(255);
      if (i == 0 && j == 0) {
        start = nodes[i][j];
        start.g = 0;
      }
      if (i==4 && j==3) {
        goal = nodes[i][j];
        goal.g = Integer.MAX_VALUE;
      }
      if (random(1)<=0.1) {
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
  
  Astar(); 
}

/**
*  The draw function displays on the screen the squares where the white is
*  the base one, the red is the one contained in the 'closedSet', the 
*  green is the on that's contained in the 'opensSet' and the blue rappresents
*  the fastest path according to the algorythm.
*/
void draw(){
  for (int i=0; i<h; i++) {
    for (int j=0; j<w; j++) {
      fill(255);
      if (openSet.contains(nodes[i][j])) {
        fill(0,255,0);
      }
            
      if (closedSet.contains(nodes[i][j])) {
        fill(255,0,0);
      }
          
      if (path.contains(nodes[i][j])) {
        fill(0,0,255);
      }
         
      if (obstacles[i][j] == 1) {
        fill(0);
      }
          
      square(j*l, i*l, l);
    }  
  }  //<>//
}


/**
*  Implementation of the A*Pathfinding algorithm according to the pseudocode
*  on wikipedia.org ----> https://en.wikipedia.org/wiki/A*_search_algorithm
*/
void Astar() {
  for(int i=0; i<h; i++){
    for(int j=0; j<w; j++){
      fill(255);
      for(Node e : openSet){
        if(e.x == i && e.y == j){
          fill(0,255,0);
        } 
      }
      for(Node e : closedSet){
        if(e.x == i && e.y == j){
          fill(255,0,0);
        } 
      }
      square(j*l, i*l, l);
    }  
  }
  
  openSet.add(start);
  while (!openSet.isEmpty()) {
    for (int i=0; i<h; i++) {
      for (int j=0; j<w; j++) {
       fill(255);
       if (openSet.contains(nodes[i][j])) {
         fill(0,255,0);
       }
        
       if (closedSet.contains(nodes[i][j])) {
         fill(255,0,0);
       }
       
       if (path.contains(nodes[i][j])) {
         fill(0,0,255);
       }
       
       if (obstacles[i][j] == 1) {
         fill(0);
       }
      
       square(j*l, i*l, l);
      }  
    }
    int lowest = Integer.MAX_VALUE;
    Node current = null;
    for (Node e : openSet){
      if(e.f < lowest){
        current = e;
        lowest = current.f;
      }
    }
    
    openSet.remove(current);
    closedSet.add(current);
    
    if(current.equals(goal)){
      createPath(current);
      return;
    }
    
    for(Node n : current.neighbors){
      int temp_g = current.g + 1;
      if(temp_g < n.g){
        if(!closedSet.contains(n)){
          n.cameFrom = current;
          n.g = temp_g;
          n.f = n.g + distance(n, goal);
          if(!openSet.contains(n)){
            openSet.add(n);
          }
        }
      }
    }
  } 
}


/**
*  By going backwards the function retreaves the shortest path to the destination
*  and stores this path in the 'path' arrayList.
*/
void createPath(Node origin){
  while(origin.cameFrom != null){
    path.add(origin);
    origin = origin.cameFrom;
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
