import numpy as np
import random
from PIL import Image
import matplotlib.pyplot as plt

def cluster_points(X, mu):
    clusters = {}
    for x in X:
        bestmukey = min([(i[0], np.linalg.norm(x-mu[i[0]]))
                         for i in enumerate(mu)], key=lambda t: t[1])[0]
        try:
            clusters[bestmukey].append(x)
        except KeyError:
            clusters[bestmukey] = [x]
    return clusters


def reevaluate_centers(mu, clusters):
    newmu = []
    keys = sorted(clusters.keys())
    for k in keys:
        newmu.append(np.mean(clusters[k], axis=0))
    return newmu


def has_converged(mu, oldmu):
    return (set([tuple(a) for a in mu]) == set([tuple(a) for a in oldmu]))


def find_centers(X, K):
    # Initialize to K random centers
    oldmu = random.sample(list(X), K)
    mu = random.sample(list(X), K)
    while not has_converged(mu, oldmu):
        oldmu = mu
        # Assign all points in X to clusters
        clusters = cluster_points(X, mu)
        # Reevaluate centers
        mu = reevaluate_centers(oldmu, clusters)
    return(mu, clusters)


def init_board(N):
    X = np.array([(random.uniform(-1, 1), random.uniform(-1, 1))
                 for i in range(N)])
    return X


def init_board_gauss(N, k):
    n = float(N)/k
    X = []
    for i in range(k):
        c = (random.uniform(-1, 1), random.uniform(-1, 1))
        s = random.uniform(0.05, 0.5)
        x = []
        while len(x) < n:
            a, b = np.array([np.random.normal(c[0], s),
                            np.random.normal(c[1], s)])
            # Continue drawing points from the distribution in the range [-1,1]
            if abs(a) < 1 and abs(b) < 1:
                x.append([a, b])
        X.extend(x)
    X = np.array(X)[:N]
    return X

# def generateImage():
#     # img = Image.new('RGB', (width, height), color = 'green')
#     # px1 = img.load()


k = 20
# x = init_board(100)
x = init_board_gauss(200, k)

# print(x)
# print (find_centers(x, k)[0])

temp = find_centers(x, k)[1]
x1 = []
y1 = []
print(len(x1))
print(temp[0][0])
for i in range(len(temp)):
    x1.append(temp[i][0])
    y1.append(temp[i][1])

area = 10
colors = "blue"
plt.scatter(x1, y1, s=area, c=colors, alpha=0.5)
plt.show()



