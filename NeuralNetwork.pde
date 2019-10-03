Matrix applySigmoid(Matrix m) {
  Matrix result = new Matrix(m.rows, m.cols); 

  for (int i = 0; i < result.rows; i++) {
    for (int j = 0; j < result.cols; j++) {
      result.data[i][j] = sigmoid(m.data[i][j]);
    }
  }

  return result;
}

float sigmoid(float x) {
  return 1/(float)(1 + Math.pow(Math.E, -x));
}

class NeuralNetwork {
  float learningRate = 0.1; 
  int inputs; 
  int outputs; 
  int hidden; 
  Matrix weights_ih; 
  Matrix weights_ho; 
  Matrix bias_h; 
  Matrix bias_o; 
  public NeuralNetwork(int inputs, int hidden, int outputs) {
    this.inputs = inputs; 
    this.hidden = hidden; 
    this.outputs = outputs; 
    weights_ih = new Matrix(this.hidden, this.inputs); 
    weights_ho = new Matrix(this.outputs, this.hidden); 

    weights_ih = weights_ih.randomize(); 
    weights_ho = weights_ho.randomize(); 

    //weights_ih.console();
    //weights_ho.console(); 

    bias_h = new Matrix(this.hidden, 1); 
    bias_o = new Matrix(this.outputs, 1); 

    bias_h.randomize(); 
    bias_o.randomize();
  }

  void setLearningRate(float learningRate) {
    this.learningRate = learningRate;
  }

  float[] query(float[] inputs) {
    Matrix inputMatrix = new Matrix(0, 0); 
    inputMatrix = inputMatrix.fromArray(inputs); 
    //println("inputMatrix:, ");
    //inputMatrix.console();
    //println("weights_ih:");
    //weights_ih.console();
    Matrix hidden_inputs = inputMatrix.multiply(this.weights_ih, inputMatrix); 
    //println("hidden_inputs:");
    //hidden_inputs.console(); 
    Matrix hidden_outputs = applySigmoid(hidden_inputs); 

    Matrix output_inputs = hidden_outputs.multiply(this.weights_ho, hidden_outputs); 

    Matrix outputs = applySigmoid(output_inputs);
    //println("output:"); 
    //outputs.console(); 
    return outputs.toArray();
  }

  NeuralNetwork clone() {
    return new NeuralNetwork(this.inputs, this.hidden, this.outputs);
  }

  void mutate() {
    for (int i = 0; i < weights_ih.rows; i++) {
      for (int j = 0; j < weights_ih.cols; j++) {
        if (random(1) < 0.05) {
          float x = weights_ih.data[i][j]; 
          float offset = randomGaussian() * 0.5;
          // var offset = random(-0.1, 0.1);
          float newx = x + offset;
          weights_ih.data[i][j] = newx;
        }
      }
    }
    
    for (int i = 0; i < weights_ho.rows; i++) {
      for (int j = 0; j < weights_ho.cols; j++) {
        if (random(1) < 0.1) {
          float x = weights_ho.data[i][j]; 
          float offset = randomGaussian() * 0.5;
          // var offset = random(-0.1, 0.1);
          float newx = x + offset;
          weights_ho.data[i][j] = newx;

        }
      }
    }
  }
  
}