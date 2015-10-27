import numpy as np
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers.core import Dense


class Ann(object):

    def __init__(self, data, train, learning_rate, max_iter=100):
        # initialize object instances
        self.data = data
        self.train = train
        self.learning_rate = learning_rate
        self.max_iter = max_iter

        # design for action function
        self.activation_func = self.sigmoid

        # basic data read and processing
        self.N, self.r = self.data.shape
        self.X = self.data[:, 0:(self.r - 1)]
        y_temp = self.data[:, self.r - 1]
        self.Y = np.zeros(self.N * 10).reshape((self.N, 10))
        for i in range(self.N):
            self.Y[i, y_temp[i] - 1] = 1

        # split the data into train and test
        np.random.seed(1)
        self.sample = np.random.choice(self.N, np.round(self.N * train), replace=False)
        self.trainX = self.X[self.sample, :]
        self.testX = np.delete(self.X, self.sample, 0)
        self.trainY = self.Y[self.sample]
        self.testY = np.delete(self.Y, self.sample)
        self.train_size = self.trainX.shape[0]
        self.test_size = self.testX.shape[0]

    @staticmethod
    def sigmoid(z):
        # This is the sigmoid function
        return 1 / (1 + np.exp(-z))

    @staticmethod
    def theta_part2(a):
        # this calculate the second part, the common part of theta
        return (1 - a) * a

    @staticmethod
    def dim_expand(x):
        # add an extra 1s to a matrix
        n = x.shape
        if len(n) == 1:
            ones = np.ones([1, 1])
        else:
            ones = np.ones([n[0], 1])
        result = np.hstack([ones, x])
        return result

    @staticmethod
    def weight_init(r, c):
        # initialize a vector by row and column dimensions
        return np.random.rand(r, c)

    @staticmethod
    def error_compute(y, a):
        # it is the calculation of rss
        return 0.5 * list(map(sum, np.square(y - a)))[0]

    def forward_prop(self, a1, w1, w2):
        # This is the forward step of the ann algorithm

        # input layer
        a1 = a1

        # hidden layer
        z2 = np.dot(a1, w1)
        a2 = self.activation_func(z2)
        a2 = self.dim_expand(a2)

        # output layer
        z3 = np.dot(a2, w2)
        a3 = self.activation_func(z3)

        # return value
        return z2, a2, z3, a3

    def backward_feed_last(self, y, a3, a2, weight2):
        # this calculates all the data used from the output layer to the hidden layer

        # parts of theta
        theta3_part1 = y - a3
        theta3_part2 = self.theta_part2(a3)
        # multiply theta
        theta3 = theta3_part1 * theta3_part2
        # update weight by calling the weight_update function
        weight2 = self.weight_update(weight2, theta3, a2)
        # return value
        return theta3, weight2

    def backward_feed_prev(self, theta3, a2, weight2, a1, weight1):
        # this calculates all the data used from the hidden layer to the input layer

        # parts of theta
        theta2_part1 = np.dot(weight2[1:, ], theta3.T)
        theta2_part2 = self.theta_part2(a2[:, 1:])
        # multiple theta
        theta2 = theta2_part1.T * theta2_part2
        # update weight by calling the weight_update function
        weight1 = self.weight_update(weight1, theta2, a1)
        # return value
        return theta2, weight1

    def weight_update(self, weight, theta, a):
        # update data by SGD algorithm
        return weight + self.learning_rate * np.dot(a.T, theta)

    def forward_backward(self, a1, y, weight1, weight2):
        # This function links the forward part and backward steps
        _, a2, _, a3 = self.forward_prop(a1, weight1, weight2)
        theta3, weight2 = self.backward_feed_last(y, a3, a2, weight2)
        theta2, weight1 = self.backward_feed_prev(theta3, a2, weight2, a1, weight1)
        return weight1, weight2, a3

    def plot_error(self, error):
        # This function plots the error in train set in each iteration
        plt.plot(np.arange(self.max_iter).reshape((1, self.max_iter)), error, 'o')
        plt.title("error plot")
        plt.show()

    @staticmethod
    def plot_single(obj):
        # This function accepts a 2-dim array that has iterations. It just plot each dimension of the array
        # in the aspect of iterations
        list(map(lambda x: plt.plot(x), obj))
        plt.show()

    def plot_outputs(self, output):
        # This function accepts a 3-dim output array and split it into 2-dim array and then pass the remaining
        # job to plot_single
        list(map(self.plot_single, output))

    def plot_weights(self, weight1_total, weight2_total):
        # This function accepts a 3-dim weight array and split it into 2-dim array and then pass the remaining
        # job to plot_single
        list(map(self.plot_single, weight1_total))
        list(map(self.plot_single, weight2_total))

    def plot_total(self, error, output, weight1_total, weight2_total):
        # This function combines all the plot steps together
        self.plot_error(error)
        self.plot_outputs(output)
        self.plot_weights(weight1_total, weight2_total)

    def ann_regression_one(self, train_flag=True, hidden=3, last=10):
        # initialize weight vectors
        weight1 = self.weight_init(self.r, hidden)
        weight2 = self.weight_init(hidden + 1, last)

        # update the data by the train flag
        if train_flag:
            data_x = self.trainX
            data_y = self.trainY
        else:
            data_x = self.X
            data_y = self.Y
        regression_size = data_x.shape[0]

        # initial error, output and weights for plot
        error = np.zeros([1, self.max_iter])
        output = np.empty((3, 10, self.max_iter))
        weight1_total = np.empty((3, 9, self.max_iter))
        weight2_total = np.empty((10, 4, self.max_iter))

        # the main loop
        for iteration in range(self.max_iter):
            # initialize error in this iteration
            error_iter = 0

            for i in range(regression_size):
                # initialize a1, y
                a1 = data_x[i, ].reshape(1, self.r - 1)
                a1 = self.dim_expand(a1)
                y = data_y[i, ]

                # ann regression body
                weight1, weight2, a3 = self.forward_backward(a1, y, weight1, weight2)

                # update error, output
                error_iter += self.error_compute(y, a3)

                if i in range(3):
                    output[i, :, iteration] = a3

            # update total error and weights
            error[:, iteration] = error_iter
            weight1_total[:, :, iteration] = weight1.T
            weight2_total[:, :, iteration] = weight2.T

        # mse
        error = error / regression_size

        return weight1, weight2, error, output, weight1_total, weight2_total

    def test_predict(self, weight1, weight2):
        # This function accepts the test data set and the trained weights to predict the result and
        # calculates the error (mse)
        test_error = 0
        for i in range(self.test_size):
            a1 = self.testX[i, ].reshape(1, self.r - 1)
            a1 = self.dim_expand(a1)
            _, _, _, a3 = self.forward_prop(a1, weight1, weight2)
            test_error += self.error_compute(self.testY[i, ], a3)
        test_error /= self.test_size
        return test_error

    def main_three(self, hidden=3, last=10):
        # This function calculates all the result for the first observation in the first iteration round
        # and then give result to compare to my hand written result
        weight1 = self.weight_init(self.r, hidden)
        weight2 = self.weight_init(hidden + 1, last)
        a1 = self.trainX[1, ].reshape(1, self.r - 1)
        a1 = self.dim_expand(a1)
        y = self.trainY[1, ]
        weight1, weight2, a3 = self.forward_backward(a1, y, weight1, weight2)
        print("The first weight is \n")
        print(weight1)
        print("\n")
        print("The second weight is \n")
        print(weight2)
        print("\n")
        print("The output here is \n")
        print(a3)
        return weight1, weight2, a3

    def multiple_layer_node(self, node):
        # This function uses the Keras module to achieve the result for different layers and nodes.
        # Also, this function is a closure: in the outer function it defines the node, and in the
        # inner function it defines the layer
        def multiple_layer(layer, predict_flag=False):
            # initialize model
            model = Sequential()
            # update model by adding input to hidden layer
            model.add(Dense(output_dim=node, input_dim=8, activation='sigmoid'))
            # depending on the number of hidden to hidden layers, add the required layer
            while layer > 1:
                model.add(Dense(output_dim=node, activation='sigmoid'))
                layer -= 1
            # add the hidden to output layer
            model.add(Dense(output_dim=10, activation='sigmoid'))
            # build the model
            model.compile(loss='mse', optimizer='SGD')
            # give the model data, iteration number, training size once a time
            model_result = model.evaluate(self.X, self.Y, batch_size=1)
            print(model_result)
            # if the predict_flag is true, then predict data by the training model just defined
            if predict_flag:
                print('\n')
                predict_value = model.predict_proba(np.array([[0.50, 0.49, 0.52, 0.20, 0.55, 0.03, 0.50, 0.39]]))
                print(predict_value)
        return multiple_layer


