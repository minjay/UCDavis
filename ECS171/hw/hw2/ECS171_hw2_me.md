# ECS171 homework 2

## Zhen Zhang

### Question 1	

​	For this question I write the algorithm all by myself in python.

​	The first step is use R to preprocess the data a little bit, and I attach the R code in the folder. Next I will explain the basic structure of my python code.

​	I define a class named Ann, that can accepts data, train percentage, learning rate and maximum iteration as the inputs. First I define some static methods in class as tools to do subsequent jobs, including sigmoid (the transformation function), theta_part2 (which calculates part two of each theta), dim_expand (add an 1 at dimension 0 to the input data), weight_init (initialize weight by the required row and column number), error_compute (compute error using RSS method). 

​	Where n is the number of observations of the data set, m is the number of output neuros, in this problem, 10.

​	Now back to the code. Next comes the next part, forward_prop implements the process of going forward, and it supplies a2 and a3 to the next function, backward. There are two parts of backward function, one from output to hidden, and another from hidden to input. This code format supports multiple dimension, so adding an extra hidden layer can also be achieved. Inside them there are function to update weight (weight_update) and at last, the forward_backward function combines them together.

​	Next is the plot area. I give the error, output and weights required to plot the result, and they call the corresponding result it need to plot the diagram. Inside plot_output and plot_weight, I use them to call the plot_single function to plot each iteration by calling the map function. At last, I combine them into plot_total to do all the things altogether.

​	Next is the main regression function ann_regression_one, it first initialize the weight vector, then depending on I need the train data or the whole data, it calls the corresponding property of the class object. It also initializes the output, weights and error to fill in afterwards. After that it updates the weights in each iteration by each observation, and it is what should be done in stochastic gradient descent (SGD). In the iteration, it fills output, weights and error by the right value. It returns the output, weights and error as the return value to be used by other functions.

​	They are enough for the first question, and the remaining function will be introduced in the following question. Now I will show the results.

​	First I will show you the error plot for each iteration: ![figure1](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure1.png)

​	It seems the error is decreasing in most of the time, and the final train error becomes about 0.32.

​	Second I will show the first three outputs:

 ![figure2.1](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure2.1.png)

 ![figure2.2](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure2.2.png)

 ![figure2.3](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure2.3.png)

​	Each line represents the value in each of the ten classes. Now we can see that in each plot, there is one of more value larger than the rest, which will be the classified class. After I check the result, they are the same.

​	Now I will show the weights of input to hidden. Since there are three neuros in hidden layer, I will display three plots, one for each neuros, with nine lines representing the link from the previous node to this one:

​	 ![figure3.1](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure3.1.png)

 ![figure3.2](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure3.2.png)

 ![figure3.3](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure3.3.png)

​	Now comes the weights from hidden to output layer:

 ![figure4.1](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.1.png)

 ![figure4.2](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.2.png)

 ![figure4.3](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.3.png)

 ![figure4.4](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.4.png)

 ![figure4.5](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.5.png)

 ![figure4.6](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.6.png)

 ![figure4.7](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.7.png)

 ![figure4.8](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.8.png)

 ![figure4.9](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.9.png)

 ![figure4.10](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/figure4.10.png)

​	I note here that the weights are:

​	weight1:    ![Screen Shot 2015-10-26 at 11.00.04 PM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-26 at 11.00.04 PM.png)

​	weight2:  ![Screen Shot 2015-10-26 at 11.00.35 PM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-26 at 11.00.35 PM.png)

​	After the plot, I will use the training weights to estimate the test dataset. The test error is: 0.487674704055.

  ![Screen Shot 2015-10-26 at 11.03.32 PM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-26 at 11.03.32 PM.png)



### Question 2

​	In the second question, I just use all the dataset instead of the 65% training dataset. This can be easily achieved, as I mentioned before, modify the train flag to false in the ann_regreesion_one function.

​	The result is:

​	 ![Screen Shot 2015-10-26 at 11.06.08 PM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-26 at 11.06.08 PM.png)

​	This error is a little smaller than data with only 65% training. The next is weight1, and last one is weight2.

​	The activation function is:

$$
a2 = sigmoid(weight1 * a1) = \frac{1}{1+e^{-(weight1 * a1)}}
$$

$$
a3 = sigmoid(weight2 * a2) = \frac{1}{1+e^{-(weight2 * a2)}}
$$

​	we can substitute weight1, weight2, a1, a2 to these activation functions.

### Question 3

​	I first provide the hand written snapshot:

​	 ![IMG_0625](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/IMG_0625.jpg)

 ![IMG_0626](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/IMG_0626.jpg)

​	And here is the algorithm output in main_three():

​	 ![Screen Shot 2015-10-26 at 11.18.11 PM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-26 at 11.18.11 PM.png)

### Question 4

​	In this problem, I use the package of Keras in python. It provides a simple  and user-friendly interface, which depends on numpy and theano. The function multiple_layer_node is a closure that implements this function by providing node, and its inner function will provide the layer. Here I will first show the snapshot and then give a summary table:

​	 ![Screen Shot 2015-10-26 at 11.56.43 PM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-26 at 11.56.43 PM.png)

 ![Screen Shot 2015-10-26 at 11.56.45 PM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-26 at 11.56.45 PM.png)

​	Now summary them into a table:

| layer/node | 3     | 6     | 9     | 12    |
| ---------- | ----- | ----- | ----- | ----- |
| 1          | 0.253 | 0.288 | 0.300 | 0.226 |
| 2          | 0.302 | 0.244 | 0.223 | 0.254 |
| 3          | 0.244 | 0.288 | 0.18  | 0.261 |

​	From the table, we can see that in layer 2 or 3, with the increase of node number, the error rate first decreases then increases, this may be a sign of overfit when increasing. The node 9 is best in layer 2 or layer 3. Also, the error of layer 3 is the best compared with layer 1 or 2, meaning it is a little accurate when adding layers, but also attention should be paid to overfit.

​	Node 9 with layer 3 is the best model to choose.

### Question 5

​	Here by calling the main_five() function, it calls the multiple_layer_node by supplying the best model (node 9, layer 3) found in the previous problem, and the result is:

​	 ![Screen Shot 2015-10-27 at 12.05.56 AM](/Users/Elliot/Github/UCDavis/ECS171/hw/hw2/figs/Screen Shot 2015-10-27 at 12.05.56 AM.png)

​	Since 0.74806002 is the largest compared to others, so it belongs to the eighth class, which is 'NUC'.

### Question 6

​	Let me talk about the method I used in question 1 - 5 when handling the response variable (y).

​	There are ten classes for the response value, I encode them to ten 0-1 value sets. It means, for example, if one observation belongs to the seventh class, the response variable after encoding will be (0,0,0,0,0,0,1,0,0,0). The predicted value with the largest value will be the classified class. For example, if the output is (0.1,0.1,0.1,0.9,0.1,0.1,0.1,0.1,0.1,0.1), the class will be the fourth one. I have also considered to use 0-9 as the response value, but it is not a good idea, since this method mis-consider the ratio effect and interval effect. They are basic principles in statistics, which makes this approach invalid.

​	Also mention here, the RSS is the measure of error:

$$
RSS = \frac{1}{2}\sum_{j=1}^n\sum_{i=1}^m( y_{ij} - a_{ij})^2
$$

​	When measuring uncertainty, since the output is a value between 0  and 1, so the larger the value, the more certain it should belong to the class, and the less the value, the less certain it should belong to that class.