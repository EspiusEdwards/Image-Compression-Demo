import matplotlib.pyplot 
from sklearn.cluster import KMeans
import numpy
image = matplotlib.pyplot.imread("kmeans.jpg")
img_shape = image.shape
print (img_shape)
w = img_shape[0]
h = img_shape[1]
image = image.reshape(w*h,3)
print(image)
K = int(input("Enter K: "))
run = KMeans(n_clusters = K).fit(image)
labels = run.predict(image)

clusters = run.cluster_centers_

print(clusters)
print(labels)
# zero: 0, like: dimension like image
# new_image = numpy.zeros_like(image)
new_image = numpy.zeros((w,h,3), dtype=numpy.uint8)
x = 0
# reshape by self
for i in range(w):
    for j in range(h):
        new_image[i][j] = clusters[labels[x]]
        x += 1
# for i in range(len(new_image)):
#     new_image[i] = clusters[labels[i]]
# new_image = new_image.reshape(w, h, 3)
matplotlib.pyplot.imshow(new_image)
matplotlib.pyplot.show()