def main_one(yeast):
    # This function combines all the steps in question one. First train, then plot, at last test
    weight1, weight2, error, output, weight1_total, weight2_total = yeast.ann_regression_one()
    yeast.plot_total(error, output, weight1_total, weight2_total)
    test_error = yeast.test_predict(weight1, weight2)
    print("The error for test set is \n")
    print(test_error)


def main_two(yeast):
    # This function train the ann with all the data, as required by question two
    weight1, weight2, error, _, _, _, = yeast.ann_regression_one(False)
    print("The training error finally is \n")
    print(error[:, -1])
    print("\n")
    print("And the weight from input layer to hidden layer is \n")
    print(weight1)
    print("\n")
    print("And the weight from hidden layer to output layer is \n")
    print(weight2)


def main_four(yeast):
    # This function calls the multiple_layer_node closure to define layers and nodes needed
    for i in range(3, 13, 3):
        func = yeast.multiple_layer_node(i)
        for j in range(1, 4):
            print("Now with node %d, layer %d \n" % (i, j))
            func(j)
            print("\n")


def main_five(yeast):
    # This function uses the 3 layers and 12 nodes model to predict the result
    yeast.multiple_layer_node(9)(3, True)


def main():
    # this function is the main function to call each function that accomplish the tasks asked by each question
    yeast_data = np.genfromtxt("yeast.txt")
    yeast = Ann(yeast_data, 0.65, 0.1)
    # main_one(yeast)
    # main_two(yeast)
    # yeast.main_three()
    # main_four(yeast)
    main_five(yeast)


if __name__ == "__main__":
    main()
