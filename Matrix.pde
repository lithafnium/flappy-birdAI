class Matrix {
  int rows; 
  int cols; 
  float[][] data; 

  public Matrix(int rows, int cols) {
    this.rows = rows; 
    this.cols = cols; 
    this.data = new float[rows][cols];
  }

  Matrix clone() {
    Matrix m = new Matrix(this.rows, this.cols); 
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        m.data[i][j] = this.data[i][j];
      }
    }
    return m;
  }

  Matrix fromArray(float[] arr) {
    Matrix m = new Matrix(arr.length, 1); 
    for (int i = 0; i < arr.length; i++) {
      m.data[i][0] = arr[i];
    }

    return m;
  }
  Matrix subtract(Matrix a, Matrix b) {
    if (a.rows != b.rows || a.cols != b.cols) {
      println("Columns and Rows of A must match Columns and Rows of B."); 
      return null;
    }
    Matrix m = new Matrix(a.rows, a.cols); 
    for (int i = 0; i < a.data.length; i++) {
      for (int j = 0; j < a.data[0].length; j++) {
        m.data[i][j] = a.data[i][j] - b.data[i][j];
      }
    }
    return m;
  }

  float[] toArray() {
    float[] ret = new float[rows * cols]; 
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j< this.cols; j++) {
        ret[i * cols + j] = this.data[i][j];
      }
    }
    return ret;
  }

  Matrix randomize() {
    Matrix m = new Matrix(this.rows, this.cols); 
    for (int i= 0; i < this.rows; i++) {
      for (int j= 0; j <  this.cols; j++) {
        m.data[i][j] = random(-1, 1);
      }
    }
    return m;
  }
  
  void add(int n){
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        this.data[i][j] += n;
      }
    }
  }
  
  Matrix add(Matrix n) {


    if (this.rows != n.rows || this.cols != n.cols) {
      println("Column and Rows of A must match Columns and Rows of B"); 
      return null;
    }

    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        this.data[i][j] += n.data[i][j];
      }
    }
    return this;
  }

  Matrix transpose(Matrix n) {
    Matrix ret =  new Matrix(n.cols, n.rows); 
    for (int i = 0; i < n.cols; i++) {
      for (int j = 0; j < n.rows; j++) {
        ret.data[i][j] = n.data[j][i];
      }
    }
    return ret;
  }
  
  Matrix multiply(Matrix a, Matrix b) {
    if (a.cols != b.rows) {
      println("Columsn of A must match rows of B"); 
      return null;
    }

    Matrix ret = new Matrix(a.rows, b.cols); 
    
    for(int i = 0; i < a.rows; i++){
       for(int j = 0; j < b.cols; j++){
          for(int k = 0; k < a.cols; k++){
             ret.data[i][j] += a.data[i][k] * b.data[k][j];  
          }
       }
    }
    return ret; 
  }
  
  Matrix multiply(Matrix n){
   
     if(this.rows != n.rows || this.cols != n.cols){
        println("Columns and Rows of A must match Columns and Rows of B."); 
        return null; 
        
     }
     else{
         Matrix ret = new Matrix(this.rows, this.cols); 
         for(int i = 0; i < this.rows; i++){
             for(int j = 0; j < this.cols; j++){
                ret.data[i][j] = this.data[i][j] * n.data[i][j];  
             }
         }
         return ret; 
     }
  }
  
  void multiply(int n){
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        this.data[i][j] *= n;
      }
    }
    
  }
  void console(){
    for(int i = 0; i < this.rows; i++){
       for(int j = 0; j < this.cols; j++){
         print(" ", this.data[i][j]);  
       }
       println(); 
    }
  }
}