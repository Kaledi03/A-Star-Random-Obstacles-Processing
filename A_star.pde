int l = 30;
int h;
int w;
ArrayList<Node> openSet = new ArrayList<>();
ArrayList<Node> closedSet = new ArrayList<>();
ArrayList<Node> path = new ArrayList<>();
Node start;
Node goal;
//print(height);
Node[][] nodes = new Node[600/l][900/l];
int[][] obstacles;


class Node{
  int x,y,h,f,g=Integer.MAX_VALUE;
  Node cameFrom;
  ArrayList<Node> neighbors;
  
  public Node(int x, int y, Node cameFrom){
    this.x = x;
    this.y = y;
    this.cameFrom = cameFrom;
    neighbors = new ArrayList<>();
  }
  
  @Override
  public boolean equals(Object o){
    if(o == this){
      return true;
    }
    if(!(o instanceof Node)){
      return false;
    }
    
    Node node = (Node)o;
    return (this.x == node.x && this.y == node.y);
  }
}

void setup(){
  size(900, 600);
  h = height/l;
  w = width/l;
  obstacles = new int[h][w];
  for(int i=0; i<h; i++){
    for(int j=0; j<w; j++){
      fill(255);
      nodes[i][j] = new Node(i, j, null);
      if(i == 0 && j == 0){
        start = nodes[i][j];
        start.g = 0;
      }
      if(i==8 && j==29){
        goal = nodes[i][j];
        goal.g = Integer.MAX_VALUE;
      }
      if(random(1)<=0.15){
        obstacles[i][j] = 1;
      }
      else{
        obstacles[i][j] = 0;
      }
      
      square(i*l, j*l, l);
    }  
  }
  for(int i=0; i<h; i++){
    for(int j=0; j<w; j++){
      if(nodes[i][j].x > 0 && obstacles[i][j] == 0){
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x-1][nodes[i][j].y]);
      }
      if(nodes[i][j].x < (height/l)-1 && obstacles[i][j] == 0){
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x+1][nodes[i][j].y]);
      }
      if(nodes[i][j].y > 0 && obstacles[i][j] == 0){
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x][nodes[i][j].y-1]);
      }
      if(nodes[i][j].y < (width/l)-1 && obstacles[i][j] == 0){
        nodes[i][j].neighbors.add(nodes[nodes[i][j].x][nodes[i][j].y+1]);
      }
    }  
  }
  Astar(); 
}

void draw(){
for(int i=0; i<h; i++){
  for(int j=0; j<w; j++){
    fill(255);
    if(openSet.contains(nodes[i][j])){
      fill(0,255,0);
    }
          
    if(closedSet.contains(nodes[i][j])){
      fill(255,0,0);
    }
        
    if(path.contains(nodes[i][j])){
      fill(0,0,255);
    }
       
    if(obstacles[i][j] == 1){
      fill(0);
    }
        
    square(j*l, i*l, l);
  }  
} //<>// //<>// //<>// //<>//
}

void Astar(){
  
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
  while (!openSet.isEmpty()){
     for(int i=0; i<h; i++){
       for(int j=0; j<w; j++){
        fill(255);
        if(openSet.contains(nodes[i][j])){
          fill(0,255,0);
        }
          
        if(closedSet.contains(nodes[i][j])){
          fill(255,0,0);
        }
        
        if(path.contains(nodes[i][j])){
          fill(0,0,255);
        }
        
        if(obstacles[i][j] == 1){
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
      print("Trovato");
      printPath(current);
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


void printPath(Node origin){
  while(origin.cameFrom != null){
    path.add(origin);
    origin = origin.cameFrom;
  }
}

int distance(Node a, Node b){
  int return_value = 0;
  return_value += (int)Math.abs(a.x-b.x);
  return_value += (int)Math.abs(a.y-b.y);
  return return_value;
}
